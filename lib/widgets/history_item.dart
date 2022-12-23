import 'package:flutter/material.dart';
import 'package:puffway/screens/directions_screen.dart';
import '../screens/path_overview_screen.dart';

class HistoryItem extends StatelessWidget {
  final String historyInfo;

  HistoryItem(this.historyInfo);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
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
            'Title' + historyInfo,
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
            arguments: {'title': 'Title$historyInfo'},
          );
          // Navigator.of(context).pushNamed(
          //   DirectionScreen.routeName,
          // );
        },
      ),
    );
  }
}
