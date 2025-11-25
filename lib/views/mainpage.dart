import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';

class MainPage extends StatefulWidget {
  final User? user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    String displayName = widget.user?.userName ?? 'User';

    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome,', style: TextStyle(fontSize: 24)),
            // Display the user's name in bold
            Text(
              displayName,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('This is the main page.'),
          ],
        ),
      ),
    );
  }
}
