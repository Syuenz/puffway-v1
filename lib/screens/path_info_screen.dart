import 'package:flutter/material.dart';

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

    //save path info
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
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return "Please enter a description.";
                  //   }
                  //   if (value.length < 5) {
                  //     return "At least 5 characters long.";
                  //   }
                  //   return null;
                  // },
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
