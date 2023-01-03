import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:puffway/providers/path.dart';
import 'package:puffway/screens/path_overview_screen.dart';
import 'package:puffway/widgets/image_dialog.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';

import '../providers/appTheme.dart';
import '../screens/directions_screen.dart';
import '../providers/pathway.dart';
import '../widgets/customized_alert_dialog.dart';

class StartTraceScreen extends StatefulWidget {
  static const routeName = "/start-trace";

  const StartTraceScreen({super.key});

  @override
  State<StartTraceScreen> createState() => _StartTraceScreenState();
}

class _StartTraceScreenState extends State<StartTraceScreen> {
  //lists for progress
  List<PathItem> paths = [];
  List<PathItem> pastPaths = [];
  late List<PathItem> upcomingPaths;
  List<PathItem> execPaths = [];

  //path for display
  PathItem? currentPath;
  PathItem? nextPath;
  int ongoingSteps = 0;
  int currentTurns = 0;
  int previousTotalSteps = 0;
  int totalSteps = 0;
  int totalTurns = 0;
  SwiperController controller = SwiperController();

  //sensors
  final Vector3 _orientation = Vector3.zero();
  late StreamSubscription<dynamic> _streamAccelerometerSubscription;
  late StreamSubscription<dynamic> _streamOrientationSubscription;

  //footsteps
  double exactDistance = 0.0;
  double previousMagnitude = 0.0;
  double magnitudeDelta = 0.0;
  var initial = true;

  //direction
  double directionPointer = 0.0;
  double currentDegree = 0.0;
  double left = 0.0;
  double right = 0.0;
  int direction = 0;
  var refreshDegrees = false;

  var isDialogShowing = false;
  var isPause = false;
  var isEnd = false; //for play button

  List<Map<int, PathItem>> memoPaths = [];

  //tts
  late FlutterTts flutterTts;
  var isStopped = false;

  @override
  void initState() {
    super.initState();
    footstepsHandler();
    directionHandler();
    motionSensors.accelerometerUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
    motionSensors.orientationUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
    ttsConfig();
  }

  @override
  void dispose() {
    super.dispose();
    _streamOrientationSubscription.cancel();
    _streamAccelerometerSubscription.cancel();
    flutterTts.stop();
  }

  Future<void> footstepsHandler() async {
    _streamAccelerometerSubscription =
        motionSensors.accelerometer.listen((AccelerometerEvent event) {
      exactDistance = calculateMagnitude(event.x, event.y, event.z);
      magnitudeDelta = exactDistance - previousMagnitude;
      previousMagnitude = exactDistance;

      setState(() {
        if (magnitudeDelta > 3) {
          if (initial == false) {
            ongoingSteps++;
            if (memoPaths.isNotEmpty) {
              memoSwipeHandler();
            }
            if (upcomingPaths.isNotEmpty) {
              pathHandler();
            }
            if (currentPath?.direction == 2) {
              flutterTts.speak("Turn Left");
            } else if (currentPath?.direction == 1) {
              flutterTts.speak("Turn Right");
            }
          } else {
            initial = false;
            upcomingPaths = [...paths.reversed];
            currentPath = upcomingPaths.elementAt(0);
            nextPath = upcomingPaths.elementAt(1);
            execPaths.add(currentPath!);
            previousTotalSteps = calPreviousTotalSteps();
            if (currentPath?.direction == 2) {
              flutterTts.speak("Turn Left");
            } else if (currentPath?.direction == 1) {
              flutterTts.speak("Turn Right");
            }
          }
        }
      });
    });
  }

  double calculateMagnitude(double x, double y, double z) {
    double distance = sqrt(x * x + y * y + z * z);
    return distance;
  }

  int calPreviousTotalSteps() {
    var total = execPaths.fold(0, (sum, element) => sum + element.steps);
    return total;
  }

  void pathHandler() {
    PathItem pathToRemoved;
    if (previousTotalSteps == ongoingSteps) {
      setState(() {
        if (upcomingPaths.length > 2) {
          pathToRemoved = upcomingPaths.first;
          pastPaths.add(pathToRemoved);
          upcomingPaths.removeAt(0);
          currentPath = upcomingPaths.elementAt(0);
          nextPath = upcomingPaths.elementAt(1);
          execPaths.add(currentPath!);
          previousTotalSteps = calPreviousTotalSteps();
        } else if (upcomingPaths.length == 2) {
          pathToRemoved = upcomingPaths.first;
          pastPaths.add(pathToRemoved);
          upcomingPaths.removeAt(0);
          currentPath = upcomingPaths.elementAt(0);
          nextPath = null;
          execPaths.add(currentPath!);
          previousTotalSteps = calPreviousTotalSteps();
        }
        // else if (upcomingPaths.length == 1) {
        //   pathToRemoved = upcomingPaths.first;
        //   pastPaths.add(pathToRemoved);
        //   upcomingPaths.removeAt(0);
        //   currentPath = pathToRemoved;
        //   nextPath = null;
        //   execPaths.add(currentPath!);
        //   previousTotalSteps = calPreviousTotalSteps();
        // }
      });
    }
  }

  void memoSwipeHandler() {
    List keys = [];
    memoPaths.asMap().forEach((index, value) => keys.add(value.keys.first));

    if (keys.sublist(1).contains(ongoingSteps)) {
      controller.move(keys.indexOf(ongoingSteps));
    }
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

        if (currentPath?.direction == 2) {
          if (currentDegree.toStringAsFixed(0) == right.toStringAsFixed(0)) {
            sensorsHandler(true);
            if (!isDialogShowing) {
              isDialogShowing = true;
              Vibration.vibrate();
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: const Text('Please TURN LEFT.'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        refreshDegrees = true;
                        isDialogShowing = false;
                        Navigator.pop(context, '');
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                ),
              ).then((value) {
                print(value);
                if (value != '') {
                  turningHandler();
                }
              });
            }
          } else if (currentDegree.toStringAsFixed(0) ==
              left.toStringAsFixed(0)) {
            if (nextPath?.direction == 2) {
              flutterTts.speak("Turn Left");
            } else if (nextPath?.direction == 1) {
              flutterTts.speak("Turn Right");
            }
            setState(() {
              currentTurns++;
              ongoingSteps++;
              pathHandler();
              refreshDegrees = true;
            });
          }
        } else if (currentPath?.direction == 1) {
          if (currentDegree.toStringAsFixed(0) == left.toStringAsFixed(0)) {
            sensorsHandler(true);
            Vibration.vibrate();
            if (!isDialogShowing) {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: const Text('Please TURN RIGHT.'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        refreshDegrees = true;
                        isDialogShowing = false;
                        Navigator.pop(context, '');
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                ),
              ).then((value) {
                print(value);
                if (value != '') {
                  turningHandler();
                }
              });
            }
          } else if (currentDegree.toStringAsFixed(0) ==
              right.toStringAsFixed(0)) {
            if (nextPath?.direction == 2) {
              flutterTts.speak("Turn Left");
            } else if (nextPath?.direction == 1) {
              flutterTts.speak("Turn Right");
            }
            setState(() {
              currentTurns++;
              ongoingSteps++;
              pathHandler();
              refreshDegrees = true;
            });
          }
        }

        if (ongoingSteps == totalSteps && currentTurns == totalTurns) {
          playBtnHandler(true);
          flutterTts.speak("Reach Destination");
          isEnd = true;
          currentPath = null;
          PathItem pathToRemoved = upcomingPaths.first;
          pastPaths.add(pathToRemoved);
          upcomingPaths.removeAt(0);
          // execPaths.add(currentPath!);
          // previousTotalSteps = calPreviousTotalSteps();
        } else if (ongoingSteps == totalSteps) {
          playBtnHandler(true);
          flutterTts.speak("Reach Destination");
          isEnd = true;
          currentPath = null;
          PathItem pathToRemoved = upcomingPaths.first;
          pastPaths.add(pathToRemoved);
          upcomingPaths.removeAt(0);
          // execPaths.add(currentPath!);
          // previousTotalSteps = calPreviousTotalSteps();
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: const Text(
                  'Results may not be accurate as instructions are not followed.'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  ttsConfig() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage('en');
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(0.5);
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
    isDialogShowing = false;
    directionHandler();
    footstepsHandler();
  }

  void playBtnHandler(bool isPause) {
    setState(() {
      this.isPause = isPause;
      sensorsHandler(isPause);
    });
  }

  void ttsBtnHandler(bool isStopped) {
    this.isStopped = isStopped;
    if (isStopped) {
      flutterTts.setVolume(0);
    } else {
      flutterTts.setVolume(0.5);
    }
  }

  void directionBtnHandler() {
    if (ongoingSteps != totalSteps) {
      sensorsHandler(false);
    }
  }

  Future<bool> showDiscardDialog() async {
    sensorsHandler(true);
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomizedAlertDialog(
              content: "Discard Backtracking?",
              yes: "Confirm",
              no: "Cancel",
              yesOnPressed: () {
                Navigator.pop(context, true);
              },
              noOnPressed: () {
                sensorsHandler(false);
                Navigator.pop(context, false);
              },
            )).then((value) {
      if (value != null) {
        if (!value) {
          sensorsHandler(false);
        } else {
          sensorsHandler(true);
          Navigator.pop(context);
        }
      } else {
        sensorsHandler(false);
      }
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Pathway data = routeArgs['data'];
    paths = data.paths!;

    totalSteps = routeArgs['totalSteps'];
    totalTurns = routeArgs['totalTurns'];
    memoPaths = routeArgs['memoPaths'];
    final mediaQuery = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: showDiscardDialog,
      child: Scaffold(
          appBar: AppBar(title: Text(data.title)),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  padding: const EdgeInsets.all(0),
                  lineHeight: 15,
                  percent: ongoingSteps / totalSteps,
                  center: Text(
                    "${(ongoingSteps / totalSteps * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                        fontSize: 9 / 720 * mediaQuery.height,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  barRadius: Radius.circular(16),
                  // progressColor: Theme.of(context).primaryColorDark,
                  progressColor: Color.fromARGB(255, 43, 175, 40),
                ),
                const SizedBox(
                  height: 10,
                ),
                CurrentDirection(
                  mediaQuery: mediaQuery,
                  currentPath: currentPath,
                  nextPath: nextPath,
                  stepsToGo: previousTotalSteps - ongoingSteps,
                ),
                PathDetails(
                  mediaQuery: mediaQuery,
                  nextPath: nextPath,
                  totalSteps: totalSteps,
                  totalTurns: totalTurns,
                  ongoingSteps: ongoingSteps,
                  currentTurns: currentTurns,
                ),
                TraceBody(
                  mediaQuery: mediaQuery,
                  memoPaths: memoPaths,
                  totalSteps: totalSteps,
                  controller: controller,
                ),
                TraceBottom(
                  mediaQuery: mediaQuery,
                  paths: paths,
                  pastPaths: pastPaths,
                  sensorsHandler: sensorsHandler,
                  isPause: isPause,
                  playBtnHandler: playBtnHandler,
                  isEnd: isEnd,
                  ttsBtnHandler: ttsBtnHandler,
                  isStopped: isStopped,
                  directionBtnHandler: directionBtnHandler,
                )
              ],
            ),
          )),
    );
  }
}

class TraceBody extends StatelessWidget {
  TraceBody(
      {Key? key,
      required this.mediaQuery,
      required this.memoPaths,
      required this.totalSteps,
      required this.controller})
      : super(key: key);

  final Size mediaQuery;
  List<Map<int, PathItem>> memoPaths;
  int totalSteps;
  SwiperController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            elevation: 6,
            margin: const EdgeInsets.only(top: 20, bottom: 10
                // horizontal: 20,
                ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: memoPaths.isNotEmpty
                ? Container(
                    child: Swiper(
                      physics: const BouncingScrollPhysics(),
                      loop: false,
                      outer: true,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${(memoPaths[index].keys.first / totalSteps * 100).toStringAsFixed(0)}%",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (memoPaths[index].values.first.imageURL !=
                                    null)
                                  Expanded(
                                    child: SizedBox(
                                      width: memoPaths[index]
                                              .values
                                              .first
                                              .isHorizontal!
                                          ? mediaQuery.height / 3
                                          : null,
                                      child: InkWell(
                                        onTap: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (_) => ImageDialog(
                                                  imageURL: memoPaths[index]
                                                      .values
                                                      .first
                                                      .imageURL!,
                                                  isHorizontal: memoPaths[index]
                                                      .values
                                                      .first
                                                      .isHorizontal!));
                                        },
                                        child: Image.file(
                                          File(memoPaths[index]
                                              .values
                                              .first
                                              .imageURL!),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height:
                                      memoPaths[index].values.first.imageURL !=
                                              null
                                          ? 10
                                          : 5,
                                ),
                                if (memoPaths[index].values.first.textMemo !=
                                    null)
                                  Container(
                                      height: memoPaths[index]
                                                  .values
                                                  .first
                                                  .imageURL !=
                                              null
                                          ? mediaQuery.height / 10
                                          : mediaQuery.height / 5,
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 11),
                                      decoration: BoxDecoration(
                                        // borderRadius:
                                        //     BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Text(
                                            memoPaths[index]
                                                .values
                                                .first
                                                .textMemo!,
                                            style: TextStyle(
                                                fontSize: 16, height: 1.2),
                                          ),
                                        ),
                                      )),
                              ],
                            ));
                      },
                      itemCount: memoPaths.length,
                      pagination: SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.all(8),
                          builder: FractionPaginationBuilder(
                              activeFontSize: 22,
                              fontSize: 15,
                              color:
                                  Provider.of<AppTheme>(context, listen: true)
                                          .isDarkMode
                                      ? Colors.white54
                                      : Colors.black)),
                      control: SwiperControl(
                          iconPrevious: Icons.arrow_back_ios_new,
                          disableColor:
                              Provider.of<AppTheme>(context, listen: true)
                                      .isDarkMode
                                  ? Colors.white38
                                  : null,
                          padding: EdgeInsets.all(0)),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      "No Memos Available",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  )));
  }
}

class TraceBottom extends StatelessWidget {
  TraceBottom(
      {Key? key,
      required this.mediaQuery,
      required this.paths,
      required this.pastPaths,
      required this.sensorsHandler,
      required this.playBtnHandler,
      required this.isPause,
      required this.isEnd,
      required this.ttsBtnHandler,
      required this.isStopped,
      required this.directionBtnHandler})
      : super(key: key);

  final Size mediaQuery;
  List<PathItem> paths;
  List<PathItem> pastPaths;
  Function sensorsHandler;
  Function playBtnHandler;
  bool isPause;
  bool isEnd;
  Function ttsBtnHandler;
  bool isStopped;
  Function directionBtnHandler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(
          flex: 3,
        ),
        IconButton(
          splashRadius: 18,
          iconSize: 27,
          onPressed: () {
            isStopped = !isStopped;
            ttsBtnHandler(isStopped);
          },
          icon: Icon(
            isStopped ? Icons.volume_off : Icons.volume_up_rounded,
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        FloatingActionButton(
          heroTag: "playbtn",
          onPressed: () {
            if (!isEnd) {
              isPause = !isPause;
              playBtnHandler(isPause);
            }
          },
          backgroundColor: Theme.of(context).primaryColorDark,
          child: Icon(
            isPause ? Icons.play_arrow : Icons.pause_rounded,
            size: 40,
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        IconButton(
          // splashRadius: mediaQuery.width / 21,
          splashRadius: 18,
          // iconSize: mediaQuery.width / 15,
          iconSize: 27,
          onPressed: () {
            sensorsHandler(true);

            Navigator.of(context).pushNamed(DirectionScreen.routeName,
                arguments: {
                  'data': paths,
                  'pastPaths': pastPaths
                }).then((value) {
              directionBtnHandler();
            });
          },
          icon: const Icon(
            // Icons.volume_up_rounded,
            Icons.fork_right_rounded,
          ),
        ),
        const Spacer(
          flex: 3,
        ),
      ]),
    );
  }
}

class PathDetails extends StatelessWidget {
  PathDetails(
      {Key? key,
      required this.mediaQuery,
      required this.nextPath,
      required this.totalSteps,
      required this.totalTurns,
      required this.ongoingSteps,
      required this.currentTurns})
      : super(key: key);

  final Size mediaQuery;
  PathItem? nextPath;
  final totalSteps;
  final totalTurns;
  var ongoingSteps;
  var currentTurns;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: nextPath != null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        if (nextPath != null)
          Card(
              margin: EdgeInsets.zero,
              color: Theme.of(context).primaryColor,
              elevation: 5,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Row(
                    children: [
                      Row(children: [
                        Text(
                          "Then",
                          style: TextStyle(
                            fontSize: 15 / 720 * mediaQuery.height,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          nextPath?.direction == 0
                              ? MaterialCommunityIcons.arrow_up_bold
                              : nextPath?.direction == 1
                                  ? MaterialCommunityIcons.arrow_right_top_bold
                                  : MaterialCommunityIcons.arrow_left_top_bold,
                          size: mediaQuery.height / 25,
                          color: Colors.white,
                        ),
                      ])
                    ],
                  ))),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    "Steps: ",
                    style: TextStyle(fontSize: 15 / 720 * mediaQuery.height),
                  ),
                  Text(
                    ongoingSteps.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18 / 720 * mediaQuery.height),
                  ),
                  Text(
                    "/$totalSteps",
                    style: TextStyle(fontSize: 15 / 720 * mediaQuery.height),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Turns: ",
                  style: TextStyle(fontSize: 15 / 720 * mediaQuery.height),
                ),
                Text(
                  currentTurns.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18 / 720 * mediaQuery.height),
                ),
                Text(
                  "/$totalTurns",
                  style: TextStyle(fontSize: 15 / 720 * mediaQuery.height),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

class CurrentDirection extends StatelessWidget {
  CurrentDirection(
      {Key? key,
      required this.mediaQuery,
      required this.currentPath,
      required this.nextPath,
      required this.stepsToGo})
      : super(key: key);

  final Size mediaQuery;
  PathItem? currentPath;
  PathItem? nextPath;
  int stepsToGo;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        margin: EdgeInsets.zero,
        color: Theme.of(context).primaryColorDark,
        shape: nextPath != null
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)))
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                color: Colors.white,
                currentPath != null
                    ? currentPath!.direction == 0
                        ? MaterialCommunityIcons.arrow_up_bold
                        : currentPath!.direction == 1
                            ? MaterialCommunityIcons.arrow_right_top_bold
                            : MaterialCommunityIcons.arrow_left_top_bold
                    : Icons.location_on_rounded,
                size: mediaQuery.height / 12,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: mediaQuery.width * 0.5,
                child: Text(
                  currentPath != null
                      ? currentPath!.direction == 0
                          ? currentPath!.steps == 0
                              ? "Head straight"
                              : "Keep walking for $stepsToGo steps"
                          : currentPath!.direction == 1
                              ? "Turn Right"
                              : "Turn Left"
                      : "Reach Destination",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22 / 720 * mediaQuery.height,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ));
  }
}
