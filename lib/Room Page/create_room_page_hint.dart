// import 'package:bottomnav/Room%20Page/room_page.dart';
// import 'package:bottomnav/session_storage.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class CreateRoomPageHint extends StatefulWidget {
//   const CreateRoomPageHint({Key? key}) : super(key: key);

//   @override
//   _CreateRoomPageHintState createState() => _CreateRoomPageHintState();
// }

// class _CreateRoomPageHintState extends State<CreateRoomPageHint> {
//   final TextEditingController _roomNameController = TextEditingController();
//   final TextEditingController _roomDescController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   List<Map<String, String>> riddles = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         // Use SingleChildScrollView for long content
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               AlertDialog(
//                 title: const Text(
//                   "Create Game",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 30,
//                   ),
//                 ),
//                 content: Column(
//                   mainAxisSize:
//                       MainAxisSize.min, // To make content fit dialog size
//                   children: [
//                     TextField(
//                       controller: _roomNameController,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: "Game Title",
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     TextFormField(
//                       controller: _roomDescController,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: "Game Story",
//                       ),
//                       maxLines: null,
//                       minLines: 3,
//                       keyboardType: TextInputType.multiline,
//                     ),
//                     SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: createRoom,
//                       child: const Text("Create Game"),
//                     ),
//                     // buildRiddlesDataTable(), // Display the DataTable of riddles
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void createRoom() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       Map<String, String> jsonData = {
//         "room_name": _roomNameController.text,
//         "room_description": _roomDescController.text,
//         "room_status": "0",
//       };
//       Map<String, String> requestBody = {
//         "json": jsonEncode(jsonData),
//         "operation": "createRoom",
//       };
//       var res = await http.post(
//         Uri.parse("${SessionStorage.url}user.php"),
//         body: requestBody,
//       );
//       print("Response: ${res.body}");

//       if (res.body != "0") {
//         var responseJson = jsonDecode(res.body);
//         print("Room Code:" + responseJson['room_code']);
//         // Now also extract and print room_id
//         print("Room ID:" + responseJson['room_id'].toString());

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => RoomPage(
//               roomName: _roomNameController.text,
//               roomCode: responseJson['room_code'],
//               roomDesc: _roomDescController.text,
//               roomId:
//                   int.parse(responseJson['room_id']), // Pass the room_id here
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print(e);
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }
