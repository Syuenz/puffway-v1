import 'package:flutter/foundation.dart';

class PathItem with ChangeNotifier {
  final String id;
  final int direction; // 0 = left, 1 = right
  final int steps; //if turn = 1 step
  final String imageURL;
  final int imageOrientation; //0 = vertical, 1 = horizontal
  final String textMemo;

  PathItem({
    required this.id,
    required this.direction,
    required this.steps,
    required this.imageURL,
    required this.imageOrientation,
    required this.textMemo,
  });

  //testing
}
