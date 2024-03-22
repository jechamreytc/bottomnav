import 'dart:convert';

import 'package:bottomnav/session_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserChamber extends StatefulWidget {
  final String roomCode;
  final int roomId;

  const UserChamber({
    Key? key,
    required this.roomCode,
    required this.roomId,
  }) : super(key: key);

  @override
  _UserChamberState createState() => _UserChamberState();
}

class _UserChamberState extends State<UserChamber> {
  Map<String, dynamic>? roomDetails;
  List<Map<String, dynamic>>?
      riddleDetails; // Changed to List<Map<String, dynamic>>
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _refreshDataRiddles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : roomDetails != null && riddleDetails != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome to User Riddles"),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                "Chamber 1",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Room Title: ${roomDetails!['room_name']}",
                              ),
                              Text(
                                "Room Details: ${roomDetails!['room_description']}",
                              ),
                              // Displaying riddles
                              for (var riddle in riddleDetails!)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Riddle: ${riddle['rid_riddle']}",
                                    ),
                                    Text(
                                      "Answer: ${riddle['rid_answer']}",
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Text("No data found"),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> fetchedRoomDetails = await _getRoomDetails();
    if (mounted) {
      setState(() {
        roomDetails = fetchedRoomDetails;
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _getRoomDetails() async {
    try {
      Map<String, dynamic> jsonData = {
        "room_code": widget.roomCode,
      };
      Map<String, dynamic> requestBody = {
        "json": jsonEncode(jsonData),
        "operation": "getRoomDetails",
      };

      var res = await http.post(
        Uri.parse("${SessionStorage.url}user.php"),
        body: requestBody,
      );

      if (res.statusCode == 200) {
        var decodedResponse = jsonDecode(res.body);
        return decodedResponse != null ? decodedResponse : {};
      } else {
        throw Exception('Failed to load room details');
      }
    } catch (e) {
      print("error mo to" + e.toString());
      return {};
    }
  }

  Future<void> _refreshDataRiddles() async {
    setState(() {
      _isLoading = true;
    });
    List<Map<String, dynamic>> fetchedRiddleDetails =
        await _getRiddleDetails(); // Changed to List<Map<String, dynamic>>
    if (mounted) {
      setState(
        () {
          riddleDetails = fetchedRiddleDetails;
          _isLoading = false;
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>> _getRiddleDetails() async {
    try {
      Map<String, dynamic> jsonData = {
        "rid_roomId": widget.roomId,
      };
      Map<String, dynamic> requestBody = {
        "json": jsonEncode(jsonData),
        "operation": "getAllRiddles",
      };

      var res = await http.post(
        Uri.parse("${SessionStorage.url}user.php"),
        body: requestBody,
      );

      if (res.statusCode == 200) {
        var decodedResponseRiddle = jsonDecode(res.body);
        if (decodedResponseRiddle is List) {
          // Check if decodedResponseRiddle is a list
          return decodedResponseRiddle.cast<
              Map<String, dynamic>>(); // Cast each item to Map<String, dynamic>
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load riddles');
      }
    } catch (e) {
      print("error mo to" + e.toString());
      return [];
    }
  }
}
