import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puffway/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:puffway/providers/appTheme.dart';
import 'package:puffway/providers/path.dart';

import './screens/bottom_navigation_screen.dart';
import './screens/recording_screen.dart';
import './screens/path_info_screen.dart';
import './screens/path_memo_screen.dart';
import './screens/path_overview_screen.dart';
import './screens/directions_screen.dart';
import './screens/start_trace_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitDown,
//     DeviceOrientation.portraitUp,
//   ]);

//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(ChangeNotifierProvider<AppTheme>(
      create: (_) => AppTheme(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const themeColor = Color.fromARGB(255, 248, 85, 199);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PathItems()),
        ChangeNotifierProvider(create: (context) => AppTheme()),
      ],
      child: Consumer<AppTheme>(
        builder: (context, theme, _) => MaterialApp(
          title: 'Flutter Demo',
          // darkTheme: ThemeData(
          //   scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0),
          //   appBarTheme: const AppBarTheme(color: themeColor),
          //   primaryColor: themeColor,
          //   primaryColorDark: Color.fromARGB(255, 207, 30, 148),
          //   errorColor: Colors.redAccent,
          //   elevatedButtonTheme: ElevatedButtonThemeData(
          //       style: ElevatedButton.styleFrom(
          //     backgroundColor: Color.fromARGB(255, 255, 40, 183),
          //     elevation: 5,
          //   )),
          //   inputDecorationTheme: const InputDecorationTheme(
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(color: themeColor, width: 2),
          //     ),
          //     floatingLabelStyle: TextStyle(
          //       color: themeColor,
          //     ),
          //   ),
          //   colorScheme: ColorScheme.fromSwatch().copyWith(
          //     secondary: Color.fromARGB(255, 195, 0, 130), // Your accent color
          //   ),
          // ),
          // theme: ThemeData(
          //   scaffoldBackgroundColor: Colors.white,
          //   appBarTheme: const AppBarTheme(color: themeColor),
          //   primaryColor: themeColor,
          //   primaryColorDark: Color.fromARGB(255, 207, 30, 148),
          //   errorColor: Colors.redAccent,
          //   elevatedButtonTheme: ElevatedButtonThemeData(
          //       style: ElevatedButton.styleFrom(
          //     backgroundColor: Color.fromARGB(255, 255, 40, 183),
          //     elevation: 5,
          //   )),
          //   inputDecorationTheme: const InputDecorationTheme(
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(color: themeColor, width: 2),
          //     ),
          //     floatingLabelStyle: TextStyle(
          //       color: themeColor,
          //     ),
          //   ),
          //   colorScheme: ColorScheme.fromSwatch().copyWith(
          //     secondary: Color.fromARGB(255, 195, 0, 130), // Your accent color
          //   ),
          // ),
          theme: theme.getTheme(),

          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          initialRoute: '/',
          routes: {
            '/': (ctx) => BottomNavigationScreen(),
            RecordingScreen.routeName: (ctx) => RecordingScreen(),
            PathInfoScreen.routeName: (ctx) => PathInfoScreen(),
            PathMemoScreen.routeName: (ctx) => PathMemoScreen(),
            PathOverviewScreen.routeName: (ctx) => PathOverviewScreen(),
            DirectionScreen.routeName: (ctx) => DirectionScreen(),
            StartTraceScreen.routeName: (ctx) => StartTraceScreen(),
          },
        ),
      ),
    );
  }
}
