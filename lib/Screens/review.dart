import 'package:bookworm/Global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Review extends StatefulWidget {
  final String unique;

  const Review({Key key, this.unique}) : super(key: key);
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Material(
            color: Colors.transparent,
            child: Text(
              "Ratings and reviews",
              style: GoogleFonts.kaushanScript(
                  shadows: [
                    Shadow(
                        blurRadius: 2,
                        color: Colors.black12,
                        offset: Offset(2, 2))
                  ],
                  color: CupertinoColors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              SizedBox(width: 160),
              Material(
                color: Colors.transparent,
                child: Text(
                  "5",
                  style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              LinearPercentIndicator(
                width: 200,
                lineHeight: 10,
                percent: five1.length.toDouble(),
                backgroundColor: Colors.grey[400],
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              SizedBox(width: 160),
              Material(
                color: Colors.transparent,
                child: Text(
                  "4",
                  style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              LinearPercentIndicator(
                width: 200,
                lineHeight: 10,
                percent: 0.0,
                backgroundColor: Colors.grey[400],
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              SizedBox(width: 160),
              Material(
                color: Colors.transparent,
                child: Text(
                  "3",
                  style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              LinearPercentIndicator(
                width: 200,
                lineHeight: 10,
                percent: 0.0,
                backgroundColor: Colors.grey[400],
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              SizedBox(width: 160),
              Material(
                color: Colors.transparent,
                child: Text(
                  "2",
                  style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              LinearPercentIndicator(
                width: 200,
                lineHeight: 10,
                percent: 0.0,
                backgroundColor: Colors.grey[400],
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              SizedBox(width: 160),
              Material(
                color: Colors.transparent,
                child: Text(
                  "1",
                  style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              LinearPercentIndicator(
                width: 200,
                lineHeight: 10,
                percent: 0.0,
                backgroundColor: Colors.grey[400],
              )
            ],
          ),
        ),
        SizedBox(
          height: 23,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapshot1.data.value['image']),
                                      ),
                                      SizedBox(width: 20),
                                      Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          snapshot1.data.value['name'],
                                          style: TextStyle(
                                              shadows: [
                                                Shadow(
                                                    blurRadius: 2,
                                                    color: Colors.black12,
                                                    offset: Offset(2, 2))
                                              ],
                                              color: CupertinoColors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: RatingBar.builder(
                                      unratedColor: CupertinoColors.systemGrey,
                                      ignoreGestures: true,
                                      itemSize: 15,
                                      initialRating: double.parse(
                                          snapshot1.data.value['rate']),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.8),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating1) {},
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          snapshot1.data.value['review'],
                                          style: TextStyle(
                                              color: CupertinoColors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  )
                                ],
                              )
                            : Container();
                      });
                }),
          ),
        )
      ],
    );
  }
}
