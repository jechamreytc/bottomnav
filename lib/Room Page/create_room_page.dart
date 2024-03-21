import 'dart:convert';

import 'package:bottomnav/Room%20Page/room_page.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDescController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            AlertDialog(
              title: Text(
                "Create Game",
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
                      controller: _roomNameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Game Title",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _roomDescController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Game Story",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        createRoom();
                      },
                      child: Text("Create Game"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createRoom() async {
    setState(() {
      _isLoading = false;
    });
    try {
      Map<String, String> jsonData = {
        "room_name": _roomNameController.text,
        "room_description": _roomDescController.text,
      };
      Map<String, String> requestBody = {
        "json": jsonEncode(jsonData),
        "operation": "createRoom",
      };
      var res = await http.post(
        Uri.parse("${SessionStorage.url}user.php"),
        body: requestBody,
      );
      print("Response: ${res.body}");

      if (res.body != "0") {
        var responseJson = jsonDecode(res.body);
        // print("Success");
        print("Room Code:" + responseJson['room_code']);
        // _localStorage.setValue(
        //     "rid_roomId", responseJson['room_id'].toString());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RoomPage(
              roomName: _roomNameController.text,
              roomCode: responseJson['room_code'],
              roomDesc: _roomDescController.text,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
