import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/login.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:pawpal/views/profilepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  User? user;
  MyDrawer({super.key, required this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late double height;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 87, 152, 154),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  '${MyConfig.baseUrl}/pawpal/assets/profiles/${widget.user?.userId}.png?t=${DateTime.now().millisecondsSinceEpoch}',
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        widget.user?.userName?.substring(0, 1).toUpperCase() ??
                            'U',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Color.fromARGB(255, 87, 152, 154),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            accountName: Text(
              widget.user?.userName ?? "User",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(widget.user?.userEmail ?? ""),
          ),

          ListTile(
            leading: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 87, 152, 154),
            ),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(user: widget.user),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 87, 152, 154),
            ),
            title: const Text("Profile"),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: widget.user!),
                ),
              );
              await loadProfile();
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 87, 152, 154),
            ),
            title: const Text("Donation List"),
            onTap: () {
              Navigator.pop(context);
              _showDonationModal(context);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log out"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await SharedPreferences.getInstance().then(
                          (value) => value.remove("user"),
                        );
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(
            height: height / 3,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "PawPal",
                  style: TextStyle(
                    color: Color.fromARGB(255, 72, 38, 44),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text("Version 0.1", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDonationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DonationListModal(user: widget.user!),
    );
  }

  Future<void> loadProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey('user')) {
      if (mounted) {
        setState(() {
          widget.user = User.fromJson(jsonDecode(pref.getString('user')!));
        });
      }
    }
  }
}

class DonationListModal extends StatefulWidget {
  final User user;
  const DonationListModal({super.key, required this.user});

  @override
  State<DonationListModal> createState() => _DonationListModalState();
}

class _DonationListModalState extends State<DonationListModal> {
  List<dynamic> donations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    try {
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/get_user_donations.php'),
        body: {'user_id': widget.user.userId.toString()},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            donations = data['donations'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load donations';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.6,
      maxChildSize: 1,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 87, 152, 154),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Donations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : donations.isEmpty
                  ? const Center(child: Text('No donations yet'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: donations.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        var donation = donations[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pet ID: ${donation['pet_id']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getDonationTypeColor(
                                          donation['donation_type'],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        donation['donation_type'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (donation['donation_type'] == 'Money')
                                  Text(
                                    'Amount: RM ${donation['amount']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  'Date: ${donation['created_at']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDonationTypeColor(String type) {
    switch (type) {
      case 'Food':
        return Colors.orange;
      case 'Medical':
        return Colors.red;
      case 'Money':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
