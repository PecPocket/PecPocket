import 'dart:convert';
import 'dart:math';
import 'package:fend/globals.dart' as global;
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/classes/user.dart';
import 'package:fend/models/student_json.dart';
import 'package:fend/screens/signUp/SignUpAvatarChoice.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mailer2/mailer.dart';

import '../login_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

var rng = new Random();
int otp = 100000 + rng.nextInt(999999 - 100000);

class _SignUpState extends State<SignUp> {
  String sid;
  String response;
  String password;
  String confirmPassword;
  String sidError;
  String otpError;
  String passwordError;
  bool sidCheck = false;
  bool otpCheck = false;
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
                    otpField(),
                    resendOtp(),
                    passwordField(),
                    confirmPasswordField(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 100,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'SID',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              errorText: sidError,
            ),
            onChanged: (String value) {
              setState(() {
                sid = value;
              });
            },
          ),
        ),
        Container(
          width: 30,
          child: IconButton(
            onPressed: validateSID,
            icon: Icon(
              Icons.check_circle,
              color: sidCheck ? Colors.green : Color(0xff272727),
            ),
          ),
        ),
      ],
    );
  }

  otpField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 100,
          child: TextFormField(
            enabled: sidCheck,
            decoration: InputDecoration(
              labelText: 'OTP',
              labelStyle: TextStyle(
                color: sidCheck ? Colors.black : Colors.grey,
              ),
              errorText: otpError,
            ),
            onChanged: (String value) {
              setState(() {
                response = value;
              });
            },
          ),
        ),
        Container(
          width: 30,
          child: IconButton(
            onPressed: validateUser,
            icon: Icon(
              Icons.check_circle,
              color: otpCheck ? Colors.green : Color(0xff272727),
            ),
          ),
        ),
      ],
    );
  }

  resendOtp() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 35,
        child: TextButton(
            child: Text(
              'Resend OTP',
              style: TextStyle(
                color: Color(0xff272727),
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {
              validateSID();
            }),
      ),
    );
  }

  passwordField() {
    return TextFormField(
      enabled: otpCheck,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: otpCheck ? Colors.black : Colors.grey,
        ),
        errorText: passwordError,
      ),
      onChanged: (String value) {
        setState(() {
          password = value;
        });
      },
    );
  }

  confirmPasswordField() {
    return TextFormField(
      enabled: otpCheck,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        labelStyle: TextStyle(
          color: otpCheck ? Colors.black : Colors.grey,
        ),
        errorText: passwordError,
      ),
      onChanged: (String value) {
        setState(() {
          confirmPassword = value;
          checkPasswordMatch();
        });
      },
    );
  }

  submitButton() {
    return ElevatedButton(
      onPressed: validatePassword,
      child: Text('Sign Up'),
      style: ElevatedButton.styleFrom(
        primary: Color(0xff272727),
        minimumSize: Size(MediaQuery.of(context).size.width, 45),
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
      ),
    );
  }

  toRegister() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Center(
        child: RichText(
          text: new TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              children: [
                new TextSpan(
                  text: 'Log In',
                  style: TextStyle(
                    color: Color(0xff272727),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login())),
                )
              ]),
        ),
      ),
    );
  }

  validateSID() async {
    var response = await get(Uri.parse('${global.url}/signup/$sid'));
    String body = response.body;

    if (body[12] == '2') {
      var options = new GmailSmtpOptions()
        ..username = 'pecpocket@gmail.com'
        ..password = 'PecPocket123';

      var emailTransport = new SmtpTransport(options);

      var envelope = new Envelope()
        ..from = 'pecpocket@gmail.com'
        ..recipients.add('theofficial.kauts@gmail.com')
        ..subject = 'Welcome to PecPocket'
        ..html = '<h3>$otp<h3>\n<p></p>';

      await emailTransport.send(envelope);
      var response = await get(Uri.parse('${global.url}/super/$sid'));
      StudentData studentData =
          StudentData.fromJson(json.decode(response.body));

      setState(() {
        global.sid = sid;
        print(body);
        sidCheck = true;
        sidError = null;
      });
    } else if (body[14] == '2') {
      setState(() {
        print(body);
        sidError = 'SID already signed up';
      });
    } else {
      setState(() {
        sidError = 'Not a valid PEC SID';
      });
    }
  }

  validateUser() {
    if (response == otp.toString()) {
      setState(() {
        otpCheck = true;
        otpError = null;
      });
    } else {
      setState(() {
        otpError = 'OTP does not match the one sent on your PEC Email';
      });
    }
  }

  checkPasswordMatch() {
    if (password == confirmPassword) {
      setState(() {
        passwordError = null;
      });
    } else {
      setState(() {
        passwordError = "Passwords don't match";
      });
    }
  }

  validatePassword() async {
    print(password);
    print(confirmPassword);
    print(global.sid);
    if (password == confirmPassword) {
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"SID": ${global.sid}, "Password": "${password}"}';

      var response = await post(Uri.parse('${global.url}/signup'),
          headers: headers, body: json);
      print(response.body);

      //global.password = password;
      var userDBHelper = UserDatabase.instance;
      User user = User(
          id: 0,
          sid: int.parse(global.sid),
          password: password,
          auth: int.parse(response.body[12]),
          login: 1);
      userDBHelper.addUser(user);
      var gotUser = await userDBHelper.getAllUsers();
      print(gotUser[0].auth);
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SignUpAvatarChoice())); // go to add subjects page
      });
    } else {
      setState(() {
        passwordError = "Passwords don't match";
      });
    }
  }
}
