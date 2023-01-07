// Programmer name: Chew Chai Syuen
// Program name: Puffway
// Description: An Indoor Vehicle Locator Mobile Application
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';

class CustomizedAlertDialog extends StatelessWidget {
  CustomizedAlertDialog({
    super.key,
    // required this.title,
    required this.content,
    required this.yes,
    required this.no,
    required this.noOnPressed,
    required this.yesOnPressed,
  });

  // String title;
  String content;
  String yes;
  String no;
  // Function yesNoOnPressed;
  Function yesOnPressed;
  Function noOnPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text(title),
      content: Text(content),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: <Widget>[
        TextButton(
          child: Text(no),
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor),
          onPressed: () {
            noOnPressed();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(elevation: 3),
          child: Text(
            yes,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          // textColor: Colors.redAccent,
          onPressed: () {
            yesOnPressed();
          },
        ),
      ],
    );
  }
}
