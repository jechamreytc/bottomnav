import 'dart:convert';
import 'dart:ui' as ui;
import 'package:bottomnav/Security/login_admin.dart';
import 'package:bottomnav/User%20Side/user_chamber.dart';
import 'package:bottomnav/User%20Side/user_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/treasureBG.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Text(
                  "Campus Conquest",
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cinzel',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2.5, 2.5),
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 100,
                ),
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginAdmin();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 137, 113, 44)
                                  .withOpacity(1),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: Offset(0, 4),
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
                            Text(
                              'Create Game',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cinzel',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    joinAlertDialog();
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 137, 113, 44).withOpacity(1),
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: Offset(0, 4),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            "Join Game",
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
        ],
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

  // void findRoomAlert() {
  //   final TextEditingController _roomCodeController = TextEditingController();

  //   void findRoom() async {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     try {
  //       Map<String, String> jsonData = {
  //         "room_code": _roomCodeController.text,
  //       };
  //       Map<String, String> requestBody = {
  //         "json": jsonEncode(jsonData),
  //         "operation": "findRoom",
  //       };
  //       var res = await http.post(
  //         Uri.parse("${SessionStorage.url}user.php"),
  //         body: requestBody,
  //       );

  //       var responseJson = jsonDecode(res.body);
  //       String roomDesc = responseJson["room_description"];
  //       String roomName = responseJson["room_name"];
  //       int roomId = responseJson["room_id"];
  //       print(roomId);
  //       print(roomName);
  //       print(roomDesc);

  //       if (res.body.trim() != "0") {
  //         print(res.body);
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => UserRoom(
  //               roomName: roomName,
  //               roomDesc: roomDesc,
  //               roomId: roomId,
  //             ),
  //           ),
  //         );
  //       } else {
  //         // If the server returns "0", show an alert dialog.
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text("Room Not Found"),
  //               content: Text("No available room with the provided code."),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: Text("OK"),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(); // Close the dialog
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     } catch (e) {
  //       print(
  //         e.toString(),
  //       );
  //     }
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Column(
  //         children: [
  //           AlertDialog(
  //             title: Text(
  //               "Enter Room Code",
  //             ),
  //             content: Column(
  //               children: [
  //                 TextField(
  //                   controller: _roomCodeController,
  //                   decoration: InputDecoration(
  //                     border: const OutlineInputBorder(),
  //                     labelText: "Room Code",
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     findRoom();
  //                   },
  //                   child: Text("Find Room"),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void joinAlertDialog() {
    final TextEditingController _teamNameCodeController =
        TextEditingController();
    final TextEditingController _roomCodeController = TextEditingController();

    void joinRoom() async {
      try {
        Map<String, String> jsonData = {
          "room_code": _roomCodeController.text,
          "team_name": _teamNameCodeController.text
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserChamber(
                roomCode: _roomCodeController.text,
                roomId: int.parse(res.body),
              ),
            ),
          );
        }
      } catch (e) {
        print(e.toString());
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const ui.Color.fromARGB(
              0, 255, 255, 255), // Make the background transparent
          child: Container(
            width: 800,
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/enter_chamberBG.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensure the Column takes minimum space
              children: [
                SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 100,
                    right: 100,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '" Unlock the Secrets "',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          color: ui.Color.fromARGB(255, 184, 118, 5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextField(
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                        ),
                        controller: _teamNameCodeController,
                        decoration: InputDecoration(
                          labelText: "Team Name",
                          labelStyle: TextStyle(
                            fontFamily: 'Cinzel',
                            color: ui.Color.fromARGB(255, 184, 118, 5),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                        ),
                        controller: _roomCodeController,
                        decoration: InputDecoration(
                          labelText: "Game Code",
                          labelStyle: TextStyle(
                            fontFamily: 'Cinzel',
                            color: ui.Color.fromARGB(255, 184, 118, 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                InkWell(
                  onTap: () {
                    joinRoom();
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 137, 113, 44).withOpacity(1),
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: Offset(0, 4),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            "Join",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 184, 118, 5),
                              fontFamily: 'Cinzel',
                              shadows: [
                                Shadow(
                                  color: ui.Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(
                                          0.9), // Shadow color with some transparency
                                  offset: Offset(0, 2), // Offset of the shadow
                                  blurRadius:
                                      2, // How blurry the shadow should be
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
          ),
        );

        // return Padding(
        //   padding: const EdgeInsets.only(
        //     bottom: 300,
        //   ),
        //   child: AlertDialog(
        //     content: Container(
        //       width: 400,
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage(
        //             'assets/images/enter_chamberBG1.jpg',
        //           ),
        //           fit: BoxFit.fill,
        //         ),
        //       ),
        //       child: Column(
        //         children: [
        //           SizedBox(
        //             height: 100,
        //           ),
        //           TextField(
        //             controller: _teamNameCodeController,
        //             decoration: InputDecoration(
        //               border: const OutlineInputBorder(),
        //               labelText: "Team Name",
        //             ),
        //           ),
        //           SizedBox(
        //             height: 10,
        //           ),
        //           TextField(
        //             controller: _roomCodeController,
        //             decoration: InputDecoration(
        //               border: const OutlineInputBorder(),
        //               labelText: "Game Code",
        //             ),
        //           ),
        //           SizedBox(
        //             height: 20,
        //           ),
        //           InkWell(
        //             onTap: () {},
        //             child: Container(
        //               width: 200,
        //               height: 50,
        //               decoration: BoxDecoration(
        //                 color: Color.fromARGB(255, 137, 113, 44).withOpacity(1),
        //                 borderRadius: BorderRadius.circular(50.0),
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: Colors.black.withOpacity(0.5),
        //                     spreadRadius: 0,
        //                     blurRadius: 8,
        //                     offset: Offset(0, 4),
        //                   ),
        //                 ],
        //               ),
        //               child: Stack(
        //                 alignment: Alignment.center,
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius: BorderRadius.circular(50.0),
        //                     child: Image.asset(
        //                       'assets/images/buttonBG3.jpg',
        //                       width: 200,
        //                       height: 50,
        //                       fit: BoxFit.cover,
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(
        //                       left: 40,
        //                       right: 40,
        //                       top: 10,
        //                       bottom: 10,
        //                     ),
        //                     child: Text(
        //                       "Join",
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.white,
        //                         fontFamily: 'Cinzel',
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}
