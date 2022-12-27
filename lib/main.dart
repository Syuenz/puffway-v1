import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puffway/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:puffway/providers/path.dart';
import 'package:puffway/providers/pathway.dart';

import './screens/bottom_navigation_screen.dart';
import './screens/recording_screen.dart';
import './screens/path_info_screen.dart';
import './screens/path_memo_screen.dart';
import './screens/path_overview_screen.dart';
import './screens/directions_screen.dart';
import './screens/start_trace_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
        ChangeNotifierProvider(create: (context) => PathwayItem())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
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
            // focusColor: themeColor,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: themeColor, width: 2),
            ),
            // enabledBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(color: themeColor),
            // ),

            floatingLabelStyle: TextStyle(
              color: themeColor,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Color.fromARGB(255, 195, 0, 130), // Your accent color
          ),

          // fontFamily: "Helvetica",
        ),
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
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter(int incremental) {
//     setState(() {
//       _counter = _counter + incremental;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Puffway"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (() => _incrementCounter(1)),
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
