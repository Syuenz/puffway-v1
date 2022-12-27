import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../widgets/image_dialog.dart';

class PathInfoItem extends StatelessWidget {
  const PathInfoItem({super.key, required this.path});

  final Map<String, dynamic> path;

  final imageURL =
      "https://images.unsplash.com/photo-1609645778471-613f21fcf3df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmVydGljYWwlMjB3YWxscGFwZXJ8ZW58MHx8MHx8&w=1000&q=80";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // return Card(
    //   elevation: 6,
    //   margin: const EdgeInsets.symmetric(
    //     vertical: 8,
    //     horizontal: 20,
    //   ),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    // child: ListTile(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    //   contentPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
    //   title: Padding(
    //     padding: const EdgeInsets.only(top: 10),
    //     child: Text(
    //       "Turn Left",
    //       style: TextStyle(
    //           fontSize: 17 / 720 * mediaQuery.size.height,
    //           fontWeight: FontWeight.w500),
    //     ),
    //   ),
    //   leading: Icon(
    //     MaterialCommunityIcons.arrow_left_top_bold,
    //     // Icons.turn_left_rounded,
    //     size: mediaQuery.size.height / 19,
    //   ),
    //   subtitle: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       // Container(
    //       //   margin: EdgeInsets.symmetric(vertical: 10),
    //       //   // width: mediaQuery.size.width * 0.5, //landscape
    //       //   height: mediaQuery.size.height / 4, //potrait
    //       //   // decoration: BoxDecoration(
    //       //   //   border: Border.all(
    //       //   //     color: Colors.red,
    //       //   //     width: 1,
    //       //   //   ),
    //       //   // ),
    //       //   child: AspectRatio(
    //       //     aspectRatio: 3 / 4,
    //       //     child: Image.network(
    //       //       imageURL,
    //       //       fit: BoxFit.fill,
    //       //     ),
    //       //   ),
    //       // ),

    //       Container(
    //         margin: EdgeInsets.symmetric(vertical: 10),
    //         // width: mediaQuery.size.width * 0.5, //landscape
    //         height: mediaQuery.size.height / 4, //potrait
    //         // decoration: BoxDecoration(
    //         //   border: Border.all(
    //         //     color: Colors.red,
    //         //     width: 1,
    //         //   ),
    //         // ),
    //         child: AspectRatio(
    //           aspectRatio: 3 / 4,
    //           child: Stack(children: [
    //             AspectRatio(
    //               aspectRatio: 3 / 4,
    //               child: Image.network(
    //                 imageURL,
    //                 fit: BoxFit.fill,
    //               ),
    //             ),
    //             Positioned.fill(
    //               child: Material(
    //                 color: Colors.transparent,
    //                 child: InkWell(
    //                   onTap: () async {
    //                     // print('Sure');
    //                     await showDialog(
    //                         context: context,
    //                         builder: (_) => ImageDialog(imageURL: imageURL));
    //                   },
    //                 ),
    //               ),
    //             )
    //           ]),
    //         ),
    //       ),

    //       Text(
    //         'A tree is beside the road',
    //         style: TextStyle(fontSize: 14 / 720 * mediaQuery.size.height),
    //       ),
    //     ],
    //   ),
    // ),

    return Padding(
      padding: path['direction'] == 0 &&
              (path.containsKey("textMemo") || path.containsKey("imageURL"))
          ? const EdgeInsets.only(top: 5, left: 8, right: 8)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              path['direction'] == 0
                  ? MaterialCommunityIcons.arrow_up_bold
                  : path['direction'] == 1
                      ? MaterialCommunityIcons.arrow_left_top_bold
                      : MaterialCommunityIcons.arrow_right_top_bold,
              size: path['direction'] == 0
                  ? mediaQuery.size.height / 19
                  : mediaQuery.size.height / 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              path['direction'] == 0
                  ? path['steps'] == 0
                      ? "Head straight"
                      : "Keep walking for ${path['steps']} steps"
                  : path['direction'] == 1
                      ? "Turn Left"
                      : "Turn Right",
              style: TextStyle(
                  fontSize: 17 / 720 * mediaQuery.size.height,
                  fontWeight: FontWeight.w500),
            ),
          ]),
          if (path.containsKey("imageURL"))
            Container(
              margin: EdgeInsets.only(bottom: 8),
              // width: mediaQuery.size.width * 0.41, //landscape * 0.5
              // height: mediaQuery.size.height / 4, //potrait
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.red,
              //     width: 1,
              //   ),
              // ),

              child: Stack(children: [
                SizedBox(
                  width: path['isHorizontal'] == true
                      ? mediaQuery.size.width * 0.55
                      : null,
                  height: path['isHorizontal'] == true
                      ? null
                      : mediaQuery.size.height / 4,
                  child: Image.file(
                    path['imageURL'],
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => ImageDialog(
                                  imageURL: path['imageURL'],
                                  isHorizontal: path['isHorizontal'],
                                ));
                      },
                    ),
                  ),
                )
              ]),

              // child: AspectRatio(
              //   aspectRatio: 3 / 4,
              //   child: Stack(children: [
              //     AspectRatio(
              //       aspectRatio: 3 / 4,
              //       child: Image.network(
              //         imageURL,
              //         fit: BoxFit.fill,
              //       ),
              //     ),
              //     Positioned.fill(
              //       child: Material(
              //         color: Colors.transparent,
              //         child: InkWell(
              //           onTap: () async {
              //             // print('Sure');
              //             // await showDialog(
              //             //     context: context,
              //             //     builder: (_) => ImageDialog(imageURL: imageURL));
              //           },
              //         ),
              //       ),
              //     )
              //   ]),
              // ),

              // child: AspectRatio(
              //   aspectRatio: 3 / 4,
              //   child: Stack(children: [
              //     AspectRatio(
              //       aspectRatio: 3 / 4,
              //       child: Image.file(
              //         path['imageURL'],
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //     Positioned.fill(
              //       child: Material(
              //         color: Colors.transparent,
              //         child: InkWell(
              //           onTap: () async {
              //             await showDialog(
              //                 context: context,
              //                 builder: (_) => ImageDialog(
              //                       imageURL: path['imageURL'],
              //                       isHorizontal: path['isHorizontal'],
              //                     ));
              //           },
              //         ),
              //       ),
              //     )
              //   ]),
              // ),
            ),
          if (path.containsKey("textMemo"))
            Text(
              path['textMemo'],
              style: TextStyle(fontSize: 14 / 720 * mediaQuery.size.height),
            ),
          if (path['direction'] == 0 &&
              (path.containsKey("textMemo") || path.containsKey("imageURL")))
            const SizedBox(
              height: 10,
            )
        ],
      ),
    );
    // );
  }
}
