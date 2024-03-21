import 'dart:convert';

import 'package:bottomnav/Security/login_admin.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              "Register Account",
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                register();
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
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
            builder: (context) => LoginAdmin(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
