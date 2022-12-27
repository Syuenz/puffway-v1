import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:puffway/providers/pathway.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

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

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _form.currentState?.save();
    if (_descriptionController.text.toString().trim() != '') {
      createFolder(uuid.v1());
      Provider.of<PathwayItem>(this.context, listen: false).addPathwayTitleDesc(
          _titleController.text,
          _descriptionController.text,
          Provider.of<PathItems>(this.context, listen: false).allPaths);
    } else {
      createFolder(uuid.v1());
      Provider.of<PathwayItem>(this.context, listen: false).addPathwayTitle(
          _titleController.text,
          Provider.of<PathItems>(this.context, listen: false).allPaths);
    }
  }

  Future<void> createFolder(String uuid) async {
    final folderName = uuid;
    final Directory? appDocDir = await getExternalStorageDirectory();
    final path = Directory("${appDocDir!.path}/$folderName");
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

  Future<void> saveImageToFolder(String path) async {
    List<Map<String, dynamic>> allPaths =
        Provider.of<PathItems>(this.context, listen: false).allPaths;
    allPaths.forEach((element) async {
      if (element.containsKey('imageURL')) {
        File imageOldFile = element['imageURL'];
        File imageNewFile = await File("$path/${basename(imageOldFile.path)}")
            .writeAsBytes((element['imageURL'] as File).readAsBytesSync());
        imageOldFile.deleteSync(recursive: false);
        element.update('imageURL', (value) => imageNewFile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Path Information')),
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
                    labelText: "Path Title",

                    // floatingLabelStyle: TextStyle(
                    //     color: _titleFocus.hasFocus
                    //         ? Theme.of(context).primaryColor
                    //         : null)

                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                        (Set<MaterialState> states) {
                      final Color? color = states.contains(MaterialState.error)
                          ? Theme.of(context).errorColor
                          : _titleFocus.hasFocus
                              ? Theme.of(context).primaryColor
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

                    // floatingLabelStyle: TextStyle(
                    //     color: _descriptionFocus.hasFocus
                    //         ? Theme.of(context).primaryColor
                    //         : null),
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
                  validator: (value) {
                    // if (value!.isEmpty) {
                    //   return "Please enter a description.";
                    // }
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
                    onPressed: () => _saveForm(),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16),
                    ))
                // Center(
                //   child: ElevatedButton(
                //       style: ButtonStyle(
                //           padding: MaterialStateProperty.all(EdgeInsets.only(
                //               top: 10, bottom: 10, left: 50, right: 50))),
                //       onPressed: () {},
                //       child: const Text(
                //         "Save",
                //         style: TextStyle(fontSize: 16),
                //       )),
                // )
              ],
            )),
      ),
    );
  }
}
