import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/appTheme.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var dark = Provider.of<AppTheme>(context).isDarkMode;
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 48,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  radius: 45,
                  child: Image.asset("assets/images/puffway.png"),
                  // child: IconButton(
                  //     onPressed: () {}, iconSize: 60, icon: Icon(Icons.person)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text("Version 2.0"),
              const SizedBox(
                height: 15,
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(dark ? Icons.dark_mode : Icons.light_mode),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          dark ? "Dark Mode" : "Light Mode",
                          style: TextStyle(fontSize: 18),
                        ),
                      ]),
                      Switch(
                        value: dark,
                        activeColor: Theme.of(context).primaryColorDark,
                        onChanged: (bool value) {
                          setState(() {
                            Provider.of<AppTheme>(context, listen: false)
                                .updateTheme(value);
                          });
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
