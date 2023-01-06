import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:puffway/providers/path.dart';
import 'package:puffway/screens/path_info_screen.dart';
import 'package:puffway/screens/path_memo_screen.dart';
import 'package:puffway/utils/TurnsHandler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:motion_sensors/motion_sensors.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

import '../providers/appTheme.dart';
import '../widgets/customized_alert_dialog.dart';
import '../widgets/path_info_item.dart';

class RecordingScreen extends StatefulWidget {
  static const routeName = "/recording";
  late Timer _timer;
  final turnsController = Get.put(TurnsHandler());

  RecordingScreen({super.key});

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
  final steps = 0.obs;
  double exactDistance = 0.0;
  double previousMagnitude = 0.0;
  double magnitudeDelta = 0.0;
  var initial = true;
  var startTime = 1;

  //for confirmation dialog
  var refreshDegrees = false;

  //memo validation
  int lastMemoSteps = 0;
  var isMemoSaved = false;

  //dialog validation
  var isDialogShowing = false;

  //scroller
  // ScrollController _scrollController = ScrollController();
  AutoScrollController _scrollController = AutoScrollController();

  @override
  void initState() {
    super.initState();
    footstepsHandler();
    directionHandler();
    turnsHandlerListener();
    motionSensors.accelerometerUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
    motionSensors.orientationUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
  }

  @override
  void dispose() {
    widget.turnsController.removeListener(() {});
    _streamOrientationSubscription.cancel();
    _streamAccelerometerSubscription.cancel();
    Get.deleteAll();
    super.dispose();
  }

  void addPathsToGlobal(String direction) {
    //for continous turns
    if (steps.value > 0) {
      PathItem prevPath = PathItem(
          direction: 0, steps: steps.value, timestamp: Timestamp.now());
      Provider.of<PathItems>(context, listen: false).addPath(prevPath);
    }

    if (direction == "left") {
      PathItem turnPath = PathItem(direction: 1, timestamp: Timestamp.now());
      Provider.of<PathItems>(context, listen: false).addPath(turnPath);
    } else if (direction == "right") {
      PathItem turnPath = PathItem(direction: 2, timestamp: Timestamp.now());
      Provider.of<PathItems>(context, listen: false).addPath(turnPath);
    }
    steps.value = 0;
  }

  turnsHandlerListener() {
    widget.turnsController.turnValidation.listen((validation) async {
      if (validation) {
        widget.turnsController.turnValidation.value = false;
        await directionHandler();
        footstepsHandler();
        refreshDegrees = true;
      }
    });
  }

  void leftState() async {
    _streamOrientationSubscription.cancel();
    _streamAccelerometerSubscription.cancel();
    widget.turnsController.turnValidation.value = false;
    await Vibration.vibrate();
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomizedAlertDialog(
              content: "Turn Left?",
              yes: "Confirm",
              no: "Cancel",
              yesOnPressed: () {
                direction = 1; //left
                // directionPointer = 0.0;
                addPathsToGlobal("left");
                // turningHandler();
                widget.turnsController.turnValidation.value = true;
                Navigator.pop(context, '');
                return;
              },
              noOnPressed: () {
                // turningHandler();
                widget.turnsController.turnValidation.value = true;
                Navigator.pop(context, '');
                return;
              },
            )).then((value) {
      isDialogShowing = false;
      if (value != '') {
        // turningHandler();
        widget.turnsController.turnValidation.value = true;
        return;
      }
    });
    // if (!isDialogShowing) {
    //   isDialogShowing = true;

    // }
  }

  void rightState() async {
    _streamOrientationSubscription.cancel();
    _streamAccelerometerSubscription.cancel();
    widget.turnsController.turnValidation.value = false;
    await Vibration.vibrate();
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomizedAlertDialog(
              content: "Turn Right?",
              yes: "Confirm",
              no: "Cancel",
              yesOnPressed: () {
                direction = 1; //left
                // directionPointer = 0.0;
                addPathsToGlobal("right");
                // turningHandler();
                widget.turnsController.turnValidation.value = true;
                Navigator.pop(context, '');
                return;
              },
              noOnPressed: () {
                // turningHandler();
                widget.turnsController.turnValidation.value = true;
                Navigator.pop(context, '');
                return;
              },
            )).then((value) {
      isDialogShowing = false;
      if (value != '') {
        // turningHandler();
        widget.turnsController.turnValidation.value = true;
        return;
      }
    });
    // if (!isDialogShowing) {
    //   isDialogShowing = true;

    // }
  }

  Future<void> directionHandler() async {
    _streamOrientationSubscription =
        motionSensors.orientation.listen((OrientationEvent event) async {
      _orientation.setValues(event.yaw, event.pitch, event.roll);
      if (await motionSensors.isOrientationAvailable()) {
        // currentDegree = (360 - degrees(_orientation.x) % 360).abs();
        if (refreshDegrees) {
          // directionPointer = currentDegree;
          directionPointer = (360 - degrees(_orientation.x) % 360).abs();
          refreshDegrees = false;
        }
        currentDegree = (360 - degrees(_orientation.x) % 360).abs();

        if (directionPointer < 40) {
          left = (directionPointer - 40 + 360).abs();
          right = (directionPointer + 40).abs();
        } else if (directionPointer > 319) {
          left = (directionPointer - 40).abs();
          right = (directionPointer + 40 - 360).abs();
        } else {
          left = (directionPointer - 40).abs();
          right = (directionPointer + 40).abs();
        }

        print('dP:$directionPointer');
        print('current: $currentDegree');
        print('left:$left');
        print('right:$right');
      }

      Future.delayed(Duration(milliseconds: 100));
      if ((currentDegree.truncate() / 10) * 10 == (left.truncate() / 10) * 10 &&
          !isDialogShowing) {
        isDialogShowing = true;
        leftState();
        return;
      } else if ((currentDegree.truncate() / 10) * 10 ==
              (right.truncate() / 10) * 10 &&
          !isDialogShowing) {
        isDialogShowing = true;
        rightState();
        return;
      } else {
        direction = 0; //straight
      }
      // setState(() {

      // });
    });
  }

  void startTimer() async {
    const oneMilSec = const Duration(milliseconds: 80);
    var time = startTime;
    widget._timer = Timer.periodic(
      oneMilSec,
      (Timer timer) {
        if (time == 0) {
          timer.cancel();
          startTime = 1;
        } else {
          startTime--;
          time--;
        }
      },
    );
    // if (startTime == 0) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Future<void> footstepsHandler() async {
    _streamAccelerometerSubscription =
        motionSensors.accelerometer.listen((AccelerometerEvent event) async {
      exactDistance = calculateMagnitude(event.x, event.y, event.z);
      magnitudeDelta = exactDistance - previousMagnitude;
      previousMagnitude = exactDistance;

      if (magnitudeDelta > 3 && startTime == 1) {
        if (initial == false) {
          startTimer();
          steps.value++;

          // setState(() {
          //   steps++;
          // });
        } else {
          directionPointer = (360 - degrees(_orientation.x) % 360).abs();
          initial = false;
        }
      }
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
      widget.turnsController.turnValidation.value = false;
      print("cancel");
    } else {
      print("resume");
      widget.turnsController.turnValidation.value = true;
    }
  }

  // void turningHandler() {
  //   setState(() {
  //     refreshDegrees = true; //to set the directionPointer to new degree
  //     isDialogShowing = false;
  //   });
  // }

  void memoSavedHandler() {
    //refresh the current steps
    steps.value = 0;
    isMemoSaved = true; //to detect is a memo has been saved before
  }

  bool memoButtonHandler() {
    if (steps > 0) {
      if (steps < 10 && isMemoSaved) {
        return false;
      } else if (steps >= 10 && isMemoSaved) {
        return true;
      }
    } else {
      return false;
    }
    return true;
  }

  void resetSteps() {
    steps.value = 0;
    // setState(() {
    //   steps = 0;
    // });
  }

  Future<bool> showDiscardDialog() async {
    sensorsHandler(true);
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomizedAlertDialog(
              content: "Discard Recording?",
              yes: "Confirm",
              no: "Cancel",
              yesOnPressed: () {
                Provider.of<PathItems>(context, listen: false).clearAllPath();
                Navigator.pop(context, true);
              },
              noOnPressed: () {
                Navigator.pop(context, false);
              },
            )).then((value) {
      if (value != null) {
        if (!value) {
          sensorsHandler(false);
          return;
        } else {
          sensorsHandler(true);
          Navigator.pop(context);
          return;
        }
      } else {
        sensorsHandler(false);
        return;
      }
    });
    return false;
  }

  Future<void> deleteImageFromApp() async {
    List<PathItem> allPaths =
        Provider.of<PathItems>(context, listen: false).allPaths;

    allPaths.forEach((element) async {
      if (element.imageURL != null) {
        File imageOldFile = File(element.imageURL!);
        imageOldFile.deleteSync(recursive: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final paths = Provider.of<PathItems>(context).allPaths;

    return WillPopScope(
      onWillPop: showDiscardDialog,
      child: Scaffold(
        appBar: AppBar(title: const Text("Pathway Record")),
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
                            steps.value <= 0 ? steps.value = 0 : steps.value--;
                          },
                          // backgroundColor: Colors.amber,
                          child: const Icon(Icons.remove),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Obx(() => Text(
                              "${steps.value}",
                              style: TextStyle(
                                  fontSize: 80 / 720 * mediaQuery.size.height,
                                  fontWeight: FontWeight.w400),
                            )),
                        const Spacer(
                          flex: 1,
                        ),
                        FloatingActionButton(
                          heroTag: "plusbtn",
                          onPressed: () {
                            steps.value++;
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
                  style: TextStyle(fontSize: 16 / 720 * mediaQuery.size.height),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Provider.of<AppTheme>(context, listen: true)
                                  .isDarkMode
                              ? Colors.grey
                              : Color.fromARGB(255, 255, 186, 229),
                          borderRadius: BorderRadius.circular(20)),
                      child: Consumer<PathItems>(builder: (ctx, path, _) {
                        List<PathItem> allPaths =
                            Provider.of<PathItems>(context, listen: false)
                                .allPaths;
                        if (allPaths.isNotEmpty) {
                          final lastPosition = allPaths.length;
                          _scrollController.scrollToIndex(lastPosition,
                              preferPosition: AutoScrollPosition.begin);
                        }

                        return ListView(
                          controller: _scrollController,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          scrollDirection: Axis.vertical,
                          children: [
                            ...paths.map((path) {
                              return AutoScrollTag(
                                key: ValueKey(path.timestamp),
                                controller: _scrollController,
                                index: paths.indexOf(path),
                                child: Card(
                                  elevation: 6,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: PathInfoItem(
                                    path: path,
                                  ),
                                ),
                              );
                            })
                          ],
                          // itemCount: paths.length,
                          // itemBuilder: (BuildContext ctx, index) {

                          // }
                        );

                        // return ListView.builder(
                        //     controller: _scrollController,
                        //     padding: EdgeInsets.only(top: 10, bottom: 10),
                        //     scrollDirection: Axis.vertical,
                        //     itemCount: paths.length,
                        //     itemBuilder: (BuildContext ctx, index) {
                        //       return Card(
                        //         elevation: 6,
                        //         margin: const EdgeInsets.symmetric(
                        //           vertical: 8,
                        //           horizontal: 20,
                        //         ),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(20),
                        //         ),
                        //         child: PathInfoItem(
                        //           path: paths[index],
                        //         ),
                        //       );
                        //     });
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => RecordingBottom(
                    sensorsHandler: sensorsHandler,
                    isMemoEnabled: memoButtonHandler(),
                    memoSavedHandler: memoSavedHandler,
                    deleteImageFromApp: deleteImageFromApp,
                    showDiscardDialog: showDiscardDialog,
                    steps: steps.value,
                    paths: paths,
                    resetSteps: resetSteps,
                  ),
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
      required this.showDiscardDialog,
      required this.steps,
      required this.paths,
      required this.resetSteps})
      : super(key: key);

  Function sensorsHandler;
  Function memoSavedHandler;
  Function deleteImageFromApp;
  Function showDiscardDialog;
  bool isMemoEnabled;
  List<PathItem> paths;
  var steps;
  Function resetSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          heroTag: "cancelbtn",
          onPressed: () async {
            deleteImageFromApp();
            showDiscardDialog();
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
            print('save11');
            if (paths.isNotEmpty && steps == 0) {
              Navigator.of(context)
                  .pushNamed(PathInfoScreen.routeName)
                  .then((value) {
                print(value);
                if (value != null) {
                  if (value == "save") {
                    sensorsHandler(true);
                    Navigator.pop(context);
                  } else {
                    sensorsHandler(false);
                  }
                } else {
                  sensorsHandler(false);
                }
              });
            } else if (paths.isNotEmpty && steps > 0) {
              PathItem straightPath = PathItem(
                  direction: 0, timestamp: Timestamp.now(), steps: steps);
              Provider.of<PathItems>(context, listen: false)
                  .addPath(straightPath);
              resetSteps();
              Navigator.of(context)
                  .pushNamed(PathInfoScreen.routeName)
                  .then((value) {
                print(value);
                sensorsHandler(false);
                // if (value != null) {
                //   if (value == "save") {
                //     print("recordingsave");
                //     sensorsHandler(true);
                //     Navigator.pop(context);
                //   }
                // } else {
                //   sensorsHandler(false);
                // }
              });
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        content: const Text(
                            "No paths are recorded. Please try again"),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).primaryColor),
                            onPressed: () {
                              Navigator.of(context).pop();
                              sensorsHandler(false);
                            },
                            child: const Text('Okay'),
                          ),
                        ],
                      ));
            }
          },
          backgroundColor: paths.isNotEmpty ? Colors.green : Colors.grey,
          child: const Icon(Icons.check),
        ),
      ],
    );
  }
}
