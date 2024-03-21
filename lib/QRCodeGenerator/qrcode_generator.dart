import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeGenerator extends StatefulWidget {
  const QrcodeGenerator({Key? key}) : super(key: key);

  @override
  _QrcodeGeneratorState createState() => _QrcodeGeneratorState();
}

class _QrcodeGeneratorState extends State<QrcodeGenerator> {
  late String idNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CSDL Attendance",
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "CSDL Q.R CODE GENERATOR",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Container(
              width: 300.0,
              child: TextField(
                onChanged: (value) {
                  setState(
                    () {
                      idNumber = value;
                    },
                  );
                },
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: "I.D Number",
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            RawMaterialButton(
              fillColor: Colors.white,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(
                horizontal: 36.0,
                vertical: 16.0,
              ),
              child: Text("Generate QR Code"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return QRCodeGenerator(
                      idNumber: idNumber,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QRCodeGenerator extends StatefulWidget {
  final String idNumber;

  QRCodeGenerator({
    required this.idNumber,
  });

  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Q.R CODE",
          style: TextStyle(
            color: Colors.black,
            decoration: TextDecoration.none,
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: 50,
        ),
        Center(
          child: QrImageView(
            data: ' ${widget.idNumber}',
            backgroundColor: Colors.white,
            size: 200.0,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
