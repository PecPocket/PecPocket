import 'package:fend/screens/signUp/SignUpPassword.dart';
import 'package:fend/screens/signUp/SignUpSubjects.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'signUpSID.dart';

class SignUpEmail extends StatefulWidget {
  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

String response;

class _SignUpEmailState extends State<SignUpEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset('assets/bg2.png'),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Enter the OTP sent to your PEC email account'),
                  onChanged: (String value) {
                    response = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 30),
                  child: ElevatedButton(
                      onPressed: validateUser,
                      child: Text('Submit'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return Color(0xffE28F22); // Use the component's default.
                        },
                      ),
                    ),
                  ),
                ),
                Image.asset('assets/bg1.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  validateUser() {
    if (response == otp.toString()) {
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUpPassword()));
      });
    }
  }
}