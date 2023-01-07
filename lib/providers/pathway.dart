// Programmer name: Chew Chai Syuen
// Program name: Puffway
// Description: An Indoor Vehicle Locator Mobile Application
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puffway/providers/path.dart';

class Pathway {
  Timestamp timestamp;
  String title;
  String? description;
  String? imageDocPath;
  List<PathItem>? paths;

  Pathway(
      {required this.timestamp,
      required this.title,
      this.description,
      this.imageDocPath,
      this.paths});

  factory Pathway.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Pathway(
        timestamp: data?['timestamp'],
        title: data?['title'],
        description: data?['description'],
        imageDocPath: data?['imageDocPath'],
        paths: data?['paths'] is Iterable
            ? List.from((data?['paths'] as List)
                .map((data) => PathItem(
                    direction: data?['direction'],
                    steps: data?['steps'],
                    imageURL: data?['imageURL'],
                    isHorizontal: data?['isHorizontal'],
                    textMemo: data?['textMemo'],
                    timestamp: data?['timestamp']))
                .toList())
            : null);
  }

  Map<String, dynamic> ToFirestore() {
    return {
      'timestamp': timestamp,
      'title': title,
      if (description != null) 'description': description,
      if (imageDocPath != null) 'imageDocPath': imageDocPath,
      'paths': paths
          ?.map((data) => {
                'direction': data.direction,
                'steps': data.steps,
                if (data.imageURL != null) 'imageURL': data.imageURL,
                if (data.isHorizontal != null)
                  'isHorizontal': data.isHorizontal,
                if (data.textMemo != null) 'textMemo': data.textMemo,
                'timestamp': data.timestamp
              })
          .toList()
    };
  }
}

// class PathwayItem with ChangeNotifier {
//   List<Pathway> pathways = [];

//   List<Pathway> get allPathways {
//     return [...pathways];
//   }
// }

// class PathwayItems {
//   List<Pathway> pathways = [];

//   List<Pathway> get allPathways {
//     return [...pathways];
//   }

//   set allPathways(List<Pathway> firestorePathways) {
//     pathways = firestorePathways;
//   }
// }
