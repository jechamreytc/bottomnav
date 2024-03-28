// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class QrCodeScanner1 extends StatefulWidget {
//   const QrCodeScanner1({Key? key}) : super(key: key);

//   @override
//   _QrCodeScanner1State createState() => _QrCodeScanner1State();
// }

// class _QrCodeScanner1State extends State<QrCodeScanner1> {
//   bool isScanCompleted = false;
//   MobileScannerController cameraController = MobileScannerController();
//   String scannedCode = '';

//   @override
//   void initState() {
//     super.initState();
//     cameraController = MobileScannerController(
//       detectionSpeed: DetectionSpeed.noDuplicates,
//       returnImage: true,
//     );
//   }

//   @override
//   void dispose() {
//     cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan QR Code"),
//       ),
//       body: MobileScanner(
//         controller: cameraController,
//         onDetect: (capture) {
//           final List<Barcode> barcodes = capture.barcodes;
//           final Uint8List? image = capture.image;
//           for (final barcode in barcodes) {
//             print('${barcode.rawValue} (type: ${barcode.type})');
//           }
//           if (image != null) {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text(barcodes.isNotEmpty
//                       ? barcodes.first.rawValue ?? 'No code'
//                       : 'No barcodes'),
//                   content: image != null
//                       ? Image(image: MemoryImage(image))
//                       : Text('No image captured'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
