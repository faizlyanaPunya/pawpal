import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mydonation.dart';

class PetDetailsPage extends StatefulWidget {
  final MyPet pet;
  final User? user;
  const PetDetailsPage({super.key, required this.pet, required this.user});

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  TextEditingController motivationController = TextEditingController();
  static const Color unifiedColor = Color.fromARGB(255, 87, 152, 154);
  bool isSubmittingRequest = false;

  @override
  void dispose() {
    motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.pet_name ?? "Pet Details"),
        backgroundColor: Color.fromARGB(255, 87, 152, 154),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 202, 223, 238),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(110, 58, 48, 48),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                          backgroundImage: NetworkImage(
                            '${MyConfig.baseUrl}/pawpal/assets/pets/pet_${widget.pet.pet_id}_1.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.pet.pet_name ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // here is the content section
            // Info displayed  : type, gender, age, health, category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: const Color.fromARGB(255, 254, 247, 255),
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.pets, color: unifiedColor),
                              const SizedBox(width: 12),
                              Text(
                                "Type:  ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${widget.pet.pet_type ?? "Unknown"}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Row(
                            children: [
                              Icon(Icons.wc, color: unifiedColor),
                              const SizedBox(width: 12),
                              Text(
                                "Gender: ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${widget.pet.pet_gender ?? "Unknown"}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Row(
                            children: [
                              Icon(Icons.calendar_month, color: unifiedColor),
                              const SizedBox(width: 12),
                              Text(
                                "Age: ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${widget.pet.pet_age != null ? "${widget.pet.pet_age} years old" : "Unknown"}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Row(
                            children: [
                              Icon(
                                Icons.health_and_safety,
                                color: unifiedColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Health: ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${widget.pet.pet_health ?? "Unknown"}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: unifiedColor),
                              const SizedBox(width: 12),
                              Text(
                                "Catergory: ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${widget.pet.category ?? "Unknown"}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // this is the description section
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      color: const Color.fromARGB(255, 254, 247, 255),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.description, color: unifiedColor),
                                const SizedBox(width: 8),
                                const Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.pet.description ??
                                  "No description provided.",
                              style: TextStyle(
                                fontSize: 15,
                                color: const Color.fromARGB(255, 101, 101, 101),
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // this is the posted by section
                  // who posted the pet at the platform
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 247, 255),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: unifiedColor),
                            const SizedBox(width: 8),
                            const Text(
                              "Posted By",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (widget.pet.name != null)
                          Text("Name: ${widget.pet.name}"),
                        if (widget.pet.email != null)
                          Text("Email: ${widget.pet.email}"),
                        if (widget.pet.phone != null)
                          Text("Phone: ${widget.pet.phone}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // here wil be the section where, if category is adoption, show adoption request form
                  // if category is donation, show donation management section
                  if (widget.pet.category == "Adoption")
                    _buildAdoptionSection()
                  else if (widget.pet.category == "Donation")
                    MyDonation(pet: widget.pet, user: widget.user),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Adoption Request Section
  // this will only show if the pet category is adoption
  Widget _buildAdoptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 20),
            Icon(Icons.request_page, color: unifiedColor),
            const SizedBox(width: 8),
            const Text(
              "Request to Adopt",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: motivationController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Share your motivation for adopting...",
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
            ),

            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 76, 175, 80),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: isSubmittingRequest ? null : submitAdoptionRequest,
            child: isSubmittingRequest
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Submit Adoption Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // Adoption Request
  void submitAdoptionRequest() {
    if (widget.user == null ||
        widget.user?.userId == null ||
        widget.user?.userId == '0') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // validation if user didnt put
    //anything at the motivation textfield
    if (motivationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter motivation message"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // if the motivation message is less than 10 characters
    if (motivationController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Motivation must be at least 10 characters"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // confirmation dialog if they user want to request to adopt pet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Submit Adoption Request"),
        content: const Text("Are you sure you want to submit this request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              submitAdoptionToAPI();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void submitAdoptionToAPI() {
    setState(() {
      isSubmittingRequest = true;
    });

    http
        .post(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/submit_adoption_request.php',
          ),
          body: {
            "user_id": widget.user!.userId.toString(),
            "pet_id": widget.pet.pet_id.toString(),
            "motivation_message": motivationController.text.trim(),
          },
        )
        .then((response) {
          log("Response: ${response.body}");

          setState(() {
            isSubmittingRequest = false;
          });

          if (response.statusCode == 200) {
            var res = jsonDecode(response.body);

            if (res['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Request submitted successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
              motivationController.clear();
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(res['message'] ?? "Failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        })
        .catchError((error) {
          setState(() {
            isSubmittingRequest = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: $error"),
              backgroundColor: Colors.red,
            ),
          );
        });
  }
}
