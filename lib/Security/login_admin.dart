import 'dart:convert';

import 'package:bottomnav/Room%20Page/create_room_page.dart';
import 'package:bottomnav/Security/sign_up.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  _LoginAdminState createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/loginBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black
                      .withOpacity(0), // You can adjust the opacity here
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 75,
                      right: 75,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        // Use BoxDecoration to add an image
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/descriptionBG1.png"), // Specify the path to your image
                          fit: BoxFit
                              .cover, // Cover the entire space of the container
                        ),
                        borderRadius: BorderRadius.circular(
                            4.0), // Optional: if you want rounded corners
                        boxShadow: [
                          // Optional: if you want to keep the shadow effect similar to a Card
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Login First",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'Cinzel',
                              fontSize: 20,
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              color: Colors.white,
                            ),
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cinzel',
                                fontSize: 10,
                              ),
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: _passwordController,
                            obscureText:
                                true, // This obscures the text input for the password
                            decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cinzel',
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      login();
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
                              "Login",
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
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SignUp(), // Ensure you have a SignUp class defined
                        ),
                      );
                    },
                    child: Text(
                      "Register Account",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Cinzel',
                        color: Color.fromARGB(255, 244, 215, 129),
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(150, 0, 0, 0),
                          ),
                          // You can add more Shadow objects if you want multiple shadows.
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    try {
      Map<String, String> jsonData = {
        "username": _usernameController.text,
        "password": _passwordController.text,
      };
      Map<String, String> requestBody = {
        "json": jsonEncode(jsonData),
        "operation": "login",
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
            builder: (context) => const CreateRoomPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Failed'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
