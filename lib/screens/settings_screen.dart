import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 48,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              radius: 45,
              child: IconButton(
                  onPressed: () {}, iconSize: 60, icon: Icon(Icons.person)),
            ),
          ),
          Text(style: TextStyle(fontSize: 16), 'username')
        ],
      ),
    );
  }
}
