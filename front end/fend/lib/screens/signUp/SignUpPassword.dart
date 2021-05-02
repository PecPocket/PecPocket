import 'package:fend/Databases/UserDB.dart';
import 'package:fend/classes/user.dart';
import 'package:fend/screens/signUp/SignUpSubjects.dart';
import 'package:flutter/material.dart';
import 'package:fend/globals.dart' as global;
import 'package:http/http.dart';

class SignUpPassword extends StatefulWidget {
  @override
  _SignUpPasswordState createState() => _SignUpPasswordState();
}

String password;
String confirmPassword;

class _SignUpPasswordState extends State<SignUpPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset('assets/bg2.png'),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
            child: Column(
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Enter password'),
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                Container(height: 30,),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  onChanged: (String value) {
                    confirmPassword = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: ElevatedButton(
                    onPressed: validatePassword,
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
              ],
            ),
          ),
          Image.asset('assets/bg1.png'),
        ],
      ),
    );
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
            context, MaterialPageRoute(builder: (context) => SignUp2()));
      });
    }
  }
}