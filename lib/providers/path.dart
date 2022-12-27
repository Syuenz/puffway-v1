import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PathItem {
  final Timestamp? id;
  final int direction; // 0 = straight, 1 = left, 2 = right
  final int steps; //if turn = 1 step
  final File? imageURL;
  final bool? isHorizontal; //0 = vertical, 1 = horizontal
  final String? textMemo;

  PathItem({
    this.id,
    required this.direction,
    this.steps = 1,
    this.imageURL,
    this.isHorizontal,
    this.textMemo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': Timestamp.now(),
      'direction': direction,
      'steps': steps,
      if (imageURL != null) 'imageURL': imageURL,
      if (isHorizontal != null) 'isHorizontal': isHorizontal,
      if (textMemo != null) 'textMemo': textMemo,
    };
  }
}

class PathItems with ChangeNotifier {
  // List<Map<String, dynamic>> paths = [];
  List<Map<String, dynamic>> paths = [
    {
      'id': Timestamp.now(),
      'direction': 0,
      'steps': 10,
      // 'imageURL':
      //     "https://images.unsplash.com/photo-1609645778471-613f21fcf3df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmVydGljYWwlMjB3YWxscGFwZXJ8ZW58MHx8MHx8&w=1000&q=80",
      // 'imageURL': File(
      //     '/data/user/0/com.example.puffway/app_flutter/scaled_17f843d2-c287-4624-95ae-ed40c80992714217851548102762773.jpg'),
      // 'isHorizontal': false,
      'textMemo': "testing",
    },
    {
      'id': Timestamp.now(),
      'direction': 1,
      'steps': 1,
    },
    // {
    //   'id': Timestamp.now(),
    //   'direction': 0,
    //   'steps': 10,
    //   'textMemo': "testing",
    // },
  ];

  List<Map<String, dynamic>> get allPaths {
    return [...paths];
  }

  void addPath(PathItem newPath) {
    paths.add(newPath.toMap());
    // print(newPath.toMap());
    notifyListeners();
  }

  void clearAllPath() {
    paths = [];
    notifyListeners();
  }
}
