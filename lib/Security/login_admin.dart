import 'dart:convert';

import 'package:bottomnav/Room%20Page/create_room_page.dart';
import 'package:bottomnav/Security/sign_up.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({Key? key}) : super(key: key);

  @override
  _LoginAdminState createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("You need to Login First"),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text("Login"),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ),
                );
              },
              child: Text(
                "Register Account",
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
            builder: (context) => CreateRoomPage(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
