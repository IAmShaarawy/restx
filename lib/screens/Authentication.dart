import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restx/screens/Loading.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var _error = "";

  var _loading = false;

  var _enabled = true;

  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
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
                      labelText: "Email",
                      fillColor: Colors.teal.shade50,
                      filled: true,
                    ),
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    enabled: _enabled,
                    decoration: InputDecoration(
                      labelText: "Password",
                      fillColor: Colors.teal.shade50,
                      filled: true,
                    ),
                    controller: _passwordTextController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 16,
                  ),

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.amberAccent,
                          onPressed: !_enabled
                              ? null
                              : () {
                                  _onSignIn(context);
                                },
                          child: Text("SignIn"),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.amberAccent,
                          onPressed: !_enabled
                              ? null
                              : () {
                                  _onSignUp(context);
                                },
                          child: Text("SignUp"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  _loading
                      ? SpinKitWave(
                          color: Colors.teal.shade400,
                          size: 20,
                        )
                      : Text(
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
    FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: _phoneTextController.text, timeout: null, verificationCompleted: null, verificationFailed: null, codeSent: null, codeAutoRetrievalTimeout: null);
//    FirebaseAuth.instance
//        .signInWithEmailAndPassword(
//            email: _emailTextController.text,
//            password: _passwordTextController.text)
//        .then((result) {
//      Navigator.pushReplacementNamed(ctx, "/home");
//    }, onError: (error) {
//      setState(() {
//        print(error);
//        _error = error.code;
//        _enabled = true;
//        _loading = false;
//      });
//    });
  }

  void _onSignUp(BuildContext ctx) {
    setState(() {
      _error = "";
      _enabled = false;
      _loading = true;
    });
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text)
        .then((result) {
      Navigator.pushReplacementNamed(ctx, "/home");
    }, onError: (error) {
      setState(() {
        _error = error.code;
        _enabled = true;
        _loading = false;
      });
    });
  }
}
