import 'package:bottomnav/Room%20Page/room_page.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  // void password() {
  //   if (barcode != null && barcode!.code == "123456") {
  //     navigatorKey.currentState?.push(MaterialPageRoute(
  //       builder: (context) => RoomPage(),
  //     ));
  //   } else {
  //     print("Wrong Password");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
            Positioned(bottom: 10, child: buildResult()),
          ],
        ),
      ),
    );
  }

  Widget buildResult() => Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Text(
          barcode != null ? 'Result : ${barcode!.code}' : 'Scan a code',
          maxLines: 3,
          style: TextStyle(fontSize: 10.0),
        ),
      );

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) {
        setState(() {
          this.controller = controller;
        });
        this.controller.scannedDataStream.listen((barcode) {
          setState(() {
            this.barcode = barcode;
            print('Scanned Barcode: ${barcode.code}');
          });
        });
      },
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }
}
