import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';
import 'package:puffway/screens/recording_screen.dart';
import '../widgets/customized_alert_dialog.dart';
import '../providers/path.dart';
import '../widgets/image_dialog.dart';

class PathMemoScreen extends StatefulWidget {
  static const routeName = "/path-memo";

  const PathMemoScreen({super.key});

  @override
  State<PathMemoScreen> createState() => _PathMemoScreenState();
}

class _PathMemoScreenState extends State<PathMemoScreen> {
  final FocusNode _descriptionFocus = FocusNode();
  final _descriptionController = TextEditingController();
  var _storedImage;
  var _isHorizontal;

  var steps;
  late Function memoSavedHandler;

  @override
  void initState() {
    super.initState();
    _descriptionFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionFocus.removeListener(_onFocusChange);
    _descriptionFocus.dispose();
    _descriptionController.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  Future<void> _saveForm() async {
    if (_storedImage != null &&
        _descriptionController.text.toString().trim() != '') {
      Provider.of<PathItems>(context, listen: false).addPath(PathItem(
          direction: 0,
          steps: steps,
          textMemo: _descriptionController.text,
          imageURL: _storedImage,
          isHorizontal: _isHorizontal));
      memoSavedHandler();
      Navigator.of(context).pop();
    } else if (_storedImage != null) {
      Provider.of<PathItems>(context, listen: false).addPath(PathItem(
          direction: 0,
          steps: steps,
          imageURL: _storedImage,
          isHorizontal: _isHorizontal));
      memoSavedHandler();
      Navigator.of(context).pop();
    } else if (_descriptionController.text.toString().trim() != '') {
      Provider.of<PathItems>(context, listen: false).addPath(PathItem(
          direction: 0, steps: steps, textMemo: _descriptionController.text));
      memoSavedHandler();
      Navigator.of(context).pop();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomizedAlertDialog(
                content: "No memo provided. Please provide your memo.",
                yes: "Okay",
                no: "Cancel",
                yesOnPressed: () {
                  Navigator.of(context).pop();
                },
                noOnPressed: () {
                  Navigator.of(context).pop();
                },
              ));
    }
  }

  //camera
  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600, //resolution
    );
    if (imageFile == null) {
      return;
    }
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    print(appDir);
    print(fileName);

    File savedImage = await File(imageFile.path)
        .copy('${appDir.path}/$fileName'); //add path id in front of file name
    // widget.onSelectImage(savedImage);

    final decodedImage =
        await decodeImageFromList(savedImage.readAsBytesSync());
    _isHorizontal = decodedImage.width > decodedImage.height;

    setState(() {
      _storedImage = savedImage;
      print(_storedImage);
    });
  }

  Future<bool> showDiscardDialog() async {
    return await showDialog(
            context: context,
            builder: (BuildContext context) => CustomizedAlertDialog(
                  content: "Discard Memo Changes?",
                  yes: "Confirm",
                  no: "Cancel",
                  yesOnPressed: () {
                    if (_storedImage != null) {
                      (_storedImage as File).delete();
                      _storedImage = null;
                    }
                    Navigator.popUntil(context,
                        ModalRoute.withName(RecordingScreen.routeName));
                  },
                  noOnPressed: () {
                    Navigator.pop(context);
                  },
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    steps = routeArgs['steps'];
    memoSavedHandler = routeArgs['memoSavedHandler'];
    final mediaQuery = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: showDiscardDialog,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Path Memo')),
          body: Form(
              child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: <Widget>[
              SizedBox(height: mediaQuery.height * 0.1),
              Center(
                child: Stack(children: [
                  GestureDetector(
                    onTap: () async {
                      _storedImage != null
                          ? await showDialog(
                              context: context,
                              builder: (_) => ImageDialog(
                                    imageURL: _storedImage,
                                    isHorizontal: _isHorizontal,
                                  ))
                          : _takePicture();
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 8, right: 8),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        height: _storedImage == null
                            ? mediaQuery.height * 0.2
                            : (_isHorizontal
                                ? mediaQuery.height / 4.5
                                : mediaQuery.height / 3.54),
                        width: _storedImage == null
                            ? mediaQuery.height * 0.2
                            : (_isHorizontal
                                ? mediaQuery.width * 0.64
                                : mediaQuery.width * 0.46),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: _storedImage != null
                            ? Image.file(
                                _storedImage,
                                fit: BoxFit.fill,
                              )
                            : Center(
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: mediaQuery.height * 0.05,
                                  color: Color.fromARGB(255, 131, 131, 131),
                                ),
                              )),
                  ),
                  if (_storedImage != null)
                    Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomizedAlertDialog(
                                      // title: "",
                                      content: "Delete Image?",
                                      yes: "Delete",
                                      no: "Cancel",
                                      yesOnPressed: () {
                                        setState(() {
                                          (_storedImage as File).delete();
                                          _storedImage = null;
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      noOnPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ));
                          },
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ))
                ]),
              ),
              SizedBox(height: mediaQuery.height * 0.01),
              const Center(
                  child: Text("Photo",
                      style: TextStyle(
                          color: Color.fromARGB(255, 131, 131, 131)))),
              SizedBox(height: mediaQuery.height * 0.05),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                cursorColor: Theme.of(context).primaryColor,
                focusNode: _descriptionFocus,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                      (Set<MaterialState> states) {
                    final Color? color = states.contains(MaterialState.error)
                        ? Theme.of(context).errorColor
                        : _descriptionFocus.hasFocus
                            ? Theme.of(context).primaryColor
                            : null;
                    return TextStyle(color: color);
                  }),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: mediaQuery.height * 0.05),
              ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.only(top: 10, bottom: 10))),
                  onPressed: () {
                    _saveForm();
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
