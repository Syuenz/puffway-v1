import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:puffway/providers/pathway.dart';
import 'package:puffway/screens/start_record_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

import '../providers/appTheme.dart';
import '../providers/path.dart';

class PathInfoScreen extends StatefulWidget {
  static const routeName = "/path-info";

  const PathInfoScreen({super.key});

  @override
  State<PathInfoScreen> createState() => _PathInfoScreenState();
}

class _PathInfoScreenState extends State<PathInfoScreen> {
  final _form = GlobalKey<FormState>();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  //formfields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  //uuid
  var uuid = Uuid();
  var folderName;
  var folderPath;

  //firestore
  var db = FirebaseFirestore.instance;

  //list
  late List<PathItem> allPaths;

  @override
  void initState() {
    super.initState();
    _titleFocus.addListener(_onFocusChange);
    _descriptionFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocus.removeListener(_onFocusChange);
    _descriptionFocus.removeListener(_onFocusChange);
    _titleFocus.dispose();
    _descriptionFocus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _saveForm(context) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _form.currentState?.save();
    var deviceId = await PlatformDeviceId.getDeviceId;
    allPaths = Provider.of<PathItems>(this.context, listen: false).allPaths;
    Pathway newPathway;
    bool hasImagePath = false;

    for (var e in allPaths) {
      if (e.imageURL != null) {
        hasImagePath = true;
      }
    }
    //title & desc
    if (_descriptionController.text.toString().trim() != '') {
      if (hasImagePath) {
        createFolder(uuid.v1()).whenComplete(() {
          newPathway = Pathway(
              timestamp: Timestamp.now(),
              title: _titleController.text,
              description: _descriptionController.text,
              imageDocPath: folderPath,
              // imageDocTitle: folderName,
              paths: allPaths);
          uploadToFirestore(deviceId, newPathway, context);
        });
      } else {
        newPathway = Pathway(
            timestamp: Timestamp.now(),
            title: _titleController.text,
            description: _descriptionController.text,
            paths: allPaths);
        uploadToFirestore(deviceId, newPathway, context);
      }
    } else {
      //title only
      if (hasImagePath) {
        createFolder(uuid.v1()).whenComplete(() {
          newPathway = Pathway(
              timestamp: Timestamp.now(),
              title: _titleController.text,
              imageDocPath: folderPath,
              // imageDocTitle: folderName,
              paths: allPaths);

          uploadToFirestore(deviceId, newPathway, context);
        });
      } else {
        newPathway = Pathway(
            timestamp: Timestamp.now(),
            title: _titleController.text,
            paths: allPaths);
        uploadToFirestore(deviceId, newPathway, context);
      }
    }
  }

  void uploadToFirestore(String? deviceId, Pathway newPathway, context) {
    db
        .collection("deviceID")
        .doc(deviceId)
        .collection("pathway")
        .withConverter(
            fromFirestore: Pathway.fromFirestore,
            toFirestore: (Pathway pathwayItem, options) =>
                pathwayItem.ToFirestore())
        .add(newPathway);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Save Successfully'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              Provider.of<PathItems>(this.context, listen: false)
                  .clearAllPath();
              // Navigator.pop(context, "save");

              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    ).then((value) {
      Provider.of<PathItems>(this.context, listen: false).clearAllPath();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  Future<void> createFolder(String uuid) async {
    folderName = uuid;
    final Directory? appDocDir = await getExternalStorageDirectory();
    final path = Directory("${appDocDir!.path}/$folderName");
    folderPath = path.path;
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((path.existsSync())) {
      saveImageToFolder(path.path);
    } else {
      path.createSync(recursive: true);
      saveImageToFolder(
          path.path); //return new created path with uuid as folder
    }
  }

  saveImageToFolder(String path) {
    allPaths.forEach((element) {
      if (element.imageURL != null) {
        File imageOldFile = File(element.imageURL!);
        File imageNewFile = File("$path/${basename(imageOldFile.path)}");
        imageNewFile
            .writeAsBytesSync((File(element.imageURL!)).readAsBytesSync());
        imageOldFile.deleteSync(recursive: false);
        element.imageURL = imageNewFile.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pathway Information')),
        body: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: <Widget>[
                const SizedBox(height: 20),
                TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  focusNode: _titleFocus,
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Pathway Title",
                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                      final Color? color = states.contains(MaterialState.error)
                          ? Theme.of(context).errorColor
                          : _titleFocus.hasFocus
                              ? Theme.of(context).primaryColor
                              : Provider.of<AppTheme>(context).isDarkMode
                                  ? Colors.grey
                                  : null;
                      return TextStyle(color: color);
                    }),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a title.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 1,
                  maxLines: 2,
                  cursorColor: Theme.of(context).primaryColor,
                  focusNode: _descriptionFocus,
                  decoration: InputDecoration(
                    labelText: "Description (optional)",
                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                      final Color? color = states.contains(MaterialState.error)
                          ? Theme.of(context).errorColor
                          : _descriptionFocus.hasFocus
                              ? Theme.of(context).primaryColor
                              : Provider.of<AppTheme>(context).isDarkMode
                                  ? Colors.grey
                                  : null;
                      return TextStyle(color: color);
                    }),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.length < 5 && value.isNotEmpty) {
                      return "At least 5 characters long.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(top: 10, bottom: 10))),
                    onPressed: () {
                      _saveForm(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16),
                    ))
              ],
            )),
      ),
    );
  }
}
