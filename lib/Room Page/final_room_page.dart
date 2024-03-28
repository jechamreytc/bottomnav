import 'package:bottomnav/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:convert';
import 'dart:js' as js;
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:qr_code_tools/qr_code_tools.dart';

class FinalRoomPage extends StatefulWidget {
  final String roomName;
  final String roomCode;
  final String roomDesc;
  final int roomId;
  final List<Map<String, dynamic>>
      riddleDetails; // Each item includes riddle, answer, hint, scanCode

  const FinalRoomPage({
    Key? key,
    required this.roomName,
    required this.roomCode,
    required this.roomDesc,
    required this.roomId,
    required this.riddleDetails,
  }) : super(key: key);

  @override
  _FinalRoomPageState createState() => _FinalRoomPageState();
}

class _FinalRoomPageState extends State<FinalRoomPage> {
  List<Map<String, dynamic>>? participantsDetails;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/treasureBGmain.png"),
                  fit: BoxFit.cover,
                ),
              ),
              // Apply the blur effect to the background image
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
            ),
          ),
          // Content
          ListView.builder(
            itemCount:
                widget.riddleDetails.length + 1, // Adding 1 for the header
            itemBuilder: (context, index) {
              if (index == 0) {
                // Header
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              widget.roomName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Cinzel',
                              ),
                            ),
                            Text(
                              "Room Title",
                            ),
                            Text(
                              widget.roomDesc,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Cinzel',
                              ),
                            ),
                            Text(
                              "Room Story",
                            ),
                            Text(
                              widget.roomCode,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Cinzel',
                              ),
                            ),
                            Text("Room Code"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Adjusting index for the header
              final riddleDetail = widget.riddleDetails[index - 1];
              return Container(
                margin:
                    EdgeInsets.all(8.0), // Add margin to simulate Card spacing
                decoration: BoxDecoration(
                  // Add boxShadow to simulate Card elevation
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/hintBG1.png"), // Specify your image path
                    fit: BoxFit.fill,
                  ),
                  borderRadius:
                      BorderRadius.circular(4.0), // Card-like rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 60,
                    left: 60,
                  ),
                  child: ListTile(
                    title: Text(
                      riddleDetail['rid_riddle'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ), // Adjust text color for visibility
                    subtitle: Text(
                      "Answer: ${riddleDetail['rid_answer']}\nHint: ${riddleDetail['rid_hint']}",
                      style: TextStyle(
                          color: Colors
                              .white70), // Adjust text color for visibility
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.qr_code,
                          color:
                              Colors.white), // Adjust icon color for visibility
                      onPressed: () =>
                          _showQRCodeDialog(context, riddleDetail['scanCode']),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Assuming this method is part of your widget class
  void _showQRCodeDialog(BuildContext context, String scanCode) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor:
            Colors.transparent, // Make dialog background transparent
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/hintBG1.png"), // Specify your image path
              fit: BoxFit.cover,
            ),
            borderRadius:
                BorderRadius.circular(12), // Dialog-like rounded corners
          ),
          padding: EdgeInsets.all(8.0), // Adjust padding as needed
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("QR Code",
                    style: TextStyle(
                        fontSize: 24,
                        color:
                            Colors.white)), // Adjust text color for visibility
              ),
              SizedBox(
                height: 250,
                width: 250,
                child: QrImageView(
                  data: scanCode,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Close',
                        style: TextStyle(
                            color: Colors
                                .white)), // Adjust text color for visibility
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // TextButton(
                  //   child: const Text('Download',
                  //       style: TextStyle(
                  //           color: Colors
                  //               .white)), // Adjust text color for visibility
                  //   onPressed: () {
                  //     // Implement your download logic here
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _createTeamsDataTable() {
  //   // Check if participantsDetails is null or empty and return a placeholder widget
  //   if (participantsDetails == null || participantsDetails!.isEmpty) {
  //     return Center(
  //         child: Text('No team data available',
  //             style: TextStyle(color: Colors.white)));
  //   }

  //   return DataTable(
  //     columns: const [
  //       DataColumn(
  //           label: Text('Team Name', style: TextStyle(color: Colors.white))),
  //       DataColumn(
  //           label: Text('Team Level', style: TextStyle(color: Colors.white))),
  //     ],
  //     rows: participantsDetails!.asMap().entries.map((entry) {
  //       final idx = entry.key;
  //       final team = entry.value;
  //       // Assuming your participant details include keys for team name and level
  //       // Adjust the key names based on your actual data structure
  //       return DataRow(cells: [
  //         DataCell(
  //           Text(
  //             team['team_name'] ?? '', // Use the correct key for team name
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         DataCell(
  //           Text(
  //             team['team_level']
  //                 .toString(), // Use the correct key for team level
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       ]);
  //     }).toList(),
  //   );
  // }

  // Future<void> _refreshDataRiddles() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   List<Map<String, dynamic>> fetchedParticipantsDetails =
  //       await _getRiddleDetails(); // Changed to List<Map<String, dynamic>>
  //   if (mounted) {
  //     setState(
  //       () {
  //         participantsDetails = fetchedParticipantsDetails;
  //         // print("RIDDLE LEVEL: ${fetchedRiddleDetails[0]['rid_level']}");
  //         // riddleLevel = fetchedParticipantsDetails[0]['rid_level'];
  //         _isLoading = false;
  //       },
  //     );
  //   }
  // }

  // Future<List<Map<String, dynamic>>> _getRiddleDetails() async {
  //   try {
  //     Map<String, dynamic> jsonData = {
  //       "team_roomId": widget.roomId, // Updated key name to match PHP
  //     };
  //     Map<String, dynamic> requestBody = {
  //       "json": jsonEncode(jsonData),
  //       "operation": "getParticipants",
  //     };

  //     var res = await http.post(
  //       Uri.parse("${SessionStorage.url}user.php"),
  //       body: requestBody,
  //     );

  //     print(res.body);

  //     if (res.statusCode == 200) {
  //       var decodedResponseRiddle = jsonDecode(res.body);
  //       // print("RIDDLE DETAILS MO TO ${decodedResponseRiddle}");
  //       if (decodedResponseRiddle is List) {
  //         // Check if decodedResponseRiddle is a list
  //         return decodedResponseRiddle.cast<
  //             Map<String, dynamic>>(); // Cast each item to Map<String, dynamic>
  //       } else {
  //         throw Exception('Invalid response format');
  //       }
  //     } else {
  //       throw Exception('Failed to load riddles');
  //     }
  //   } catch (e) {
  //     print("error mo to$e");
  //     return [];
  //   }
  // }
}
