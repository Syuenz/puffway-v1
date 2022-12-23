import 'package:flutter/material.dart';
import 'package:puffway/screens/path_overview_screen.dart';
import '../widgets/history_item.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        itemCount: test.length,
        itemBuilder: (BuildContext ctx, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
            child: ListTile(
              title: Wrap(children: [
                Text(
                  'Title' + test[index],
                  overflow: TextOverflow.fade,
                ),
              ]),
              subtitle: const Text('timestamp'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.directions_walk,
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              onTap: () {
                Navigator.of(context).pushNamed(
                  PathOverviewScreen.routeName,
                  arguments: {'title': 'Title' + test[index]},
                );
                // Navigator.of(context).pushNamed(
                //   DirectionScreen.routeName,
                // );
              },
            ),
          );
        },
      ),
    );
  }
}
