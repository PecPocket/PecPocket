import 'package:fend/screens/mainPage.dart';
import 'package:fend/screens/signUp/signUpSID.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:fend/globals.dart' as global;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int sidFlag = 0;
  String sid;
  String password;
  String sidError;
  String passwordError;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: ListView(
        children: [
          Image.asset(
            'assets/signup.png',
            height: 220,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 245,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(55), topRight: Radius.circular(55)),
              color: Colors.white,
            ),
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sidField(),
                    Container(
                      height: 20,
                    ),
                    passwordField(),
                    forgotPassword(),
                    toRegister(),
                    submitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  sidField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'SID',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        errorText: sidError,
      ),
      onChanged: (String value) {
        setState(() {
          sidError = null;
          sid = value;
        });
      },
    );
  }

  passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        errorText: passwordError,
      ),
      onChanged: (String value) {
        setState(() {
          passwordError = null;
          password = value;
        });
      },
    );
  }

  submitButton() {
    return ElevatedButton(
      onPressed: validateCredentials,
      child: Text('Log In'),
      style: ElevatedButton.styleFrom(
        primary: Color(0xff272727),
        minimumSize: Size(MediaQuery.of(context).size.width, 45),
        shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
      ),
    );
  }

  forgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Align(
        alignment: Alignment.centerRight,
        child: RichText(
          text: new TextSpan(
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
              children: [
                new TextSpan(
                  text: 'Forgot Password?',
                  style: TextStyle(color: Color(0xff272727)),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignUp())), // add forgot password page instead of signup
                )
              ]),
        ),
      ),
    );
  }

  toRegister() {
    return Padding(
      padding: const EdgeInsets.only(top: 90, bottom: 20),
      child: Center(
        child: RichText(
          text: new TextSpan(
              text: 'Do not have an account? ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              children: [
                new TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(
                    color: Color(0xff272727),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUp())),
                )
              ]),
        ),
      ),
    );
  }

  validateCredentials() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"SID": $sid, "Password": "$password"}';

    Response response = await post(Uri.parse('${global.url}/login'),
        headers: headers, body: json);

    String body = response.body;

    if (body.length == 32) {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      });
    } else if (body[14] == '4') {
      passwordError = 'Incorrect Password';
    }
    else {
      sidError = 'No such user';
    }
  }
}