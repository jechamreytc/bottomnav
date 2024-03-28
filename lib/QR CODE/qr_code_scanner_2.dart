import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class QrCodeScanner2 extends StatefulWidget {
  const QrCodeScanner2({Key? key}) : super(key: key);

  @override
  _QrCodeScanner2State createState() => _QrCodeScanner2State();
}

class _QrCodeScanner2State extends State<QrCodeScanner2> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  @override
  Widget build(BuildContext context) {
    String result = '';
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                    context: context,
                    onCode: (code) {
                      print("scanned code: $code");
                    },
                  );
                },
                child: Text(code ?? "Click me"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
