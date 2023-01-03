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
          theme: theme.getTheme(),
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
