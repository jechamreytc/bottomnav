import 'dart:convert';

import 'package:bottomnav/Main%20Page/main_page.dart';
import 'package:bottomnav/QR%20CODE/qr_code_scanner.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRoom extends StatefulWidget {
  final String roomName;
  final String roomDesc;
  final int roomId;

  const UserRoom({
    Key? key,
    required this.roomName,
    required this.roomDesc,
    required this.roomId,
  }) : super(key: key);

  @override
  _UserRoomState createState() => _UserRoomState();
}

class _UserRoomState extends State<UserRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 122, 180, 124),
      body: Center(
        child: Column(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Title",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Story",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          widget.roomName,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          widget.roomDesc,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 170,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            joinRoomAlertDialog();
                          },
                          child: Text("Join Game"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Card(
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         width: 25,
            //       ),
            //       Column(
            //         children: [
            //           Text(
            //             "No.",
            //           ),
            //           Text(
            //             "1",
            //           ),
            //         ],
            //       ),
            //       SizedBox(
            //         width: 100,
            //       ),
            //       Column(
            //         children: [
            //           Text(
            //             "Riddle",
            //           ),
            //           Text(
            //             "What is my name?",
            //           ),
            //         ],
            //       ),
            //       SizedBox(
            //         width: 100,
            //       ),
            //       Column(
            //         children: [
            //           Text(
            //             "Hint",
            //           ),
            //           Ele2vatedButton(
            //             onPressed: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => QrCodeScanner(),
            //                 ),
            //               );
            //             },
            //             child: Icon(
            //               Icons.qr_code_scanner,
            //               color: Colors.black,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
              },
              child: Text("Exit"),
            ),
          ],
        ),
      ),
    );
  }

  void joinRoomAlertDialog() {
    TextEditingController _teamNameController = TextEditingController();
    void createTeam() async {
      try {
        Map<String, String> jsonData = {
          "team_name": _teamNameController.text,
          "team_roomId": widget.roomId.toString(),
        };
        Map<String, String> requestBody = {
          "json": jsonEncode(jsonData),
          "operation": "joinRoom",
        };

        var res = await http.post(
          Uri.parse("${SessionStorage.url}user.php"),
          body: requestBody,
        );
        if (res.body != "0") {
          print(res.body);
        }
      } catch (e) {
        print(e);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Team Name"),
          content: Column(
            children: [
              TextField(
                controller: _teamNameController,
                decoration: InputDecoration(
                  labelText: "Team Name",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  createTeam();
                },
                child: Text(
                  "Create Team",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
