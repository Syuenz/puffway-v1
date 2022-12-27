import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:puffway/providers/path.dart';
import 'package:puffway/screens/path_info_screen.dart';
import 'package:puffway/screens/path_memo_screen.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:motion_sensors/motion_sensors.dart';

import 'package:flutter/material.dart';
import '../widgets/all_directions_body.dart';
import '../widgets/customized_alert_dialog.dart';
import '../widgets/path_info_item.dart';
import '../widgets/recording_bottom.dart';

class RecordingScreen extends StatefulWidget {
  static const routeName = "/recording";

  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  // Vector3 _accelerometer = Vector3.zero();
  final Vector3 _orientation = Vector3.zero();
  late StreamSubscription<dynamic> _streamAccelerometerSubscription;
  late StreamSubscription<dynamic> _streamOrientationSubscription;

  //direction
  double directionPointer = 0.0;
  double currentDegree = 0.0;
  double left = 0.0;
  double right = 0.0;
  int direction = 0;

  //footsteps
  int steps = 0;
  double exactDistance = 0.0;
  double previousMagnitude = 0.0;
  double magnitudeDelta = 0.0;
  var initial = true;

  //for confirmation dialog
  var refreshDegrees = false;

  //memo validation
  int lastMemoSteps = 0;
  var isMemoSaved = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<PathItems>(context, listen: false).clearAllPath();
    footstepsHandler();
    directionHandler();
    motionSensors.accelerometerUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
    motionSensors.orientationUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
  }

  @override
  void dispose() {
    super.dispose();
    _streamOrientationSubscription.cancel();
    _streamAccelerometerSubscription.cancel();
  }

  void addPathsToGlobal(String direction) {
    //for continous turns
    if (steps > 0) {
      PathItem prevPath = PathItem(direction: 0, steps: steps);
      Provider.of<PathItems>(context, listen: false).addPath(prevPath);
    }

    if (direction == "left") {
      PathItem turnPath = PathItem(direction: 1);
      Provider.of<PathItems>(context, listen: false).addPath(turnPath);
    } else if (direction == "right") {
      PathItem turnPath = PathItem(direction: 2);
      Provider.of<PathItems>(context, listen: false).addPath(turnPath);
    }
    steps = 0;
  }

  Future<void> directionHandler() async {
    _streamOrientationSubscription =
        motionSensors.orientation.listen((OrientationEvent event) {
      setState(() {
        _orientation.setValues(event.yaw, event.pitch, event.roll);
        if (initial || refreshDegrees) {
          directionPointer = 360 - degrees(_orientation.x) % 360;
          refreshDegrees = false;
        }
        currentDegree = 360 - degrees(_orientation.x) % 360;

        // if (directionPointer < 79) {
        //   left = directionPointer - 80 + 360;
        //   right = directionPointer + 80;
        // } else if (directionPointer > 279) {
        //   left = directionPointer - 80;
        //   right = directionPointer + 80 - 360;
        // } else {
        //   left = directionPointer - 80;
        //   right = directionPointer + 80;
        // }

        if (directionPointer < 39) {
          left = directionPointer - 40 + 360;
          right = directionPointer + 40;
        } else if (directionPointer > 319) {
          left = directionPointer - 40;
          right = directionPointer + 40 - 360;
        } else {
          left = directionPointer - 40;
          right = directionPointer + 40;
        }

        if (currentDegree.toStringAsFixed(0) == left.toStringAsFixed(0)) {
          _streamOrientationSubscription.cancel();
          _streamAccelerometerSubscription.cancel();
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomizedAlertDialog(
                    content: "Turn Left?",
                    yes: "Confirm",
                    no: "Cancel",
                    yesOnPressed: () {
                      direction = 1; //left
                      directionPointer = left;
                      addPathsToGlobal("left");
                      turningHandler();
                      Navigator.of(context).pop();
                    },
                    noOnPressed: () {
                      turningHandler();
                      Navigator.of(context).pop();
                    },
                  ));
        } else if (currentDegree.toStringAsFixed(0) ==
            right.toStringAsFixed(0)) {
          _streamOrientationSubscription.cancel();
          _streamAccelerometerSubscription.cancel();
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomizedAlertDialog(
                    content: "Turn Right?",
                    yes: "Confirm",
                    no: "Cancel",
                    yesOnPressed: () {
                      direction = 2; //right
                      directionPointer = right;
                      addPathsToGlobal("right");
                      turningHandler();
                      Navigator.of(context).pop();
                    },
                    noOnPressed: () {
                      turningHandler();
                      Navigator.of(context).pop();
                    },
                  ));
        } else {
          direction = 0; //straight
        }
      });
    });
  }

  Future<void> footstepsHandler() async {
    _streamAccelerometerSubscription =
        motionSensors.accelerometer.listen((AccelerometerEvent event) {
      exactDistance = calculateMagnitude(event.x, event.y, event.z);
      magnitudeDelta = exactDistance - previousMagnitude;
      previousMagnitude = exactDistance;

      setState(() {
        // _accelerometer.setValues(event.x, event.y, event.z);
        if (magnitudeDelta > 3) {
          if (initial == false) {
            steps++;
          } else {
            initial = false;
          }
        }
      });
    });
  }

  double calculateMagnitude(double x, double y, double z) {
    double distance = sqrt(x * x + y * y + z * z);
    return distance;
  }

  void sensorsHandler(bool isPause) {
    if (isPause) {
      _streamAccelerometerSubscription.cancel();
      _streamOrientationSubscription.cancel();
    } else {
      directionHandler();
      footstepsHandler();
    }
  }

  void turningHandler() {
    refreshDegrees = true; //to set the directionPointer to new degree
    directionHandler();
    footstepsHandler();
  }

  void memoSavedHandler() {
    //refresh the current steps
    steps = 0;
    isMemoSaved = true; //to detect is a memo has been saved before
  }

  bool memoButtonHandler() {
    if (steps < 10 && isMemoSaved) {
      return false;
    } else if (steps >= 10 && isMemoSaved) {
      return true;
    }
    return true;
  }

  Future<bool> showDiscardDialog() async {
    return await showDialog(
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (BuildContext context) => CustomizedAlertDialog(
                  content: "Discard Recording?",
                  yes: "Confirm",
                  no: "Cancel",
                  yesOnPressed: () {
                    //not needed as when pathway is added path list should be cleared
                    Provider.of<PathItems>(context, listen: false)
                        .clearAllPath();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  noOnPressed: () {
                    Navigator.pop(context);
                  },
                )) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<void> deleteImageFromApp() async {
    List<Map<String, dynamic>> allPaths =
        Provider.of<PathItems>(this.context, listen: false).allPaths;
    allPaths.forEach((element) async {
      if (element.containsKey('imageURL')) {
        File imageOldFile = element['imageURL'];
        imageOldFile.deleteSync(recursive: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: showDiscardDialog,
      child: Scaffold(
        appBar: AppBar(title: const Text("Path Record")),
        // backgroundColor: Colors.grey[200],
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(
                          flex: 3,
                        ),
                        FloatingActionButton(
                          heroTag: "minusbtn",
                          onPressed: () {
                            steps <= 0 ? steps = 0 : steps--;
                          },
                          // backgroundColor: Colors.amber,
                          child: const Icon(Icons.remove),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Text(
                          "$steps",
                          style: TextStyle(
                              fontSize: 80 / 720 * mediaQuery.size.height,
                              fontWeight: FontWeight.w400),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        FloatingActionButton(
                          heroTag: "plusbtn",
                          onPressed: () {
                            steps++;
                          },
                          // backgroundColor: Colors.amber,
                          child: const Icon(Icons.add),
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                      ]),
                ),
                Text(
                  "Current Steps",
                  // "$currentDegree",
                  style: TextStyle(fontSize: 16 / 720 * mediaQuery.size.height),
                ),
                const SizedBox(height: 15),
                AllDirectionsBody(
                    // directionsList: paths,
                    bgColor: Color.fromARGB(255, 255, 186, 229)),
                const SizedBox(height: 20),
                RecordingBottom(
                  sensorsHandler: sensorsHandler,
                  isMemoEnabled: memoButtonHandler(),
                  memoSavedHandler: memoSavedHandler,
                  // context: context,
                  deleteImageFromApp: deleteImageFromApp,
                  steps: steps,
                )
              ],
            )),
      ),
    );
  }
}

class RecordingBottom extends StatelessWidget {
  var context;

  RecordingBottom(
      {Key? key,
      required this.sensorsHandler,
      required this.isMemoEnabled,
      required this.memoSavedHandler,
      required this.deleteImageFromApp,
      // required this.context,
      required this.steps})
      : super(key: key);

  Function sensorsHandler;
  Function memoSavedHandler;
  Function deleteImageFromApp;
  bool isMemoEnabled;
  var steps;

  // Future<void> deleteImageFromApp() async {
  //   print("run?");
  //   List<Map<String, dynamic>> allPaths =
  //       Provider.of<PathItems>(this.context, listen: false).allPaths;
  //   allPaths.forEach((element) async {
  //     if (element.containsKey('imageURL')) {
  //       print("run?");
  //       File imageOldFile = element['imageURL'];
  //       await imageOldFile.delete(recursive: false);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          heroTag: "cancelbtn",
          onPressed: () async {
            deleteImageFromApp();
            Navigator.of(context).pop();
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.clear),
        ),
        FloatingActionButton(
          heroTag: "memobtn",
          onPressed: () {
            sensorsHandler(true);
            if (isMemoEnabled) {
              Navigator.of(context).pushNamed(PathMemoScreen.routeName,
                  arguments: {
                    'memoSavedHandler': memoSavedHandler,
                    'steps': steps
                  }).then((value) {
                sensorsHandler(false);
              });
            } else {
              sensorsHandler(true);
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomizedAlertDialog(
                        content: "Distance is too short to provide memo again.",
                        yes: "Okay",
                        no: "Cancel",
                        yesOnPressed: () {
                          Navigator.of(context).pop();
                          sensorsHandler(false);
                        },
                        noOnPressed: () {
                          Navigator.of(context).pop();
                          sensorsHandler(false);
                        },
                      ));
            }
          },
          backgroundColor: isMemoEnabled ? Colors.amber : Colors.grey,
          child: const Icon(Icons.note_add_rounded),
        ),
        FloatingActionButton(
          heroTag: "savebtn",
          onPressed: () {
            sensorsHandler(true);
            Navigator.of(context)
                .pushNamed(PathInfoScreen.routeName)
                .then((value) {
              sensorsHandler(false);
            });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.check),
        ),
      ],
    );
  }
}
