import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';
import 'package:restx/screens/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  QRCaptureController _captureController = QRCaptureController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _captureController.onCapture((data) async {
      _captureController.pause();
      setState(() {
        _isLoading = true;
      });
      await (await SharedPreferences.getInstance())
          .setString(TABLE_NUMBER, data);
      await Future.delayed(Duration(seconds: 3));
      navigatorKey.currentState.pushReplacementNamed(ROUTE_MENU);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? Loading()
            : SizedBox(
                height: 300,
                width: 300,
                child: QRCaptureView(controller: _captureController),
              ),
      ),
    );
  }
}
