import 'dart:convert';
// import 'dart:ui' as ui;
// import 'dart:ui_web';
import 'package:bottomnav/Security/login_admin.dart';
import 'package:bottomnav/User%20Side/user_chamber.dart';
import 'package:flutter/material.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/treasureBGmain.png",
              fit: BoxFit.cover,
            ),
          ),
          // Blur effect
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(
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
                        offset: const Offset(2.5, 2.5),
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
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
                              return const LoginAdmin();
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
                              color: const Color.fromARGB(255, 137, 113, 44)
                                  .withOpacity(1),
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
                            const Text(
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
                const SizedBox(
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

  void joinAlertDialog() {
    final TextEditingController teamNameCodeController =
        TextEditingController();
    final TextEditingController roomCodeController = TextEditingController();

    void joinRoom() async {
      try {
        Map<String, String> jsonData = {
          "room_code": roomCodeController.text,
          "team_name": teamNameCodeController.text,
        };
        Map<String, String> requestBody = {
          "json": jsonEncode(jsonData),
          "operation": "joinRoom",
        };

        var res = await http.post(
          Uri.parse("${SessionStorage.url}user.php"),
          body: requestBody,
        );

        if (res.statusCode == 200) {
          var responseJson = jsonDecode(res.body);

          // Check for the expected keys in the JSON response
          if (responseJson is Map &&
              responseJson.containsKey('team_id') &&
              responseJson.containsKey('room_status')) {
            print("Team ID: ${responseJson['team_id']}");
            print(responseJson);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserChamber(
                  roomCode: roomCodeController.text,
                  roomId: responseJson[
                      'team_roomId'], // Assuming 'team_roomId' is the correct key
                  teamId: responseJson['team_id'],
                  roomStatus: responseJson['room_status'],
                  teamLevel: responseJson['team_level'],
                ),
              ),
            );
          } else {
            // Handle unexpected JSON structure
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Team Already Exists"),
            ));
          }
        } else {
          // Handle non-200 responses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Room Not Found"),
            ),
          );
        }
      } catch (e) {
        // Handle parsing errors or other exceptions
        print("Error joining room: $e");
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(
              0, 255, 255, 255), // Make the background transparent
          child: Container(
            width: 800,
            height: 500,
            decoration: const BoxDecoration(
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
                const SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 100,
                    right: 100,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '" Unlock the Secrets "',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          color: Color.fromARGB(255, 184, 118, 5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        style: const TextStyle(
                          fontFamily: 'Cinzel',
                        ),
                        controller: teamNameCodeController,
                        decoration: const InputDecoration(
                          labelText: "Team Name",
                          labelStyle: TextStyle(
                            fontFamily: 'Cinzel',
                            color: Color.fromARGB(255, 184, 118, 5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: const TextStyle(
                          fontFamily: 'Cinzel',
                        ),
                        controller: roomCodeController,
                        decoration: const InputDecoration(
                          labelText: "Game Code",
                          labelStyle: TextStyle(
                            fontFamily: 'Cinzel',
                            color: Color.fromARGB(255, 184, 118, 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
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
                              color: const Color.fromARGB(255, 184, 118, 5),
                              fontFamily: 'Cinzel',
                              shadows: [
                                Shadow(
                                  color: const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(
                                          0.9), // Shadow color with some transparency
                                  offset: const Offset(
                                      0, 2), // Offset of the shadow
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
      },
    );
  }
}
