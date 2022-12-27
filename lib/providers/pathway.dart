import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';

class Pathway {
  // final String? id;
  final Timestamp timestamp;
  final String title;
  final String? description;
  final String? deviceID;
  final List<Map<String, dynamic>> paths;

  Pathway(
      {
      // this.id,
      required this.timestamp,
      required this.title,
      this.description,
      required this.paths,
      this.deviceID});

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'title': title,
      'description': description,
      // 'paths': paths
    };
  }
}

class PathwayItem with ChangeNotifier {
  List<Map<String, dynamic>> pathways = [];

  void addPathwayTitleDesc(
      String title, String description, List<Map<String, dynamic>> paths) {
    Pathway newPathway = Pathway(
      timestamp: Timestamp.now(), //firestore timestamp
      title: title,
      description: description,
      paths: paths,
    );
    // addToFirestore(newPathway);
    notifyListeners();
  }

  void addPathwayTitle(String title, List<Map<String, dynamic>> paths) {
    Pathway newPathway = Pathway(
      timestamp: Timestamp.now(), //firestore timestamp
      title: title,
      paths: paths,
    );
    // addToFirestore(newPathway);
    notifyListeners();
  }

  void addToFirestore(Pathway newPathway) {
    String? deviceId;
    var db = FirebaseFirestore.instance;

    Future<void> initPlatformState() async {
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        deviceId = await PlatformDeviceId.getDeviceId;
      } on PlatformException {
        deviceId = 'Failed to get deviceId.';
      }
    }

    //add new pathway to firestore
    db.collection(deviceId!).add(newPathway.toMap()).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }

  List<Map<String, dynamic>> get allPathways {
    return [...pathways];
  }
}
