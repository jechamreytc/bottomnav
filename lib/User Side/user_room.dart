import 'dart:convert';

import 'package:bottomnav/Main%20Page/main_page.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRoom extends StatefulWidget {
  final String roomName;
  final String roomDesc;
  final int roomId;

  const UserRoom({
    super.key,
    required this.roomName,
    required this.roomDesc,
    required this.roomId,
  });

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
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
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
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          widget.roomDesc,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 170,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            joinRoomAlertDialog();
                          },
                          child: const Text("Join Game"),
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                );
              },
              child: const Text("Exit"),
            ),
          ],
        ),
      ),
    );
  }

  void joinRoomAlertDialog() {
    TextEditingController teamNameController = TextEditingController();
    void createTeam() async {
      try {
        Map<String, String> jsonData = {
          "team_name": teamNameController.text,
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
          title: const Text("Enter Team Name"),
          content: Column(
            children: [
              TextField(
                controller: teamNameController,
                decoration: const InputDecoration(
                  labelText: "Team Name",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  createTeam();
                },
                child: const Text(
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
