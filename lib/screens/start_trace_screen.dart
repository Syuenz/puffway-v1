import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:card_swiper/card_swiper.dart';

class StartTraceScreen extends StatefulWidget {
  static const routeName = "/start-trace";

  const StartTraceScreen({super.key});

  @override
  State<StartTraceScreen> createState() => _StartTraceScreenState();
}

class _StartTraceScreenState extends State<StartTraceScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(title: const Text('Path Title')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LinearPercentIndicator(
                padding: EdgeInsets.all(0),
                animation: true,
                lineHeight: 11,
                animationDuration: 2000,
                percent: 0.9,
                center: Text(
                  "90.0%",
                  style: TextStyle(
                      fontSize: 9 / 720 * mediaQuery.height,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                barRadius: Radius.circular(16),
                // progressColor: Theme.of(context).primaryColorDark,
                progressColor: Color.fromARGB(255, 43, 175, 40),
              ),
              SizedBox(
                height: 10,
              ),
              CurrentDirection(mediaQuery: mediaQuery),
              PathDetails(mediaQuery: mediaQuery),
              TraceBody(mediaQuery: mediaQuery),
              TraceBottom(mediaQuery: mediaQuery)
            ],
          ),
        ));
  }
}

class TraceBody extends StatelessWidget {
  const TraceBody({
    Key? key,
    required this.mediaQuery,
  }) : super(key: key);

  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            elevation: 6,
            margin: const EdgeInsets.only(top: 20, bottom: 10
                // horizontal: 20,
                ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: Swiper(
                outer: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "30%",
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            // height: 150,
                            // width: 150,
                            // height: mediaQuery.height / 4,
                            // width: mediaQuery.width / 3,
                            child: Image.network(
                              "https://images.pexels.com/photos/775201/pexels-photo-775201.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: mediaQuery.height / 10,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                // borderRadius:
                                //     BorderRadius.circular(15),
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
                        ],
                      ));
                },
                itemCount: 3,
                pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.all(8),
                    builder: FractionPaginationBuilder(
                        activeFontSize: 22, fontSize: 15, color: Colors.black)),
                // pagination: SwiperCustomPagination(builder:
                //     (BuildContext context,
                //         SwiperPluginConfig config) {
                //   return Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Container(
                //       margin: EdgeInsets.all(10),
                //       child: Row(
                //         // key: key,
                //         // textBaseline: TextBaseline.alphabetic,
                //         // crossAxisAlignment: CrossAxisAlignment.baseline,
                //         mainAxisSize: MainAxisSize.min,

                //         children: <Widget>[
                //           Text(
                //             '${config.activeIndex + 1}',
                //             style: TextStyle(
                //                 color: Theme.of(context).primaryColor,
                //                 fontSize: 22,
                //                 fontWeight: FontWeight.w600),
                //           ),
                //           Text(
                //             ' / ${config.itemCount}',
                //             style: TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w600),
                //           )
                //         ],
                //       ),
                //     ),
                //   );
                //   ;
                // }),
                control: SwiperControl(),
              ),
            )));
  }
}

class TraceBottom extends StatelessWidget {
  const TraceBottom({
    Key? key,
    required this.mediaQuery,
  }) : super(key: key);

  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 2,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Spacer(
                flex: 2,
              ),
              IconButton(
                splashRadius: 18,
                iconSize: 27,
                onPressed: () {},
                icon: Icon(
                  Icons.restart_alt_rounded,
                ),
              ),
              Spacer(
                flex: 1,
              ),
              FloatingActionButton(
                heroTag: "playbtn",
                onPressed: () {},
                backgroundColor: Theme.of(context).primaryColorDark,
                child: const Icon(
                  Icons.pause_rounded,
                  size: 40,
                ),
              ),
              // ClipOval(
              //   child: Material(
              //     child: InkWell(
              //       onTap: () {},
              //       child: Center(
              //         child: Ink(
              //           decoration: ShapeDecoration(
              //             color: Theme.of(context).primaryColorDark,
              //             shape: CircleBorder(),
              //           ),
              //           child: IconButton(
              //             splashRadius: mediaQuery.width / 11,
              //             onPressed: () {},
              //             iconSize: mediaQuery.width / 8,
              //             icon: Icon(
              //               Icons.pause_rounded,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Spacer(
                flex: 1,
              ),
              IconButton(
                // splashRadius: mediaQuery.width / 21,
                splashRadius: 18,
                // iconSize: mediaQuery.width / 15,
                iconSize: 27,
                onPressed: () {},
                icon: Icon(
                  Icons.volume_up_rounded,
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ]),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: ClipOval(
                child: Material(
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Icon(
                        size: 25,
                        Icons.fork_right_rounded,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PathDetails extends StatelessWidget {
  const PathDetails({
    Key? key,
    required this.mediaQuery,
  }) : super(key: key);

  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
            margin: EdgeInsets.zero,
            color: Theme.of(context).primaryColor,
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                child: Row(
                  children: [
                    Row(children: [
                      Text(
                        "Then",
                        style: TextStyle(
                          fontSize: 15 / 720 * mediaQuery.height,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        // MaterialCommunityIcons.arrow_up_bold,
                        MaterialCommunityIcons.arrow_left_top_bold,
                        size: mediaQuery.height / 25,
                        color: Colors.white,
                      ),
                    ])
                  ],
                ))),
        Container(
          child: Row(
            children: [
              Container(
                child: Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      "Steps: ",
                      style: TextStyle(fontSize: 15 / 720 * mediaQuery.height),
                    ),
                    Text(
                      "10",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18 / 720 * mediaQuery.height),
                    ),
                    Text(
                      "/80",
                      style: TextStyle(fontSize: 15 / 720 * mediaQuery.height),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                child: Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Turns: ",
                      style: TextStyle(fontSize: 15 / 720 * mediaQuery.height),
                    ),
                    Text(
                      "2",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18 / 720 * mediaQuery.height),
                    ),
                    Text(
                      "/3",
                      style: TextStyle(fontSize: 15 / 720 * mediaQuery.height),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class CurrentDirection extends StatelessWidget {
  const CurrentDirection({
    Key? key,
    required this.mediaQuery,
  }) : super(key: key);

  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        margin: EdgeInsets.zero,
        color: Theme.of(context).primaryColorDark,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                color: Colors.white,
                MaterialCommunityIcons.arrow_up_bold,
                // MaterialCommunityIcons.arrow_left_top_bold,
                size: mediaQuery.height / 12,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: mediaQuery.width * 0.5,
                child: Text(
                  "Keep walking for 15 steps",
                  // "Turn Left",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22 / 720 * mediaQuery.height,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ));
  }
}
