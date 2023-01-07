// Programmer name: Chew Chai Syuen
// Program name: Puffway
// Description: An Indoor Vehicle Locator Mobile Application
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';
import 'dart:io';

class ImageDialog extends StatelessWidget {
  const ImageDialog(
      {super.key, required this.imageURL, required this.isHorizontal});

  final String imageURL;
  final isHorizontal;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Image.file(
        File(imageURL),
        fit: BoxFit.contain,
      ),
    );
  }
}
