import 'package:flutter/material.dart';
import 'package:puffway/screens/path_memo_screen.dart';

class RecordingBottom extends StatelessWidget {
  const RecordingBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          heroTag: "cancelbtn",
          onPressed: () {
            //cancel, delete temp files
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.clear),
        ),
        FloatingActionButton(
          heroTag: "memobtn",
          onPressed: () {
            Navigator.of(context).pushNamed(
              PathMemoScreen.routeName,
            );
          },
          backgroundColor: Colors.amber,
          child: const Icon(Icons.note_add_rounded),
        ),
        FloatingActionButton(
          heroTag: "savebtn",
          onPressed: () {
            //save, delete temp files, create path id folder, save images to external
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.check),
        ),
      ],
    );
  }
}
