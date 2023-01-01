import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PathItem {
  int direction; // 0 = straight, 1 = left, 2 = right
  int steps; //if turn = 1 step
  String? imageURL;
  bool? isHorizontal; //0 = vertical, 1 = horizontal
  String? textMemo;
  Timestamp timestamp;

  PathItem({
    required this.direction,
    this.steps = 1,
    this.imageURL,
    this.isHorizontal,
    this.textMemo,
    required this.timestamp,
  });
}

class PathItems with ChangeNotifier {
  List<PathItem> paths = [];

  List<PathItem> get allPaths {
    return [...paths];
  }

  void addPath(PathItem newPath) {
    paths.add(newPath);
    notifyListeners();
  }

  void clearAllPath() {
    paths = [];
    notifyListeners();
  }
}
