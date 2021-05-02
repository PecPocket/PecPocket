import 'package:fend/widgets/AvatarImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mainPage.dart';

String selectedAvatar = 'assets/001-woman.png';

class AvatarChoice extends StatefulWidget {
  @override
  _AvatarChoiceState createState() => _AvatarChoiceState();
}

class _AvatarChoiceState extends State<AvatarChoice> {
  String currentAvatar;

  void callback() {
    setState(() {
    });
  }

  List<String> images = [
    'assets/001-woman.png',
    'assets/002-man.png',
    'assets/003-woman.png',
    'assets/004-woman.png',
    'assets/005-man.png',
    'assets/006-woman.png',
    'assets/007-woman.png',
    'assets/008-woman.png',
    'assets/009-woman.png',
    'assets/010-woman.png',
    'assets/011-man.png',
    'assets/012-woman.png',
    'assets/013-man.png',
    'assets/014-man.png',
    'assets/015-woman.png',
    'assets/016-woman.png',
    'assets/017-woman.png',
    'assets/018-woman.png',
    'assets/019-man.png',
    'assets/020-man.png',
    'assets/021-man.png',
    'assets/022-woman.png',
    'assets/023-woman.png',
    'assets/024-man.png',
    'assets/025-woman.png',
    'assets/026-man.png',
    'assets/027-woman.png',
    'assets/028-woman.png',
    'assets/029-man.png',
    'assets/030-woman.png',
    'assets/031-woman.png',
    'assets/032-man.png',
    'assets/033-woman.png',
    'assets/034-man.png',
    'assets/035-woman.png',
    'assets/036-man.png',
    'assets/037-woman.png',
    'assets/038-man.png',
    'assets/039-woman.png',
    'assets/040-woman.png',
    'assets/041-man.png',
    'assets/042-woman.png',
    'assets/043-woman.png',
    'assets/044-woman.png',
    'assets/045-woman.png',
    'assets/046-woman.png',
    'assets/047-woman.png',
    'assets/048-woman.png',
    'assets/049-man.png',
    'assets/050-woman.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Your Avatar", style: TextStyle( color: Color(0xffCADBE4), fontSize: 32,),),
        backgroundColor: Color(0xff588297),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xffB2B0E1),
        icon: Icon(Icons.check, size: 35),
        label: Container(
          child: Image.asset(selectedAvatar),
          height: 50,
        ),
        onPressed: () {
          print(selectedAvatar);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        },
      ),
      body: Container(
          padding: EdgeInsets.all(12.0),
          child: GridView.builder(
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
            ),
            itemBuilder: (BuildContext context, int index){
              currentAvatar = images[index];
              return AvatarImage(currentImage: currentAvatar, callBack: callback,);
            },
          ),
        ),
    );
  }
}
