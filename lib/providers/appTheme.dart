import 'package:flutter/material.dart';
import '../utils/StorageManager.dart';

class AppTheme extends ChangeNotifier {
  bool isDarkMode = false;
  static const themeColor = Color.fromARGB(255, 248, 85, 199);

  final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0),
    // brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      color: Color.fromARGB(255, 57, 57, 57),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),

    cardTheme: CardTheme(
      color: Color.fromARGB(255, 41, 41, 41),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(color: Colors.white),
      headline2: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
      bodyText1: TextStyle(color: Colors.white),
      subtitle2: TextStyle(color: Colors.white),
      caption: TextStyle(color: Colors.white),
    ).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    dialogTheme: DialogTheme(backgroundColor: Color(0xFF151515)),

    primaryColor: themeColor,
    primaryColorDark: Color.fromARGB(255, 207, 30, 148),
    errorColor: Colors.redAccent,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 255, 40, 183),
      elevation: 5,
    )),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      labelStyle: TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor, width: 2),
      ),
      floatingLabelStyle: TextStyle(
        color: themeColor,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Color.fromARGB(255, 195, 0, 130), // Your accent color
    ),
  );

  final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[200],
    appBarTheme: const AppBarTheme(color: themeColor),
    primaryColor: themeColor,
    primaryColorDark: Color.fromARGB(255, 207, 30, 148),
    errorColor: Colors.redAccent,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 255, 40, 183),
      elevation: 5,
    )),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor, width: 2),
      ),
      floatingLabelStyle: TextStyle(
        color: themeColor,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Color.fromARGB(255, 195, 0, 130), // Your accent color
    ),
  );

  late ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  AppTheme() {
    _themeData = lightTheme;
    isDarkMode = false;
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        isDarkMode = false;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
        isDarkMode = true;
      }
      notifyListeners();
    });
  }

  void updateTheme(bool isDarkMode) async {
    this.isDarkMode = isDarkMode;
    if (isDarkMode) {
      isDarkMode = true;
      _themeData = darkTheme;
      StorageManager.saveData('themeMode', 'dark');
      notifyListeners();
    } else {
      isDarkMode = false;
      _themeData = lightTheme;
      StorageManager.saveData('themeMode', 'light');
      notifyListeners();
    }
    notifyListeners();
  }

  // void setDarkMode() async {
  //   isDarkMode = true;
  //   _themeData = darkTheme;
  //   StorageManager.saveData('themeMode', 'dark');
  //   notifyListeners();
  // }

  // void setLightMode() async {
  //   isDarkMode = false;
  //   _themeData = lightTheme;
  //   StorageManager.saveData('themeMode', 'light');
  //   notifyListeners();
  // }
}
