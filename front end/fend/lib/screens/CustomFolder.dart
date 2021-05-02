import 'dart:io';

import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomFolder extends StatefulWidget {
  @override
  _CustomFolderState createState() => _CustomFolderState();
}

List<String> files = ['default file'];

class _CustomFolderState extends State<CustomFolder> {
  String selectedImagePath = 'none';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Folder'),
      ),
      bottomNavigationBar: bottomAppBar(),
      body: Column(
        children: [
          Center(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 75.0),
                ),
                ElevatedButton(
                    onPressed: () {
                      addImage(context);
                    },
                    child: Text('Add Image')),
                Container(
                  padding: EdgeInsets.only(left: 50.0),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Add Pdf')),
              ],
            ),
          ),
          Expanded(
            child: new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: files.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(files[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addImage(BuildContext context) async {
    ImagePicker picker = new ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() async {
      print(pickedFile.path.split('/').last);
      selectedImagePath = pickedFile.path;
    });
  }
}
