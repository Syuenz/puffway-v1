import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:puffway/providers/pathway.dart';
import 'package:puffway/screens/path_overview_screen.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _deviceId;

  Future<void> getDeviceID() async {
    PlatformDeviceId.getDeviceId.then((value) {
      setState(() {
        _deviceId = value;
      });
    });
  }

  @override
  void initState() {
    getDeviceID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("deviceID")
              .doc(_deviceId)
              .collection("pathway")
              .orderBy("timestamp", descending: true)
              .withConverter(
                  fromFirestore: Pathway.fromFirestore,
                  toFirestore: (Pathway pathwayItem, options) =>
                      pathwayItem.ToFirestore())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Pathway> pathways =
                  List.from(snapshot.data!.docs.map((e) => e.data()).toList());

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext ctx, index) {
                  return HistoryItem(
                    data: pathways[index],
                    documentID: snapshot.data!.docs[index].reference.id,
                    deviceID: _deviceId,
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }
}

class HistoryItem extends StatelessWidget {
  HistoryItem(
      {Key? key,
      required this.data,
      required this.documentID,
      required this.deviceID})
      : super(key: key);

  final Pathway data;
  String documentID;
  String deviceID;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      child: ListTile(
        title: Text(
          data.title,
          overflow: TextOverflow.fade,
        ),
        subtitle: Text(
            DateFormat('yyyy/MM/dd HH:mm:ss').format(data.timestamp.toDate())),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.directions_walk,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  if (data.imageDocPath != null) {
                    Directory(data.imageDocPath!).deleteSync(recursive: true);
                  }
                  FirebaseFirestore.instance
                      .collection("deviceID")
                      .doc(deviceID)
                      .collection("pathway")
                      .doc(documentID)
                      .delete();
                },
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        onTap: () {
          Navigator.of(context).pushNamed(
            PathOverviewScreen.routeName,
            arguments: {'data': data},
          );
        },
      ),
    );
  }
}
