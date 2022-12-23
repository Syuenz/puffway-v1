import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../widgets/image_dialog.dart';

class PathInfoItem extends StatelessWidget {
  const PathInfoItem({super.key});

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
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              MaterialCommunityIcons.arrow_left_top_bold,
              // Icons.turn_left_rounded,
              size: mediaQuery.size.height / 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Turn Left",
              style: TextStyle(
                  fontSize: 17 / 720 * mediaQuery.size.height,
                  fontWeight: FontWeight.w500),
            ),
          ]),
          Container(
            margin: EdgeInsets.only(bottom: 8),
            // width: mediaQuery.size.width * 0.5, //landscape
            height: mediaQuery.size.height / 4, //potrait
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.red,
            //     width: 1,
            //   ),
            // ),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Image.network(
                    imageURL,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        // print('Sure');
                        // await showDialog(
                        //     context: context,
                        //     builder: (_) => ImageDialog(imageURL: imageURL));
                      },
                    ),
                  ),
                )
              ]),
            ),
          ),
          Text(
            'A tree is beside the road',
            style: TextStyle(fontSize: 14 / 720 * mediaQuery.size.height),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
    // );
  }
}
