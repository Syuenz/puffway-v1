import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puffway/providers/path.dart';
import '../widgets/path_info_item.dart';

class AllDirectionsBody extends StatelessWidget {
  const AllDirectionsBody(
      {super.key, required this.directionsList, required this.bgColor});

  final List<PathItem> directionsList;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    // final paths = Provider.of<PathItems>(context).allPaths;

    //change to only listview

    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(20)),
          child: Consumer<PathItems>(
            builder: (ctx, path, _) => ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                scrollDirection: Axis.vertical,
                itemCount: directionsList.length,
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
                    child: PathInfoItem(
                      path: directionsList[index],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
