import 'package:bookworm/Global/global.dart';
import 'package:bookworm/Screens/favourite1.dart';
import 'package:bookworm/navigationbloc/navigationbloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

int index2;
int index3;

class MessagesPage extends StatefulWidget with NavigationStates {
  final Function onMenuTap;

  const MessagesPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<String> image = ["images/1.jpg", "images/2.jpg", "images/3.jpg"];
  List<String> bookq = [
    "Books are a \nuniquely portable magic",
    "Sleep is good,\nhe said, and books are better",
    "'Classic′ – a book which\npeople praise and don’t read"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#232531'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: CarouselSlider.builder(
                    itemCount: 3,
                    itemBuilder: (context, index, index1) {
                      index3 = index;
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: DelayedDisplay(
                              fadeIn: true,
                              slidingCurve: Curves.bounceOut,
                              delay: Duration(
                                seconds: 1,
                              ),
                              child: Text(bookq[index],
                                  style: TextStyle(
                                      shadows: [
                                        Shadow(
                                            blurRadius: 2,
                                            color: Colors.black,
                                            offset: Offset(2, 2))
                                      ],
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.white)),
                            ),
                          ),
                        ),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.grey[600], BlendMode.modulate),
                                fit: BoxFit.cover,
                                image: ExactAssetImage(
                                  image[index],
                                ))),
                      );
                    },
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        initialPage: 0,
                        // aspectRatio: 0.7,
                        height: MediaQuery.of(context).size.height / 2),
                  ),
                ),

                Positioned(
                  bottom: 350,
                  child: IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: widget.onMenuTap),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text("Collections",
                  style: TextStyle(
                      shadows: [
                        Shadow(
                            blurRadius: 2,
                            color: Colors.black,
                            offset: Offset(2, 2))
                      ],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white)),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.6,
              child: FirebaseAnimatedList(
                defaultChild: Center(
                  child: CircularProgressIndicator(),
                ),
                scrollDirection: Axis.horizontal,
                query: FirebaseDatabase.instance
                    .reference()
                    .child("Favourite")
                    .child(user1),
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return FutureBuilder<DataSnapshot>(
                      future: FirebaseDatabase.instance
                          .reference()
                          .child("Favourite")
                          .child(user1)
                          .reference()
                          .child(snapshot.key)
                          .once(),
                      builder: (context, snapshot1) {
                        return snapshot1.hasData
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Favourite1(
                                                  hero: index,
                                                  image: snapshot1
                                                      .data.value['image'],
                                                  author: snapshot1
                                                      .data.value['author'],
                                                  book: snapshot1
                                                      .data.value['book'],
                                                  summary: snapshot1
                                                      .data.value['summary'],
                                                  unique: snapshot1
                                                      .data.value['uid'],
                                                )));
                                  },
                                  child: Hero(
                                    tag: index,
                                    child: Card(
                                      color:
                                          CupertinoColors.secondarySystemFill,
                                      elevation: 7,
                                      child: Container(
                                        width: 200,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.8,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                image: NetworkImage(snapshot1
                                                    .data.value['image']))),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
