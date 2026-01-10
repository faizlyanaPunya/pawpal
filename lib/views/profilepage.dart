import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  Uint8List? profileImageBytes;
  DateFormat dateformat = DateFormat('dd/MM/yyyy');
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    nameController.text = widget.user.userName ?? '';
    emailController.text = widget.user.userEmail ?? '';
    phoneController.text = widget.user.userPhone ?? '';
  }

  //upload image from gallery (web only!)
  Future<void> _pickProfileImage() async {
    // will check if not web
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This feature is only available on web"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        profileImageBytes = bytes;
      });
    }
  }

  //update profile
  Future<void> _updateProfile() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      String profileImageBase64 = 'NA';
      if (profileImageBytes != null) {
        profileImageBase64 = base64Encode(profileImageBytes!);
      }

      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_user_profile.php'),
        body: {
          'userid': widget.user.userId ?? '',
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'profile_image': profileImageBase64,
        },
      );

      print("Update response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Update user object
          widget.user.userName = data['data'][0]['name'];
          widget.user.userPhone = data['data'][0]['phone'];
          widget.user.imagePath = data['data'][0]['image_path'];

          // here will save user session and
          // save updated user to SharedPreferences
          await _saveUserSession();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: Colors.green,
            ),
          );

          // Clear the selected image
          setState(() {
            profileImageBytes = null;
          });

          // here is to reload profile, if user click the
          //reload button at the profile page
          await _loadProfile();
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? "Update failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server error. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error updating profile: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _saveUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(widget.user.toJson()));
  }

  Future<void> _loadProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/get_user_profile.php?userid=${widget.user.userId}',
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("Load profile response: ${response.body}");

        if (data['status'] == true) {
          setState(() {
            widget.user.userName = data['data']['name'];
            widget.user.userPhone = data['data']['phone'];
            widget.user.imagePath = data['data']['image_path'];
            _loadUserData();
          });

          // Save to SharedPreferences
          await _saveUserSession();
        }
      }
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  String _getProfileImageUrl() {
    if (widget.user.imagePath != null && widget.user.imagePath!.isNotEmpty) {
      return '${MyConfig.baseUrl}/pawpal/${widget.user.imagePath}?t=${DateTime.now().millisecondsSinceEpoch}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width > 500
        ? 500.0
        : MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 87, 152, 154),
        foregroundColor: Colors.white,
        titleSpacing: 16,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _loadProfile,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        /// here to upload profile image
                        GestureDetector(
                          onTap: _pickProfileImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[300],
                                child: _buildProfileImage(),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 87, 152, 154),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Tap to change photo",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 20),
                        _readonlyField("User ID", widget.user.userId),
                        const SizedBox(height: 12),
                        _readonlyField("Email", widget.user.userEmail),
                        const SizedBox(height: 12),

                        const Divider(height: 30),
                        const SizedBox(height: 8),

                        _inputField(
                          controller: nameController,
                          label: "Name",
                          icon: Icons.person,
                          keyboard: TextInputType.name,
                        ),

                        const SizedBox(height: 12),

                        _inputField(
                          controller: phoneController,
                          label: "Phone Number",
                          icon: Icons.phone_outlined,
                          keyboard: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                255,
                                87,
                                152,
                                154,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isLoading ? null : _updateProfile,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Save Changes",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 72, 38, 44),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    // if new image is selected, show it
    if (profileImageBytes != null) {
      return ClipOval(
        child: Image.memory(
          profileImageBytes!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }

    // if profile picture already upload, load from network
    String imageUrl = _getProfileImageUrl();
    if (imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
        ),
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 87, 152, 154),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.user.userName?.substring(0, 1).toUpperCase() ?? 'U',
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // here is to readonly field
  // the user cannot be change
  // email and user id
  Widget _readonlyField(String label, String? value) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value ?? "-"),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color.fromARGB(255, 87, 152, 154),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color.fromARGB(255, 247, 242, 248),
      ),
    );
  }

  // here is to input field
  // the user can be change
  // name and phone number
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 87, 152, 154)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 87, 152, 154),
            width: 2,
          ),
        ),
      ),
    );
  }
}
