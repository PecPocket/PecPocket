import 'package:flutter/material.dart';

class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Settings'),
          ),
          ListTile(
            title: Text('Custom Folder'),
          ),
          ListTile(
            title: Text('Edit Subjects'),
          ),
          ListTile(
            title: Text('Add Instagram Handle'),
          ),
          ListTile(
            title: Text('Add/Update Clubs'),
          ),
          ListTile(
            title: Text('Change Password'),
          ),
          ListTile(
            title: Text('Security (random lol)'),
          ),
        ],
      ),
    );
  }
}
