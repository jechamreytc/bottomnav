import 'dart:convert';

import 'package:bottomnav/Security/login_admin.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/createroomBG3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0, // Adjust the blur intensity
                sigmaY: 5.0, // Adjust the blur intensity
              ),
              child: Container(
                color:
                    Colors.black.withOpacity(0), // You can adjust the opacity
              ),
            ),
          ),
          Center(
            child: Container(
              width: double.infinity, // Ensure it takes the space it needs
              padding:
                  EdgeInsets.all(16.0), // Add some padding around the contents
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10), // Adds rounded corners similar to a Card
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/descriptionBG1.png'), // Your image path
                  fit: BoxFit.cover, // Covers the area of the container
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use the minimum space
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Register Account",
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 85,
                      right: 85,
                    ),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cinzel',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 85,
                      right: 85,
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cinzel',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      register();
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 137, 113, 44)
                            .withOpacity(1),
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              'assets/images/buttonBG3.jpg',
                              width: 200,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 40,
                              right: 40,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Cinzel',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void register() async {
    try {
      Map<String, String> jsonData = {
        "username": _usernameController.text,
        "password": _passwordController.text,
      };
      Map<String, String> requestBody = {
        "json": jsonEncode(jsonData),
        "operation": "signup",
      };

      var res = await http.post(
        Uri.parse("${SessionStorage.url}user.php"),
        body: requestBody,
      );

      var responseJson = jsonDecode(res.body);
      if (res.body != "0") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginAdmin(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
