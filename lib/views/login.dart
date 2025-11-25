import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/registerpage.dart';
import 'package:pawpal/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool visible = true;
  bool isChecked = false;
  late User user;

  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Image.asset('assets/images/pawpal.png', scale: 1.5),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 10),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 101, 98, 98),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: const Color.fromARGB(255,87, 152, 154),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: TextField(
                controller: passwordController,
                obscureText: visible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 101, 98, 98),
                  ),
                  prefixIcon: Icon(
                    Icons.password,
                    color: const Color.fromARGB(255,87, 152, 154),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      visible = !visible;
                      setState(() {});
                    },
                    icon: Icon(Icons.visibility),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      isChecked = value!;
                      setState(() {});
                      if (isChecked) {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          prefUpdate(isChecked);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Preferences Saved'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter email and password to save preferences',
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          isChecked = false;
                          setState(() {});
                        }
                      } else {
                        prefUpdate(isChecked);
                        if (emailController.text.isEmpty &&
                            passwordController.text.isEmpty) {
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Preferences Removed'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                        emailController.clear();
                        passwordController.clear();
                        setState(() {});
                      }
                    },
                  ),
                  Text('Remember Me'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    loginuser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255,87, 152, 154),
                  ),
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: Text('Dont have an account? Register here.'),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  void prefUpdate(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setBool('isChecked', isChecked);
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
    } else {
      prefs.remove('isChecked');
      prefs.remove('email');
      prefs.remove('password');
    }
  }

  void loadPref() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('isChecked');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        isChecked = true;
        setState(() {});
      }
    });
  }

  void loginuser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/login.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            log(jsonResponse);
            var resarray = jsonDecode(jsonResponse);
            if (resarray['status'] == 'success') {
              //print(resarray['data'][0]);
              user = User.fromJson(resarray['data'][0]);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigator.pop(context);
              // Navigate to home page or dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage(user: user)),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
            // Handle successful login here
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}
