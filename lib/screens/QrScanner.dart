import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      try {
        var tableRef = Firestore.instance.collection("tables").document(data);
        var tableData = (await tableRef.get()).data;
        if (tableData != null) {
          if (tableData["current_user"] == null) {
            var currentUserId = (await FirebaseAuth.instance.currentUser()).uid;
            await tableRef.setData({"current_user": currentUserId});
            navigatorKey.currentState.pushReplacementNamed(ROUTE_USER_HOME);
          } else {
            setState(() {
              _isLoading = false;
            });
            _captureController.resume();
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          _captureController.resume();
        }
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
        _captureController.resume();
      }
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
