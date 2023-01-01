import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:puffway/widgets/path_info_item.dart';
import 'package:puffway/widgets/reversed_path_info_item.dart';

import '../providers/path.dart';
import '../providers/pathway.dart';

class DirectionScreen extends StatelessWidget {
  static const routeName = "/directions";

  DirectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    // final paths = Provider.of<PathItems>(context).allPaths;
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<PathItem> data = routeArgs['data'];
    List<PathItem> pastPaths = routeArgs['pastPaths'];

    return Scaffold(
      appBar: AppBar(title: const Text('Directions')),
      body: ListView.separated(
        // padding: const EdgeInsets.only(top: 5),
        scrollDirection: Axis.vertical,
        itemCount: data.length + 1,
        itemBuilder: (BuildContext ctx, index) {
          if (index == data.length) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 15,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Colors.red,
                          size: mediaQuery.height / 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Reach Destination",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 17 / 720 * mediaQuery.height,
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                )
              ],
            );
          } else {
            var isDisabled = false;
            pastPaths.forEach(((element) {
              if (element.timestamp ==
                  data.reversed.toList()[index].timestamp) {
                isDisabled = true;
              }
            }));
            return ReversedPathInfoItem(
              path: data.reversed.toList()[index],
              isDisabled: isDisabled,
            );
          }
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            thickness: 1,
            // color: Colors.grey,
          );
        },
      ),
    );
  }
}
