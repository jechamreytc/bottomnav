import 'dart:convert';
import 'dart:ui_web';
import 'dart:ui';
import 'package:bottomnav/Room%20Page/room_page.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDescController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int status = 0;
  bool _isLoading = false;
  List<Map<String, String>> riddles =
      []; // List to keep track of riddles and answers

  String _challengeOption = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/createroomBG3.jpg", // Replace with your image path
              fit: BoxFit.cover, // Cover the entire space of the stack
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 2.0,
                  sigmaY: 2.0), // Adjust the blur intensity as needed
              child: Container(
                color: Colors.black.withOpacity(
                    0), // You can adjust the opacity to create a dimming effect on the background image
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.transparent, // Make card background transparent
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(4.0), // Card border radius
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/hintBG1.png"), // Specify your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Create Game",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors
                                  .white, // For better contrast with the background
                              fontFamily: 'Cinzel',
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildTextField(_roomNameController, "Game Title"),
                          const SizedBox(height: 30),
                          _buildTextField(_roomDescController, "Game Story",
                              multiline: true),
                          const SizedBox(height: 30),
                          _buildRadioOptions(),
                          const SizedBox(height: 40),
                          _buildCreateButton(),
                          // Additional content...
                        ],
                      ),
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

  // Widget buildRiddlesDataTable() {
  //   return DataTable(
  //     columns: const [
  //       DataColumn(label: Text("Riddle")),
  //       DataColumn(label: Text("Answer")),
  //       DataColumn(label: Text("Action")),
  //     ],
  //     rows: riddles.map((riddle) {
  //       return DataRow(cells: [
  //         DataCell(Text(riddle["rid_riddle"] ?? "")),
  //         DataCell(Text(riddle["rid_answer"] ?? "")),
  //         DataCell(ElevatedButton(
  //           onPressed: () {
  //             // Implement QR Code generation or any other action here
  //           },
  //           style: ElevatedButton.styleFrom(
  //             shape: CircleBorder(),
  //             padding: EdgeInsets.all(10),
  //           ),
  //           child: Icon(Icons.qr_code), // QR Code icon
  //         )),
  //       ]);
  //     }).toList(),
  //   );
  // }

  Widget _buildRadioOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListTile(
            title: Text(
              "No Challenge",
              style: TextStyle(color: Colors.white, fontFamily: 'Cinzel'),
            ),
            leading: Radio<String>(
              value: "No Challenge",
              groupValue: _challengeOption,
              onChanged: (String? value) {
                setState(() {
                  _challengeOption = value!;
                });
              },
              activeColor: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(
              "Challenge",
              style: TextStyle(color: Colors.white, fontFamily: 'Cinzel'),
            ),
            leading: Radio<String>(
              value: "Challenge",
              groupValue: _challengeOption,
              onChanged: (String? value) {
                setState(() {
                  _challengeOption = value!;
                });
              },
              activeColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return InkWell(
      onTap: () {
        if (!_isLoading) {
          // Prevent action if already loading
          createRoom();
        }
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 137, 113, 44).withOpacity(1),
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
            _isLoading
                ? CircularProgressIndicator(
                    color: Colors.white) // Show loading indicator
                : const Padding(
                    padding: EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      "Create",
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 75, right: 75),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white, fontFamily: 'Cinzel'),
        ),
        maxLines: multiline ? null : 1,
        minLines: multiline ? 3 : 1,
        style: TextStyle(color: Colors.white, fontFamily: 'Cinzel'),
      ),
    );
  }

  void createRoom() async {
    setState(() {
      _isLoading = true;
      status = _challengeOption == "No Challenge" ? 0 : 1;
    });
    try {
      Map<String, dynamic> jsonData = {
        "room_name": _roomNameController.text,
        "room_description": _roomDescController.text,
        "room_status": status,
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

      print("status: $status");

      if (res.body != "0") {
        var responseJson = jsonDecode(res.body);
        print("Room Code:" + responseJson['room_code']);
        // Now also extract and print room_id
        print("Room ID:" + responseJson['room_id'].toString());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RoomPage(
              roomName: _roomNameController.text,
              roomCode: responseJson['room_code'],
              roomDesc: _roomDescController.text,
              roomId:
                  int.parse(responseJson['room_id']), // Pass the room_id here
              roomStatus: status.toString(),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // void _addRiddleAlert() {
  //   final TextEditingController addRiddleController = TextEditingController();
  //   final TextEditingController addAnswersController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Add Riddle"),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: [
  //               TextField(
  //                 controller: addRiddleController,
  //                 decoration: const InputDecoration(
  //                   border: OutlineInputBorder(),
  //                   labelText: "Riddle",
  //                 ),
  //               ),
  //               SizedBox(height: 30),
  //               TextField(
  //                 controller: addAnswersController,
  //                 decoration: const InputDecoration(
  //                   border: OutlineInputBorder(),
  //                   labelText: "Riddle Answer",
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Save"),
  //             onPressed: () async {
  //               // Call addRiddle function when saving
  //               await addRiddle(
  //                   addRiddleController.text, addAnswersController.text);
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> addRiddle(String riddle, String answer) async {
  //   setState(() {
  //     _isLoading = true; // Show loading indicator while processing
  //   });
  //   try {
  //     Map<String, String> jsonData = {
  //       "rid_riddle": riddle,
  //       "rid_answer": answer,
  //       // Add "rid_roomId" when you have the ID of the room to which this riddle belongs
  //     };
  //     Map<String, String> requestBody = {
  //       "json": jsonEncode(jsonData),
  //       "operation": "addRiddle",
  //     };
  //     var response = await http.post(
  //       Uri.parse("${SessionStorage.url}user.php"),
  //       body: requestBody,
  //     );
  //     if (response.body != "0") {
  //       print("Success: Riddle added");
  //       // Optionally update the UI here to show the added riddle
  //     } else {
  //       print("Error: Failed to add riddle");
  //     }
  //   } catch (e) {
  //     print("Exception caught: $e");
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // Hide loading indicator after processing is done
  //     });
  //   }
  // }
}
