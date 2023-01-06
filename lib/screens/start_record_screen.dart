import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../screens/recording_screen.dart';

class StartRecordScreen extends StatelessWidget {
  const StartRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(alignment: Alignment.center, children: <Widget>[
      Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(239, 2, 2, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: Offset(
                    1,
                    2,
                  ))
            ],
          )),
      AvatarGlow(
          endRadius: 90,
          glowColor: const Color.fromARGB(255, 255, 0, 0),
          showTwoGlows: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RecordingScreen.routeName,
                  );
                },
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Ink(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [
                            0.0,
                            0.5,
                            1.0
                          ],
                          colors: [
                            Colors.white,
                            Colors.white,
                            Color.fromARGB(255, 217, 217, 217)
                          ]),
                    ),
                  ),
                  Ink(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color.fromARGB(255, 243, 33, 33),
                          Color.fromARGB(255, 181, 63, 63)
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'REC',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.3,
                        fontSize: 25,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ]),
              ),
            ),
          )),
    ]));
  }
}
