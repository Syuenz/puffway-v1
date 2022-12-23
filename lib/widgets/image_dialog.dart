import 'package:flutter/material.dart';
import 'dart:io';

class ImageDialog extends StatelessWidget {
  const ImageDialog(
      {super.key, required this.imageURL, required this.isHorizontal});

  // final String imageURL;
  final File imageURL;
  final isHorizontal;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: AspectRatio(
          aspectRatio: isHorizontal ? 4 / 3 : 3 / 4,
          // child: Image.network(
          //   "https://images.unsplash.com/photo-1609645778471-613f21fcf3df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmVydGljYWwlMjB3YWxscGFwZXJ8ZW58MHx8MHx8&w=1000&q=80",
          //   fit: BoxFit.fill,
          //   alignment: Alignment.center,
          // ),
          child: Image.file(
            imageURL,
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
