import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  Widget build(context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            emailField(),
            passwordField(),
            Row(
              children: [
                submitButton(),
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                ),
                signUpButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String email;
  String password;
  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: (InputDecoration(
        labelText: 'Enter your PEC email address',
        hintText: 'example.bt19abc@pec.edu.in',
      )),
      validator: (String value) {
        if (value != null && !value.contains('@pec.edu.in')) {
          return 'not a valid pec email id';
        }
      },
      onSaved: (String value) {
        email = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Enter your password',
      ),
      validator: (String value) {
        if (value != null && value.length < 8) {
          return 'Invalid password, try again';
        }
      },
      onSaved: (String value) {
        password = value;
      },
    );
  }

  submitButton() {
    return ElevatedButton(
      child: Text('Login'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      },
    );
  }

  signUpButton() {
    return ElevatedButton(
        child: Text('Sign up'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUp()),
          );
        });
  }
}
