// import 'package:bottomnav/Room%20Page/final_room_page.dart';
// import 'package:bottomnav/session_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class RoomPageHint extends StatefulWidget {
//   final String roomName;
//   final String roomCode;
//   final String roomDesc;
//   final int roomId;
//   const RoomPageHint({
//     Key? key,
//     required this.roomName,
//     required this.roomCode,
//     required this.roomDesc,
//     required this.roomId,
//   }) : super(key: key);

//   @override
//   _RoomPageHintState createState() => _RoomPageHintState();
// }

// class _RoomPageHintState extends State<RoomPageHint> {
//   final _riddleController = TextEditingController();
//   final _answerController = TextEditingController();
//   final _hintController = TextEditingController();
//   List<Map<String, dynamic>> riddlesList = [];
//   bool _isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.roomName),
//         backgroundColor: Colors.green,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Text Fields and Add Riddle Button
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _hintController,
//                 decoration: const InputDecoration(
//                     labelText: "Riddle Hint", border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _addRiddleToList,
//                 child: const Text("Add Riddle to List"),
//               ),
//               const SizedBox(height: 20),
//               _createDataTable(),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitRiddles,
//                 child: const Text("Submit All Riddles"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _addRiddleToList() {
//     setState(() {
//       riddlesList.add({
//         "rid_roomId": widget.roomId.toString(),
//         "rid_riddle": "",
//         "rid_answer": "",
//         "rid_hint": _hintController.text,
//       });
//       _riddleController.clear();
//       _answerController.clear();
//       _hintController.clear();
//     });
//   }

//   Future<void> _submitRiddles() async {
//     if (riddlesList.isEmpty) return;
//     setState(() => _isLoading = true);
//     try {
//       final response = await http.post(
//         Uri.parse("${SessionStorage.url}user.php"),
//         body: {
//           "json": jsonEncode({"riddles": riddlesList}),
//           "operation": "addRiddle",
//         },
//       );

//       if (response.statusCode == 200 && response.body != "0") {
//         print('Server response: ${response.body}');
//         var responseBody = jsonDecode(response.body);
//         List<String> scanCodes = List<String>.from(responseBody["scanCodes"]);

//         // Assuming riddlesList is updated to include 'scanCode' for each riddle
//         for (int i = 0; i < riddlesList.length; i++) {
//           riddlesList[i]['scanCode'] = scanCodes[i];
//         }

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => FinalRoomPage(
//               roomId: widget.roomId,
//               roomName: widget.roomName,
//               roomCode: widget.roomCode,
//               roomDesc: widget.roomDesc,
//               riddleDetails: riddlesList, // Updated parameter
//             ),
//           ),
//         );

//         // setState(() => riddlesList.clear());
//       } else {
//         print('Server error or empty response: ${response.body}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Widget _createDataTable() {
//     return DataTable(
//       columns: const [
//         DataColumn(label: Text('Hint')),
//         DataColumn(label: Text('Actions')),
//       ],
//       rows: riddlesList.asMap().entries.map((entry) {
//         final idx = entry.key;
//         final riddle = entry.value;
//         return DataRow(cells: [
//           DataCell(Text(riddle['rid_hint'] ?? '')),
//           DataCell(IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () => setState(
//               () => riddlesList.removeAt(idx),
//             ),
//           )),
//         ]);
//       }).toList(),
//     );
//   }
// }
