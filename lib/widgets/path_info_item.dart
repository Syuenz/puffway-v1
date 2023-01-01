import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:puffway/providers/path.dart';
import '../widgets/image_dialog.dart';

class PathInfoItem extends StatelessWidget {
  const PathInfoItem({super.key, required this.path});

  final PathItem path;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: path.direction == 0 &&
              (path.textMemo != null || path.imageURL != null)
          ? const EdgeInsets.only(top: 5, left: 8, right: 8)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              path.direction == 0
                  ? MaterialCommunityIcons.arrow_up_bold
                  : path.direction == 1
                      ? MaterialCommunityIcons.arrow_left_top_bold
                      : MaterialCommunityIcons.arrow_right_top_bold,
              size: path.direction == 0
                  ? mediaQuery.size.height / 19
                  : mediaQuery.size.height / 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              path.direction == 0
                  ? path.steps == 0
                      ? "Head straight"
                      : "Keep walking for ${path.steps} steps"
                  : path.direction == 1
                      ? "Turn Left"
                      : "Turn Right",
              style: TextStyle(
                  fontSize: 17 / 720 * mediaQuery.size.height,
                  fontWeight: FontWeight.w500),
            ),
          ]),
          if (path.imageURL != null)
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Stack(children: [
                SizedBox(
                  width: path.isHorizontal == true
                      ? mediaQuery.size.width * 0.55
                      : null,
                  height: path.isHorizontal == true
                      ? null
                      : mediaQuery.size.height / 4,
                  child: Image.file(
                    File(path.imageURL!),
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => ImageDialog(
                                  imageURL: path.imageURL!,
                                  isHorizontal: path.isHorizontal,
                                ));
                      },
                    ),
                  ),
                )
              ]),
            ),
          if (path.textMemo != null)
            Text(
              path.textMemo!,
              style: TextStyle(fontSize: 14 / 720 * mediaQuery.size.height),
            ),
          if (path.direction == 0 &&
              (path.textMemo != null || path.imageURL != null))
            const SizedBox(
              height: 10,
            )
        ],
      ),
    );
  }
}
