import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/paymentdonationpage.dart';

class MyDonation extends StatefulWidget {
  final MyPet pet;
  final User? user;

  const MyDonation({super.key, required this.pet, required this.user});

  @override
  State<MyDonation> createState() => _MyDonationState();
}

class _MyDonationState extends State<MyDonation> {
  TextEditingController donationAmountController = TextEditingController();
  String selectedDonationType = 'Food';
  bool isSubmittingRequest = false;

  @override
  void dispose() {
    donationAmountController.dispose();
    super.dispose();
  }

  // here will be displayed the donation options and submission button
  // the donation will only appear if the user click the pet that category is donation
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Make a Donation",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "Select Donation Type",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['Food', 'Medical', 'Money'].map((type) {
            return ChoiceChip(
              label: Text(type),
              selected: selectedDonationType == type,
              onSelected: (selected) {
                setState(() {
                  selectedDonationType = type;
                  if (type != 'Money') {
                    donationAmountController.clear();
                  }
                });
              },
              selectedColor: const Color.fromARGB(255, 87, 152, 154),
              labelStyle: TextStyle(
                color: selectedDonationType == type
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (selectedDonationType == 'Money')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Donation Amount (RM)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: donationAmountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  prefixText: 'RM ',
                  hintText: "Enter amount",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(148, 66, 65, 65),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
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
            onPressed: isSubmittingRequest ? null : _submitDonation,
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
                    "Submit Donation",
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

  void _submitDonation() {
    if (widget.user == null ||
        widget.user?.userId == null ||
        widget.user?.userId == '0') {
      return;
    }

    if (selectedDonationType == 'Money') {
      if (donationAmountController.text.trim().isEmpty) {
        return;
      }
      _openPaymentPage();
    } else {
      _showConfirmationDialog();
    }
  }

  void _openPaymentPage() async {
    final donationAmount = donationAmountController.text.trim();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDonationPage(
          user: widget.user!,
          pet: widget.pet,
          amount: donationAmount,
        ),
      ),
    );

    _submitDonationToAPI();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Submit Donation"),
        content: Text(
          "Are you sure you want to submit this $selectedDonationType donation?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitDonationToAPI();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void _submitDonationToAPI() {
    setState(() {
      isSubmittingRequest = true;
    });

    Map<String, String> body = {
      "user_id": widget.user!.userId.toString(),
      "pet_id": widget.pet.pet_id.toString(),
      "donation_type": selectedDonationType,
    };

    if (selectedDonationType == 'Money') {
      body["amount"] = donationAmountController.text.trim();
    }

    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_donation.php'),
          body: body,
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
                  content: Text("Donation submitted successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
              donationAmountController.clear();
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
