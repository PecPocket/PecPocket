import 'package:fend/screens/signUp/signUpSID.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:fend/globals.dart' as global;
import 'mainPage.dart';

class Login extends StatefulWidget {
  createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  int sidFlag = 0;
  String sid;
  String password;
  final formKey = GlobalKey<FormState>();
  Widget build(context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset('assets/bg2.png'),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 5, 40, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  sidField(),
                  passwordField(),
                  submitButton(),
                ],
              ),
            ),
          ),
          toRegister(),
          Image.asset('assets/bg1.png'),
        ],
      ),
    );
  }

  sidField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'SID',
      ),
      onChanged: (String value) {
        setState(() {
          sid = value;
        });
      },
    );
  }

  passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      onChanged: (String value) {
        setState(() {
          password = value;
        });
      },
    );
  }

  submitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 20),
      child: ElevatedButton(
        onPressed: validateCredentials,
        child: Text('Log In'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Color(0xffE28F22); // Use the component's default.
              },
            ),
          ),
      ),
    );
  }

  toRegister() {
    return Center(
      child: RichText(
        text: new TextSpan(
            text: 'Do not have an account? ',
            style: TextStyle(
              color: Colors.grey,
            ),
            children: [
          new TextSpan(
            text: 'Register Now',
            style: TextStyle(
              color: Color(0xffE28F22)
            ),
            recognizer: new TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp1())),
          )
        ]),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      });
    } else if (body[14] == '4') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Incorrect Password'),
        ),
      );
    }
    //snackbar for incorrect password
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No such user'),
        ),
      );
      //snackBar for user not found
    }
  }
}
