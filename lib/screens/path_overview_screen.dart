import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:puffway/screens/start_trace_screen.dart';
import '../widgets/all_directions_body.dart';

class PathOverviewScreen extends StatelessWidget {
  static const routeName = "/path-overview";

  PathOverviewScreen({super.key});

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

  //call firebase to fetch the pathway based on path id

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text(routeArgs['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
                height: mediaQuery.height * 0.13,
                padding: EdgeInsets.symmetric(horizontal: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "1 Description that is too long in text format(Here Data is coming from API) jdlksaf j klkjjflkdsjfkddfdfsdfds " +
                          "2 Description that is too long in text format(Here Data is coming from API) d fsdfdsfsdfd dfdsfdsf sdfdsfsd d " +
                          "3 Description that is too long in text format(Here Data is coming from API)  adfsfdsfdfsdfdsf   dsf dfd fds fs" +
                          "4 Description that is too long in text format(Here Data is coming from API) dsaf dsafdfdfsd dfdsfsda fdas dsad" +
                          "5 Description that is too long in text format(Here Data is coming from API) dsfdsfd fdsfds fds fdsf dsfds fds " +
                          "6 Description that is too long in text format(Here Data is coming from API) asdfsdfdsf fsdf sdfsdfdsf sd dfdsf" +
                          "7 Description that is too long in text format(Here Data is coming from API) df dsfdsfdsfdsfds df dsfds fds fsd" +
                          "8 Description that is too long in text format(Here Data is coming from API)" +
                          "9 Description that is too long in text format(Here Data is coming from API)" +
                          "10 Description that is too long in text format(Here Data is coming from API)",
                      style: TextStyle(fontSize: 16, height: 1.2),
                    ),
                  ),
                )),
            SizedBox(
              height: 8,
            ),
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Steps: "),
                Text(
                  "100",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(
                  width: 6,
                ),
                Text("Turns: "),
                Text(
                  "3",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            AllDirectionsBody(
              directionsList: test,
              bgColor: Color.fromARGB(255, 255, 186, 229),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              heroTag: "startBtm",
              onPressed: () {
                //open trace back page
                Navigator.of(context).pushNamed(
                  StartTraceScreen.routeName,
                );
              },
              child: const Icon(
                Foundation.foot,
                // Icons.explore_rounded,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
