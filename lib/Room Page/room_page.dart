import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bottomnav/Room%20Page/final_room_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bottomnav/session_storage.dart';
import 'dart:ui';

class RoomPage extends StatefulWidget {
  final String roomName;
  final String roomCode;
  final String roomDesc;
  final int roomId;
  final String roomStatus;

  const RoomPage({
    Key? key,
    required this.roomName,
    required this.roomCode,
    required this.roomDesc,
    required this.roomId,
    required this.roomStatus,
  }) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final _riddleController = TextEditingController();
  final _answerController = TextEditingController();
  final _hintController = TextEditingController();
  List<Map<String, dynamic>> riddlesList = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/treasureBGmain.png", // Replace with your image path
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 2, sigmaY: 2), // Adjust the blur amount as desired
              child: Container(
                color: Colors.black.withOpacity(
                    0.2), // You can adjust the overlay color and opacity
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Conditional display of TextFields based on roomStatus
                widget.roomStatus == "1"
                    ? TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cinzel',
                        ),
                        controller: _riddleController,
                        decoration: const InputDecoration(
                            labelText: "Riddle",
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cinzel',
                            )),
                      )
                    : Container(),
                const SizedBox(height: 20),
                widget.roomStatus == "1"
                    ? TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cinzel',
                        ),
                        controller: _answerController,
                        decoration: const InputDecoration(
                          labelText: "Riddle Answer",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cinzel',
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cinzel',
                  ),
                  controller: _hintController,
                  decoration: const InputDecoration(
                    labelText: "Hint",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cinzel',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _addRiddleToList();
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
                            "Add to List",
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
                const SizedBox(height: 20),
                _createDataTable(), // Ensure this function is defined elsewhere in your widget
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _submitRiddles();
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
                            "Create Final",
                            style: TextStyle(
                              fontSize: 13.5,
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

  void _addRiddleToList() {
    print("rid_answer: ${_answerController.text}");
    print("rid_riddle: ${_riddleController.text}");
    setState(() {
      riddlesList.add({
        "rid_roomId": widget.roomId.toString(),
        "rid_riddle":
            _riddleController.text == "" ? "" : _riddleController.text,
        "rid_answer":
            _answerController.text == "" ? "" : _answerController.text,
        "rid_hint": _hintController.text,
      });
      _riddleController.clear();
      _answerController.clear();
      _hintController.clear();
    });
  }

  Future<void> _submitRiddles() async {
    if (riddlesList.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("${SessionStorage.url}user.php"),
        body: {
          "json": jsonEncode({"riddles": riddlesList}),
          "operation": "addRiddle",
        },
      );

      if (response.statusCode == 200 && response.body != "0") {
        print('Server response: ${response.body}');
        var responseBody = jsonDecode(response.body);
        List<String> scanCodes = List<String>.from(responseBody["scanCodes"]);

        // Assuming riddlesList is updated to include 'scanCode' for each riddle
        for (int i = 0; i < riddlesList.length; i++) {
          riddlesList[i]['scanCode'] = scanCodes[i];
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinalRoomPage(
              roomId: widget.roomId,
              roomName: widget.roomName,
              roomCode: widget.roomCode,
              roomDesc: widget.roomDesc,
              riddleDetails: riddlesList, // Updated parameter
            ),
          ),
        );

        // setState(() => riddlesList.clear());
      } else {
        print('Server error or empty response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _createDataTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Riddle')),
        DataColumn(label: Text('Answer')),
        DataColumn(label: Text('Hint')),
        DataColumn(label: Text('Actions')),
      ],
      rows: riddlesList.asMap().entries.map((entry) {
        final idx = entry.key;
        final riddle = entry.value;
        return DataRow(cells: [
          DataCell(
            Text(
              riddle['rid_riddle'] ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          DataCell(
            Text(
              riddle['rid_answer'] ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          DataCell(
            Text(
              riddle['rid_hint'] ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          DataCell(IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(
              () => riddlesList.removeAt(idx),
            ),
          )),
        ]);
      }).toList(),
    );
  }
}
