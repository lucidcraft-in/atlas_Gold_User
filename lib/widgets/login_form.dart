import 'dart:convert';
import 'package:atlas_gold_user/common/colo_extension.dart';
import 'package:atlas_gold_user/screens/homeNavigation.dart';
import 'package:atlas_gold_user/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/dashBoard.dart';

class LoginForm extends StatefulWidget {
  // static const routeName = "/login-screen-form";
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var index;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  TextEditingController _customerIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();
  TextStyle style = TextStyle(
    fontFamily: 'latto',
    fontSize: 20.0,
    color: Colors.white,
  );

  login() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    String custId = _customerIdController.text.trim();
    String password = _passwordController.text.trim();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('custId', isEqualTo: custId)
          .where('phone_no', isEqualTo: password)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;

        if (docData != null) {
          Map userMap = {
            "id": doc.id,
            "name": docData['name'],
            "custId": docData["custId"],
            "phoneNo": docData["phone_no"],
            "address": docData["address"],
            "place": docData["place"],
            "balance": docData['balance'],
            "totalGram": docData["total_gram"],
            "branch": docData['branch'],
            "schemeType": docData["schemeType"],
            "nominee": docData['nominee'],
            "nomineePhone": docData['nomineePhone'],
            "nomineeRelation": docData['nomineeRelation'],
            "adharCard": docData['adharCard'],
            "panCard": docData['panCard'],
            "pinCode": docData['pinCode'],
            "token": docData['token'],
          };

          sharedPreferences.setString("user", json.encode(userMap));

          if (!mounted) return;
          final snackBar = SnackBar(
            content: const Text('Loggin Success.....'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeNavigation()),
              (Route<dynamic> route) => false);

          String? token = await FirebaseMessaging.instance.getToken();

          if (userMap['token'] == "" || userMap['token'] == null) {
            FirebaseFirestore.instance
                .collection('user')
                .doc(userMap['id'])
                .set({'token': token}, SetOptions(merge: true));
          }
        }
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        final snackBar = SnackBar(
          content: const Text('Invalid Customer id or Password!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text('Error: Could not connect. Please try again.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _form,
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: <Widget>[
            TextFormField(
              controller: _customerIdController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide Valid customer id.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(
                  color: Color.fromARGB(255, 73, 73, 73), fontSize: 18),
              decoration: InputDecoration(
                hintText: "Customer Id",
                hintStyle: TextStyle(color: Color.fromARGB(255, 61, 61, 61)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 52, 52, 52)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(
                  color: Color.fromARGB(255, 47, 47, 47), fontSize: 18),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Color.fromARGB(255, 61, 61, 61)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 52, 52, 52)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Material(
              elevation: 1.0,
              borderRadius: BorderRadius.circular(12.0),
              color: TColo.primaryColor2,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: _isLoading ? null : () {
                  login();
                },
                child: _isLoading 
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : Text("Login",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Color.fromARGB(255, 252, 252, 252),
                            fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
