import 'package:flutter/material.dart';
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDonationPage extends StatefulWidget {
  final User user;
  final MyPet pet;
  final String amount;
  const PaymentDonationPage({
    super.key,
    required this.user,
    required this.pet,
    required this.amount,
  });

  @override
  State<PaymentDonationPage> createState() => _PaymentDonationPageState();
}

class _PaymentDonationPageState extends State<PaymentDonationPage> {
  void initState() {
    super.initState();
    _launchPaymentUrl();
  }

  Future<void> _launchPaymentUrl() async {
    final userEmail = widget.user.userEmail.toString();
    final userPhone = widget.user.userPhone.toString();
    final userName = widget.user.userName.toString();
    final userID = widget.user.userId.toString();
    final petID = widget.pet.pet_id.toString();
    final amount = widget.amount;

    final String url =
        '${MyConfig.baseUrl}/pawpal/api/payment.php?'
        'email=$userEmail&phone=$userPhone&userid=$userID&name=$userName&pet_id=$petID&amount=$amount';

    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        // here will launch the url. 
        //LaunchMode.externalApplication opens a new browser tab on Web
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        if (mounted) Navigator.pop(context);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color.fromARGB(255, 87, 152, 154)),
            SizedBox(height: 20),
            Text(
              "Redirecting to Billplz Payment Gateway...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
