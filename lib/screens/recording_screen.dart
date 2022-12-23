import 'package:flutter/material.dart';
import 'package:puffway/widgets/all_directions_body.dart';
import 'package:puffway/widgets/path_info_item.dart';
import 'package:puffway/widgets/recording_bottom.dart';

class RecordingScreen extends StatelessWidget {
  static const routeName = "/recording";

  RecordingScreen({super.key});
  final List<String> test = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Path Record")),
      // backgroundColor: Colors.grey[200],
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(
                        flex: 3,
                      ),
                      FloatingActionButton(
                        heroTag: "minusbtn",
                        onPressed: () {
                          // minus steps
                        },
                        // backgroundColor: Colors.amber,
                        child: const Icon(Icons.remove),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Text(
                        "15",
                        style: TextStyle(
                            fontSize: 80 / 720 * mediaQuery.size.height,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      FloatingActionButton(
                        heroTag: "plusbtn",
                        onPressed: () {
                          // plus steps
                        },
                        // backgroundColor: Colors.amber,
                        child: const Icon(Icons.add),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                    ]),
              ),
              Text(
                "Current Steps",
                style: TextStyle(fontSize: 16 / 720 * mediaQuery.size.height),
              ),
              const SizedBox(height: 15),
              AllDirectionsBody(
                  directionsList: test,
                  bgColor: Color.fromARGB(255, 255, 186, 229)),
              const SizedBox(height: 20),
              RecordingBottom(),
            ],
          )),
    );
  }
}
