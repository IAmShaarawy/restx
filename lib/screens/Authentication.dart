import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Constants.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var _error = "";

  var _loading = false;

  var _enabled = true;

  final _formKey = GlobalKey<FormState>();

  final _phoneTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Authentication"),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    enabled: _enabled,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      fillColor: Colors.teal.shade50,
                      filled: true,
                    ),
                    controller: _phoneTextController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _loading
                      ? SpinKitWave(
                          color: Colors.teal.shade400,
                          size: 20,
                        )
                      : FloatingActionButton(
                          backgroundColor: Colors.amberAccent,
                          onPressed: !_enabled
                              ? null
                              : () {
                                  _onSignIn(context);
                                },
                          child: Icon(Icons.phone),
                        ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    _error,
                    style: TextStyle(color: Colors.redAccent),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _onSignIn(BuildContext ctx) {
    setState(() {
      _error = "";
      _enabled = false;
      _loading = true;
    });
    print(_phoneTextController.text);
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneTextController.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: (authCredentials) async {
          try {
            AuthResult result = await FirebaseAuth.instance
                .signInWithCredential(authCredentials);
            String userId = result.user.uid;
            DocumentReference udr =
                Firestore.instance.collection("users").document(userId);
            var userResult = (await udr.get()).data;

            if (userResult == null) {
              var userName = "User ${userId.substring(0, 4)}";
              var userImg = "https://picsum.photos/seed/$userId/200";
              await udr.setData({
                'is_waiter': false,
                "number": _phoneTextController.text,
                "name": userName,
                "img": userImg
              });
              Navigator.pushReplacementNamed(ctx, ROUTE_QR);
            } else {
              if (userResult['is_waiter'] as bool) {
                Navigator.pushReplacementNamed(ctx, ROUTE_WAITER_HOME);
              } else {
                Navigator.pushReplacementNamed(ctx, ROUTE_QR);
              }
            }
          } catch (error) {
            resolveError(error);
          }
        },
        verificationFailed: resolveError,
        codeSent: null,
        codeAutoRetrievalTimeout: null);
  }

  void resolveError(error) {
    setState(() {
      print(error.message);
      _error = error.code;
      _enabled = true;
      _loading = false;
    });
  }
}
