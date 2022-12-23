import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:puffway/widgets/path_info_item.dart';

class DirectionScreen extends StatelessWidget {
  static const routeName = "/directions";

  DirectionScreen({super.key});

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
    '11',
    '12',
    '13',
    '14',
    '15',
    '16'
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Directions')),
      body: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: test.length + 1,
        itemBuilder: (BuildContext ctx, index) {
          // return PathInfoItem();
          if (index == test.length) {
            return Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 8, right: 8, bottom: 15),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.red,
                    size: mediaQuery.height / 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Reach Destination",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 17 / 720 * mediaQuery.height,
                        fontWeight: FontWeight.w500),
                  ),
                ]));
          }
          return PathInfoItem();
        },
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
          );
        },
      ),
    );
  }
}
