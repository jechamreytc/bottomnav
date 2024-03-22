import 'dart:convert';

import 'package:bottomnav/Main%20Page/main_page.dart';
import 'package:bottomnav/local_storage.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RoomPage extends StatefulWidget {
  final String roomName;
  final String roomCode;
  final String roomDesc;

  const RoomPage({
    Key? key,
    required this.roomName,
    required this.roomCode,
    required this.roomDesc,
  }) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

// ROOM CREATOR PAGE

class _RoomPageState extends State<RoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 122, 180, 124),
      body: SingleChildScrollView(
        // For scrollable content
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Room details
              Text(
                widget.roomName,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Code: ${widget.roomCode}",
              ),
              Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Text(
                  widget.roomDesc,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Text(
                  "Leave Room",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addRiddleAlert() {
    final TextEditingController _addRiddleController = TextEditingController();
    final TextEditingController _addAnswersController = TextEditingController();
    final LocalStorage _localStorage = LocalStorage();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    void addRiddle() async {
      setState(() {
        _isLoading = false;
      });
      try {
        Map<String, String> jsonData = {
          "rid_riddle": _addRiddleController.text,
          "rid_answer": _addAnswersController.text,
          // "rid_roomId": _localStorage.getValue("rid_roomId"),
        };
        Map<String, String> requestBody = {
          "json": jsonEncode(jsonData),
          "operation": "addRiddle",
        };
        var res = await http.post(
          Uri.parse("${SessionStorage.url}user.php"),
          body: requestBody,
        );
        if (res.body != "0") {
          print("Success");
          // _addRiddleController.clear();
          // _addAnswersController.clear();
          print(jsonData);
        }
      } catch (e) {
        print(e);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              AlertDialog(
                title: Text(
                  "Create Room",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                content: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _addRiddleController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Riddle",
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _addAnswersController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Riddle Answer",
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addRiddle();
                        },
                        child: Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
