import 'dart:convert';
import 'dart:ui_web' as ui_web;

import 'package:bottomnav/User%20Side/you_win.dart';
import 'package:bottomnav/session_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/get.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class UserChamber extends StatefulWidget {
  final String roomCode;
  final int roomId;
  final int teamId;
  final int roomStatus;
  final int teamLevel;

  const UserChamber({
    super.key,
    required this.roomCode,
    required this.roomId,
    required this.teamId,
    required this.roomStatus,
    required this.teamLevel,
  });

  @override
  _UserChamberState createState() => _UserChamberState();
}

class _UserChamberState extends State<UserChamber> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;

  final TextEditingController _answerController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;

  Map<String, dynamic>? roomDetails;
  List<Map<String, dynamic>>? riddleDetails;
  bool _isLoading = false;

  String riddleQ = "";
  String riddleA = "";
  int riddleLevel = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _refreshDataRiddles();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/treasureBG.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : roomDetails != null && riddleDetails != null
                      ? Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Welcome to User Riddles",
                              style: TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 500,
                              height: 250,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/hintBG1.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Gives the Container rounded corners
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Text(
                                      "${roomDetails!['room_name']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Cinzel',
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      "Title",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 30,
                                          right: 30,
                                        ),
                                        child: Text(
                                          "${roomDetails!['room_description']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            fontFamily: 'Cinzel',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Story",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            Container(
                              width: 300,
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: Image.asset(
                                    'assets/images/descriptionBG1.png',
                                  ).image,
                                  fit: BoxFit
                                      .cover, // Ensures the image covers the background fully
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Displaying riddles where rid_level is 1
                                  for (var riddle in riddleDetails!
                                      .where((r) => r['rid_level'] == 1))
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              Text(
                                                "${riddle['rid_hint']}",
                                                style: const TextStyle(
                                                  fontFamily: 'Cinzel',
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Text("Hint"),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  // _showRiddleDialog(
                                                  //     riddle['rid_riddle']);
                                                  _showQRScannerDialog(context);
                                                  // _qrBarCodeScannerDialogPlugin
                                                  //     .getScannedQrBarCode(
                                                  //   context: context,
                                                  //   onCode: (code) {
                                                  //     setState(() {

                                                  //     });
                                                  //   },
                                                  // );
                                                },
                                                child: Container(
                                                  width: 75,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      137,
                                                      113,
                                                      44,
                                                    ).withOpacity(1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0,
                                                        blurRadius: 8,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                        child: Image.asset(
                                                          'assets/images/buttonBG3.jpg',
                                                          width: 200,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 10,
                                                          bottom: 10,
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .qr_code_scanner_outlined,
                                                          size: 30,
                                                          color: Colors.white,
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
                                ],
                              ),
                            ),
                          ],
                        )
                      : const Text("No data found"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRiddleDialog(String riddle) async {
    TextEditingController answerController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Solve Riddle'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(riddle), // Displaying the riddle hint
                TextFormField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    hintText: "Enter your answer here",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                // Here, you can handle the answer submission logic
                // For example, checking the answer and responding accordingly
                print("Answer submitted: ${answerController.text}");
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
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
        return decodedResponse ?? {};
      } else {
        throw Exception('Failed to load room details');
      }
    } catch (e) {
      print("error mo to $e");
      return {};
    }
  }

  void _answerRiddle() async {
    try {
      Map<String, dynamic> jsonData = {
        "rid_roomId": widget.roomId,
        "rid_level": riddleLevel,
        "team_id": widget.teamId,
        "answer": _answerController.text,
      };
      print("JSON DATA NI ANSWER: $jsonData");
      Map<String, dynamic> requestBody = {
        "json": jsonEncode(jsonData),
        "operation": "answerRiddle",
      };

      var res = await http.post(
        Uri.parse("${SessionStorage.url}user.php"),
        body: requestBody,
      );
      print("RES NI ANSWER: ${res.body}");
      if (res.body == "-1") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid answer"),
          ),
        );
        // Get.snackbar("Error", "Invalid answer");
      } else if (res.body != "2") {
        // Get.snackbar("Success", "Correct answer!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid answer"),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const YouWin(),
          ),
        );
        // Get.snackbar("Success", "You win!");
        // print("You Win!!");
      }
    } catch (error) {
      Get.snackbar("Error", "Network error");
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
          // print("RIDDLE LEVEL: ${fetchedRiddleDetails[0]['rid_level']}");
          riddleLevel = fetchedRiddleDetails[0]['rid_level'];
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
        // print("RIDDLE DETAILS MO TO ${decodedResponseRiddle}");
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
      print("error mo to$e");
      return [];
    }
  }

  void _showQRScannerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(
              8.0), // Add some padding around the dialog content
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Use the minimum space that encloses the children
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the children vertically
            children: <Widget>[
              Container(
                height: 200,
                width: 250,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.green,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.75,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scannedBarcode) {
      setState(() {
        barcode = scannedBarcode;
      });
      Navigator.of(context).pop(); // Close the scanner dialog
      _scanValidation(scannedBarcode.code!); // Use the scanned code
    });
  }

  void _scanValidation(String scannedCode) async {
    // Now `scannedCode` contains the scanned QR code.
    // You can use this directly for "rid_scanCode"
    try {
      Map<String, dynamic> jsonData = {
        "team_roomId": widget.roomId,
        "team_id": widget.teamId,
        "room_status": widget.roomStatus,
        "rid_scanCode": scannedCode, // Use the scanned QR code here
      };
      Map<String, dynamic> requestBody = {
        "json": jsonEncode(jsonData),
        "operation": "scanRiddle",
      };

      var res = await http.post(
        Uri.parse("${SessionStorage.url}user.php"),
        body: requestBody,
      );
      print("RES NAKO NI ${res.body}");
      if (res.body == "5") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const YouWin()),
        );
      } else if (res.body == "-1") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Invalid QR code"),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else if (res.body == "-2") {
        Get.snackbar("Error", "Invalid QR code");
      } else {
        var decodedResponse = jsonDecode(res.body);
        String riddle_riddle = decodedResponse["rid_riddle"];
        print("Confirmed");
        print("$scannedCode");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 200,
                bottom: 200,
              ),
              child: Dialog(
                backgroundColor:
                    Colors.transparent, // Make dialog background transparent
                child: Container(
                  padding: EdgeInsets.all(8.0), // Adjust padding as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/images/hintBG1.png"), // Specify your image path
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(
                        12), // Dialog-like rounded corners
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Use minimum space
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Riddle",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors
                                    .white)), // Adjust text color for visibility
                      ),
                      Text(
                        riddle_riddle,
                        style: TextStyle(color: Colors.white),
                      ), // Adjust text color for visibility
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 75,
                          right: 75,
                        ),
                        child: TextFormField(
                          controller: _answerController,
                          decoration: const InputDecoration(
                            hintText: "Enter your answer here",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ), // Adjust hint text color for visibility
                          ),
                          style: TextStyle(
                              color: Colors
                                  .white), // Adjust text color for visibility
                        ),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          _answerRiddle();
                        },
                        textColor: Colors.white,
                        color: Colors.black,
                        child: const Text("Submit"),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
      // Implement your validation or data submission logic here
      print("Scanned QR Code: $scannedCode");
    } catch (e) {
      print(e);
    }
  }

  // void _submitAnswer(String answer) async {
  //   Map<String, dynamic> jsonData = {
  //     "rid_roomId": widget.roomId.toString(),
  //     "rid_level": widget.teamLevel,
  //     "team_id": widget.teamId.toString(),
  //     "answer": answer,
  //   };

  //   Map<String, dynamic> requestBody = {
  //     "json": jsonEncode(jsonData),
  //     "operation": "answerRiddle",
  //   };

  //   var response = await http.post(
  //     Uri.parse("${SessionStorage.url}user.php"),
  //     body: requestBody,
  //   );

  //   if (response.statusCode == 200) {
  //     var result = jsonDecode(response.body);
  //     if (result == -1) {
  //       Get.snackbar("Incorrect", "The answer is incorrect.");
  //     } else if (result is Map) {
  //       // Assuming result contains the hint for the next riddle
  //       Get.snackbar("Correct", "Moving to the next level!");
  //       _refreshDataRiddles(); // Refresh riddles or update current level
  //     }
  //   } else {
  //     Get.snackbar("Error", "Failed to submit answer.");
  //   }
  // }
}
