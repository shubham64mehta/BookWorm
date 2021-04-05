import 'dart:ui';

import 'package:bookworm/Route/route.dart';
import 'package:bookworm/Screens/favouritesummary.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';

class Favourite1 extends StatefulWidget {
  final int hero;
  final String image;
  final String book;
  final String author;
  final String summary;
  final String unique;
  const Favourite1(
      {Key key,
      this.hero,
      this.image,
      this.book,
      this.author,
      this.summary,
      this.unique})
      : super(key: key);

  @override
  _Favourite1State createState() => _Favourite1State();
}

class _Favourite1State extends State<Favourite1> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.hero,
      child: Scaffold(
        backgroundColor: HexColor('#232531'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          color: Colors.grey[600].withOpacity(0.3),
                        ),
                      ),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(widget.image))),
                    ),
                    Positioned(
                      left: 30,
                      bottom: 0.2,
                      child: DelayedDisplay(
                        delay: Duration(seconds: 1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                ScaleRoute(
                                    exitPage: Favourite1(),
                                    enterPage: Summary1(
                                      summary: widget.summary,
                                    )));
                          },
                          child: Image.network(
                            widget.image,
                            height: 200,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 12,
                        bottom: 250,
                        child: IconButton(
                            icon: Icon(Icons.arrow_back,
                                size: 28, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            })),
                    Positioned(
                      left: 170,
                      bottom: 80,
                      child: DelayedDisplay(
                        delay: Duration(seconds: 2),
                        // slidingCurve: Curves.elasticInOut,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.book,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 23),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "By " + widget.author,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[100],
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              DelayedDisplay(
                delay: Duration(seconds: 3),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Details",
                      style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DelayedDisplay(
                  slidingCurve: Curves.fastLinearToSlowEaseIn,
                  delay: Duration(
                    seconds: 4,
                  ),
                  child: Text(
                    widget.summary.substring(0, 85) + "....",
                    style: TextStyle(
                        color: CupertinoColors.systemGrey3,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              DelayedDisplay(
                delay: Duration(seconds: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Reviews",
                      style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.8,
                child: DelayedDisplay(
                  delay: Duration(seconds: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FirebaseAnimatedList(
                        defaultChild: Center(
                          child: CircularProgressIndicator(),
                        ),
                        query: FirebaseDatabase.instance
                            .reference()
                            .child("Review")
                            .child(widget.unique),
                        itemBuilder: (_, DataSnapshot snapshot,
                            Animation<double> animation, int index) {
                          return FutureBuilder<DataSnapshot>(
                              future: FirebaseDatabase.instance
                                  .reference()
                                  .child("Review")
                                  .child(widget.unique)
                                  .reference()
                                  .child(snapshot.key)
                                  .once(),
                              builder: (context, snapshot1) {
                                return snapshot1.hasData &&
                                        snapshot1.connectionState ==
                                            ConnectionState.done
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot1
                                                        .data.value['image']),
                                              ),
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      snapshot1
                                                          .data.value['name'],
                                                      style: TextStyle(
                                                          shadows: [
                                                            Shadow(
                                                                blurRadius: 2,
                                                                color: Colors
                                                                    .black12,
                                                                offset: Offset(
                                                                    2, 2))
                                                          ],
                                                          color: CupertinoColors
                                                              .white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  RatingBar.builder(
                                                    glow: true,
                                                    unratedColor:
                                                        CupertinoColors
                                                            .systemGrey,
                                                    ignoreGestures: true,
                                                    itemSize: 15,
                                                    initialRating: double.parse(
                                                        snapshot1.data
                                                            .value['rate']),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.8),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate:
                                                        (rating1) {},
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  snapshot1
                                                      .data.value['review'],
                                                  style: TextStyle(
                                                      color: CupertinoColors
                                                          .systemGrey2,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ),
                                        ],
                                      )
                                    : Container();
                              });
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
