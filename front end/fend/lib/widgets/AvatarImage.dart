import 'package:fend/screens/HamburgerMenuOptions/AvatarChoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatefulWidget {
  final String currentImage;
  Function callBack;

  AvatarImage({this.currentImage, this.callBack});

  @override
  _AvatarImageState createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset(widget.currentImage),
      onTap: () {
        widget.callBack();
        setState(() {
          selectedAvatar = widget.currentImage;
        });
      },
    );
  }
}