import 'dart:convert';
import 'package:bottomnav/Security/login_admin.dart';
import 'package:bottomnav/User%20Side/user_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/treasureBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Text(
                "Campus Conquest",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginAdmin();
                      },
                    ),
                  );
                },
                child: Text("Create Game"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  findRoomAlert();
                },
                child: Text("Find Game"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _createRoomAlert() {

  //   final LocalStorage _localStorage = LocalStorage();

  //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //   @override
  //   void _initializePreferences() async {
  //     await _localStorage.init();
  //     // Now it's safe to use _localStorage
  //   }
  //   // void initState() {
  //   //   super.initState();
  //   //   _initializePreferences();
  //   // }

  //   @override
  //   void initState() {
  //     super.initState();
  //     _initializePreferences();
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Form(
  //         key: _formKey,
  //         child: Column(
  //           children: [
  //             AlertDialog(
  //               title: Text(
  //                 "Create Room",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 30,
  //                 ),
  //               ),
  //               content: Center(
  //                 child: Column(
  //                   children: [
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     TextField(
  //                       controller: _roomNameController,
  //                       decoration: InputDecoration(
  //                         border: const OutlineInputBorder(),
  //                         labelText: "Room Name",
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 30,
  //                     ),
  //                     TextField(
  //                       controller: _roomDescController,
  //                       decoration: InputDecoration(
  //                         border: const OutlineInputBorder(),
  //                         labelText: "Room Description",
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 30,
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         createRoom();
  //                       },
  //                       child: Text("Create Room"),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void findRoomAlert() {
    final TextEditingController _roomCodeController = TextEditingController();

    void findRoom() async {
      setState(() {
        _isLoading = false;
      });

      try {
        Map<String, String> jsonData = {
          "room_code": _roomCodeController.text,
        };
        Map<String, String> requestBody = {
          "json": jsonEncode(jsonData),
          "operation": "findRoom",
        };
        var res = await http.post(
          Uri.parse("${SessionStorage.url}user.php"),
          body: requestBody,
        );

        var responseJson = jsonDecode(res.body);
        String roomDesc = responseJson["room_description"];
        String roomName = responseJson["room_name"];
        int roomId = responseJson["room_id"];
        print(roomId);
        print(roomName);
        print(roomDesc);

        if (res.body.trim() != "0") {
          print(res.body);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserRoom(
                roomName: roomName,
                roomDesc: roomDesc,
                roomId: roomId,
              ),
            ),
          );
        } else {
          // If the server returns "0", show an alert dialog.
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Room Not Found"),
                content: Text("No available room with the provided code."),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print(
          e.toString(),
        );
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            AlertDialog(
              title: Text(
                "Enter Room Code",
              ),
              content: Column(
                children: [
                  TextField(
                    controller: _roomCodeController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Room Code",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      findRoom();
                    },
                    child: Text("Find Room"),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
