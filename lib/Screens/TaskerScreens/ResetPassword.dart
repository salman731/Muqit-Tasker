import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:MuqitTasker/Models/GeneralResponse.dart';
import 'package:MuqitTasker/Models/ClientLoginResponse.dart';
import 'package:MuqitTasker/Models/TaskerLoginResponse.dart';
import 'package:MuqitTasker/Screens/TaskerScreens/TaskerMainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPassword createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPasswordScreen> {
  final _auth = FirebaseAuth.instance;
  var email;
  var password;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  ProgressDialog progressDialog;
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  String userType = 'Tasker';
  var userTypes = ["Tasker", "Client"];
  bool islogin = true;
  StreamController<ErrorAnimationType> errorController;
  TextEditingController pintextEditingController = new TextEditingController();
  bool isCodesent = false;
  @override
  void initState() {}

  pinVerificationWidget(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveColor: Colors.green[500],
                  inactiveFillColor: Colors.green[200],
                  activeFillColor: Colors.green[600],
                  selectedColor: Colors.green[600]),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.green[50],
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: pintextEditingController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                setState(() {});
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            )),
        resendWidget()
      ],
    );
  }

  resendWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't receive the Code? "),
        InkWell(
            onTap: () {},
            child: Text("Resend",
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.red),
                  height: 80.0,
                  width: 80.0,
                  child: Center(
                    child: Image.asset(
                      "asset/images/muqitlogo.jpg",
                      height: 120.0,
                      width: 120.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: isCodesent
                      ? pinVerificationWidget(context)
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              labelText: "Enter Email Address",
                              labelStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                // borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: isCodesent
                        ? Text("Confirm",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ))
                        : Text("Send",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  minWidth: 250,
                  color: Colors.green,
                  splashColor: Colors.lightGreen,
                  onPressed: () async {
                    try {
                      progressDialog = new ProgressDialog(context);
                      progressDialog.style(
                          message: 'Logging In....',
                          borderRadius: 10.0,
                          backgroundColor: Colors.white,
                          progressWidget: CircularProgressIndicator(),
                          elevation: 10.0,
                          insetAnimCurve: Curves.easeInOut,
                          progress: 0.0,
                          maxProgress: 100.0,
                          progressTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400),
                          messageTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600));

                      if (emailController.text.isNotEmpty) {
                        if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text)) {
                          setState(() {
                            isCodesent = true;
                          });
                        } else {
                          Toast.show("Enter Valid Email Address.....", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      } else {
                        Toast.show("Enter Email.....", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
