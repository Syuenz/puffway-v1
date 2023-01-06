import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/appTheme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var dark = Provider.of<AppTheme>(context).isDarkMode;
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                  height: mediaQuery.height * 0.1,
                  child: Image.asset("assets/images/puffway.png")),
              const SizedBox(
                height: 8,
              ),
              const Text("Puffway"),
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
                          style: const TextStyle(fontSize: 18),
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
