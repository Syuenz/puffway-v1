// Programmer name: Chew Chai Syuen
// Program name: Puffway
// Description: An Indoor Vehicle Locator Mobile Application
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:puffway/providers/pathway.dart';
import 'package:puffway/screens/start_trace_screen.dart';
import 'package:puffway/widgets/reversed_path_info_item.dart';
import '../providers/appTheme.dart';
import '../providers/path.dart';

class PathOverviewScreen extends StatelessWidget {
  static const routeName = "/path-overview";

  PathOverviewScreen({super.key});

  int countTotalFootSteps(List<PathItem> pathitems, int start) {
    var total =
        pathitems.sublist(start).fold(0, (sum, element) => sum + element.steps);
    return total;
  }

  int countTotalTurns(List<PathItem> pathitems) {
    var total = 0;
    pathitems.forEach((element) {
      if (element.direction == 1 || element.direction == 2) {
        total += 1;
      }
    });
    return total;
  }

  void mapMemoPaths(List<PathItem> paths, List<Map<int, PathItem>> memoPaths) {
    Map<int, PathItem> memoPath = {};
    int pathInitStep;
    int totalSteps = countTotalFootSteps(paths, 0);

    paths.forEach((e) {
      if (e.imageURL != null || e.textMemo != null) {
        pathInitStep =
            totalSteps - countTotalFootSteps(paths, paths.indexOf(e));
        memoPath[pathInitStep] = e;
        memoPaths.add(memoPath);
        memoPath = {};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final mediaQuery = MediaQuery.of(context).size;
    Pathway data = routeArgs['data'];

    //image autoscroll
    List<Map<int, PathItem>> memoPaths = [];
    mapMemoPaths(data.paths!.reversed.toList(), memoPaths);

    return Scaffold(
      appBar: AppBar(title: Text(data.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (data.description != null)
              Container(
                  height: mediaQuery.height * 0.13,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        data.description!,
                        style: const TextStyle(fontSize: 16, height: 1.2),
                      ),
                    ),
                  )),
            if (data.description != null)
              const SizedBox(
                height: 8,
              ),
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Steps: "),
                Text(
                  countTotalFootSteps(data.paths!, 0).toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text("Turns: "),
                Text(
                  countTotalTurns(data.paths!).toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Provider.of<AppTheme>(context, listen: true)
                              .isDarkMode
                          ? Colors.grey
                          : const Color.fromARGB(255, 255, 186, 229),
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      scrollDirection: Axis.vertical,
                      itemCount: data.paths!.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Card(
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ReversedPathInfoItem(
                            path: data.paths!.reversed.toList()[index],
                            isDisabled: false,
                          ),
                        );
                      }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              heroTag: "startBtn",
              backgroundColor: (countTotalFootSteps(data.paths!, 0) == 0 &&
                      countTotalTurns(data.paths!) == 0)
                  ? Colors.grey
                  : null,
              onPressed: () {
                //open trace back page
                !(countTotalFootSteps(data.paths!, 0) == 0 &&
                        countTotalTurns(data.paths!) == 0)
                    ? Navigator.of(context)
                        .pushNamed(StartTraceScreen.routeName, arguments: {
                        'data': data,
                        'totalSteps': countTotalFootSteps(data.paths!, 0),
                        'totalTurns': countTotalTurns(data.paths!),
                        'memoPaths': memoPaths
                      })
                    : null;
              },
              child: const Icon(
                Foundation.foot,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
