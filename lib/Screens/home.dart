import 'package:bookworm/Global/global.dart';
import 'package:bookworm/MenuDashboard/menudashboardlayout.dart';
import 'package:bookworm/Screens/review.dart';
import 'package:bookworm/Screens/summary.dart';
import 'package:bookworm/functions.dart';
import 'package:bookworm/navigationbloc/navigationbloc.dart';
import 'package:bookworm/search/search.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

bool check = false;
bool check1 = false;
bool check3;
double rte;
DatabaseReference database1;
String text;
List<String> numbers = ['5', '4', '3', '2', '1'];

class MyCardsPage extends StatefulWidget with NavigationStates {
  final Function onMenuTap;

  const MyCardsPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _MyCardsPageState createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var uid = Uuid();
  TextEditingController review1 = new TextEditingController();

  Future<void> add2(String rating, String review, String image, String name1,
      String unique) async {
    var uuid = new Uuid().v1();
    DatabaseReference _color2 =
        databaseReference.child("Review").child(unique).child(uuid);
    final TransactionResult transactionResult =
        await _color2.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });
    if (transactionResult.committed) {
      _color2.push().set(<String, String>{
        "rating": "true",
        "review": "true",
        "image": "true",
        "name": "true",
        "uid": "true"
      }).then((_) {
        print('Transaction  committed.');
        review1.clear();

        add1(unique);
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
    _color2.set({
      "rate": rating,
      "review": review,
      "image": image,
      "name": name1,
      "uid": uuid
    });
  }

  Future<void> add1(String unique) async {
    review.add(unique);
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('review', review);

    final mystringlist = prefs.getStringList('review');
    print(mystringlist);
  }

  void check1() async {
    final prefs = await SharedPreferences.getInstance();
    review = prefs.getStringList('review') ?? [];

    print(review);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database1 = FirebaseDatabase.instance.reference().child('Summary');
    check1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: widget.onMenuTap,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(CupertinoIcons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(seconds: 1),
                          reverseDuration: Duration(seconds: 1),
                          child: Summary(),
                          type: PageTransitionType.bottomToTop));
                }),
          )
        ],
      ),
      backgroundColor: HexColor('#232531'),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                      text: "Hi  ",
                      style: GoogleFonts.kaushanScript(
                          shadows: [
                            Shadow(
                                blurRadius: 2,
                                color: Colors.grey[100],
                                offset: Offset(2, 2))
                          ],
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                          color: CupertinoColors.systemGrey),
                      children: <TextSpan>[
                        TextSpan(
                          text: name,
                          style: GoogleFonts.kaushanScript(
                              shadows: [
                                Shadow(
                                    blurRadius: 2,
                                    color: Colors.black,
                                    offset: Offset(2, 2))
                              ],
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              color: CupertinoColors.white),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  //print(image1);
                  // print(book1);
                  //print(books[0].bookname);
                  showSearch(
                    context: context,
                    delegate: Datasearch(),
                  );
                },
                child: Center(
                  child: Card(
                    elevation: 7,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Container(
                        height: MediaQuery.of(context).size.height / 14,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: CupertinoColors.tertiarySystemFill),
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Icon(
                                FontAwesome.search,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Search",
                              style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                  fontSize: 20),
                            )
                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Center(
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: FirebaseAnimatedList(
                        scrollDirection: Axis.horizontal,
                        defaultChild:
                            Center(child: CircularProgressIndicator()),
                        query: database1,
                        itemBuilder: (_, DataSnapshot snapshot,
                            Animation<double> animation, int index) {
                          print(index);
                          return FutureBuilder<DataSnapshot>(
                              future: database1
                                  .reference()
                                  .child(snapshot.key)
                                  .once(),
                              builder: (context, snapshot1) {
                                return snapshot1.hasData &&
                                        snapshot1.connectionState ==
                                            ConnectionState.done
                                    ? DelayedDisplay(
                                        delay: Duration(seconds: 1),
                                        fadeIn: true,
                                        slidingCurve: Curves.easeOutSine,
                                        child: GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.all(55.0),
                                            child: Card(
                                              color: CupertinoColors
                                                  .tertiarySystemFill,
                                              elevation: 25,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              shadowColor: Colors.transparent,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.4,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                decoration: BoxDecoration(
                                                  color: CupertinoColors
                                                      .tertiarySystemFill,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot1.data
                                                              .value['image']),
                                                      fit: BoxFit.fill),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            //   fivestar(snapshot1.data.value['uid']);

                                            setState(() {
                                              check3 = review.contains(
                                                  snapshot1.data.value['uid']);
                                            });
                                            print(review.contains(
                                                snapshot1.data.value['uid']));
                                            setState(() {
                                              check = false;
                                            });

                                            showCupertinoModalBottomSheet(
                                              backgroundColor:
                                                  HexColor('#232531'),
                                              context: context,
                                              builder: (context) => Container(
                                                color: HexColor('#232531'),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    CupertinoColors
                                                                        .systemGrey,
                                                                child:
                                                                    IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          CupertinoIcons
                                                                              .multiply,
                                                                          color:
                                                                              CupertinoColors.white,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        }),
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.7,
                                                              ),
                                                              IconButton(
                                                                  icon: Icon(
                                                                    CupertinoIcons
                                                                        .profile_circled,
                                                                    color: CupertinoColors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    profile1(
                                                                        context,
                                                                        snapshot1
                                                                            .data
                                                                            .value['userprofile']);
                                                                  }),
                                                              IconButton(
                                                                  icon: Icon(
                                                                    CupertinoIcons
                                                                        .ellipsis,
                                                                    color: CupertinoColors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    showCupertinoModalBottomSheet(
                                                                        backgroundColor:
                                                                            HexColor(
                                                                                '#232531'),
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Container(
                                                                              color: HexColor('#232531'),
                                                                              height: MediaQuery.of(context).size.height,
                                                                              child: Review(unique: snapshot1.data.value['uid']));
                                                                        });
                                                                  }),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Card(
                                                            shadowColor:
                                                                CupertinoColors
                                                                    .tertiarySystemFill,
                                                            elevation: 20,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16)),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  3,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                image: DecorationImage(
                                                                    image: NetworkImage(snapshot1
                                                                            .data
                                                                            .value[
                                                                        'image']),
                                                                    fit: BoxFit
                                                                        .fill),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Material(
                                                                  elevation: 0,
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: Text(
                                                                    snapshot1
                                                                            .data
                                                                            .value[
                                                                        'book'],
                                                                    style: GoogleFonts.kaushanScript(
                                                                        shadows: [
                                                                          Shadow(
                                                                              blurRadius: 2,
                                                                              color: Colors.black12,
                                                                              offset: Offset(2, 2))
                                                                        ],
                                                                        color: CupertinoColors
                                                                            .white,
                                                                        fontSize:
                                                                            28,
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  ),
                                                                )),
                                                          ),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  9),
                                                          if (check3 == false ||
                                                              check3 == null)
                                                            Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child:
                                                                  GestureDetector(
                                                                child: Text(
                                                                    "Rate it",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: CupertinoColors
                                                                            .systemGrey,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                onTap: () {
                                                                  showCupertinoModalBottomSheet(
                                                                      backgroundColor:
                                                                          HexColor(
                                                                              '#232531'),
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Container(
                                                                          color:
                                                                              HexColor('#232531'),
                                                                          height: check == false
                                                                              ? MediaQuery.of(context).size.height / 1.8
                                                                              : MediaQuery.of(context).size.height / 3.7,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child: check == false
                                                                                ? Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height: 30,
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(20.0),
                                                                                            child: RatingBar.builder(
                                                                                              unratedColor: CupertinoColors.systemGrey,
                                                                                              itemSize: 24,
                                                                                              initialRating: 0,
                                                                                              minRating: 1,
                                                                                              direction: Axis.horizontal,
                                                                                              allowHalfRating: true,
                                                                                              itemCount: 5,
                                                                                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                                                              itemBuilder: (context, _) => Icon(
                                                                                                Icons.star,
                                                                                                color: Colors.amber,
                                                                                              ),
                                                                                              onRatingUpdate: (rating1) {
                                                                                                rte = rating1;
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                                          ),
                                                                                          Material(
                                                                                            color: Colors.transparent,
                                                                                            child: IconButton(
                                                                                                icon: Icon(CupertinoIcons.share, color: CupertinoColors.white),
                                                                                                onPressed: () {
                                                                                                  if (rte >= 5) {
                                                                                                    five(snapshot1.data.value['uid']);
                                                                                                  }
                                                                                                  if (rte >= 4 && rte < 5) {
                                                                                                    four(snapshot1.data.value['uid']);
                                                                                                  }
                                                                                                  if (rte >= 3 && rte < 4) {
                                                                                                    three(snapshot1.data.value['uid']);
                                                                                                  }
                                                                                                  if (rte >= 2 && rte < 3) {
                                                                                                    two(snapshot1.data.value['uid']);
                                                                                                  }
                                                                                                  if (rte >= 1 && rte < 2) {
                                                                                                    one(snapshot1.data.value['uid']);
                                                                                                  }
                                                                                                  add2(rte.toString(), review1.text, imageUrl, name, snapshot1.data.value['uid']);
                                                                                                  Navigator.pop(context);
                                                                                                  setState(() {
                                                                                                    check = !check;
                                                                                                  });
                                                                                                }),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: Container(
                                                                                                height: MediaQuery.of(context).size.height / 1.8,
                                                                                                child: TextFormField(
                                                                                                  controller: review1,
                                                                                                  textInputAction: TextInputAction.done,
                                                                                                  style: TextStyle(color: CupertinoColors.white),
                                                                                                  //   keyboardType: TextInputType.multiline,
                                                                                                  maxLines: null,
                                                                                                  decoration: InputDecoration(
                                                                                                      hintText: "Share your review",
                                                                                                      hintStyle: TextStyle(
                                                                                                        color: CupertinoColors.systemGrey,
                                                                                                        fontSize: 20,
                                                                                                      ),
                                                                                                      border: InputBorder.none),
                                                                                                ),
                                                                                              )))
                                                                                    ],
                                                                                  )
                                                                                : Material(
                                                                                    child: Center(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Center(
                                                                                            child: Image.asset(
                                                                                          'images/error.gif',
                                                                                          filterQuality: FilterQuality.high,
                                                                                          scale: 2.8,
                                                                                          fit: BoxFit.cover,
                                                                                        )),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Center(
                                                                                            child: RichText(
                                                                                                text: TextSpan(text: "Sorry ", style: GoogleFonts.kaushanScript(shadows: [Shadow(blurRadius: 2, color: Colors.grey[300], offset: Offset(2, 2))], color: CupertinoColors.systemRed, fontSize: 25, fontWeight: FontWeight.bold), children: <TextSpan>[
                                                                                              TextSpan(text: "Already done", style: GoogleFonts.kaushanScript(shadows: [Shadow(blurRadius: 2, color: Colors.grey[300], offset: Offset(2, 2))], color: CupertinoColors.black, fontSize: 23, fontWeight: FontWeight.w300))
                                                                                            ])),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  )),
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.5),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Text(
                                                            snapshot1
                                                                .data
                                                                .value[
                                                                    'summary']
                                                                .substring(
                                                                    0, 86),
                                                            style: TextStyle(
                                                                shadows: [
                                                                  Shadow(
                                                                      blurRadius:
                                                                          3,
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                          Offset(
                                                                              2,
                                                                              3))
                                                                ],
                                                                color: CupertinoColors
                                                                    .systemGrey2,
                                                                fontSize: 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child:
                                                              GestureDetector(
                                                            child: Text(
                                                              "More",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: CupertinoColors
                                                                    .activeBlue,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              showCupertinoModalBottomSheet(
                                                                  backgroundColor:
                                                                      HexColor(
                                                                          '#232531'),
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Container(
                                                                      color: HexColor(
                                                                          '#232531'),
                                                                      height:
                                                                          MediaQuery.of(context).size.height /
                                                                              1,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: Material(
                                                                                color: Colors.transparent,
                                                                                child: Row(
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                      backgroundColor: Colors.grey[400],
                                                                                      child: IconButton(
                                                                                          icon: Icon(
                                                                                            CupertinoIcons.multiply,
                                                                                            color: CupertinoColors.white,
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context);
                                                                                          }),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Material(
                                                                                color: Colors.transparent,
                                                                                child: Text(
                                                                                  snapshot1.data.value['summary'],
                                                                                  style: TextStyle(shadows: [
                                                                                    Shadow(blurRadius: 3, color: Colors.black12, offset: Offset(2, 3))
                                                                                  ], color: CupertinoColors.white, fontSize: 19, fontWeight: FontWeight.w400),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.1,
                                                            height: 2,
                                                            color: Colors
                                                                .grey[200]),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Text(
                                                            "Author",
                                                            style: GoogleFonts
                                                                .kaushanScript(
                                                                    shadows: [
                                                                  Shadow(
                                                                      blurRadius:
                                                                          2,
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                          Offset(
                                                                              2,
                                                                              2))
                                                                ],
                                                                    color: CupertinoColors
                                                                        .white,
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Text(
                                                            snapshot1
                                                                    .data.value[
                                                                'author'],
                                                            style: TextStyle(
                                                                color: CupertinoColors
                                                                    .systemGrey,
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Center(
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child:
                                                              CupertinoButton(
                                                                  color: CupertinoColors
                                                                      .activeBlue,
                                                                  disabledColor:
                                                                      CupertinoColors
                                                                          .activeBlue,
                                                                  child: Text(
                                                                      "Add it to favourite"),
                                                                  onPressed:
                                                                      () {
                                                                    favourite(
                                                                      snapshot1
                                                                          .data
                                                                          .value['userprofile'],
                                                                      snapshot1
                                                                          .data
                                                                          .value['summary'],
                                                                      snapshot1
                                                                          .data
                                                                          .value['book'],
                                                                      snapshot1
                                                                          .data
                                                                          .value['image'],
                                                                      snapshot1
                                                                          .data
                                                                          .value['author'],
                                                                      snapshot1
                                                                          .data
                                                                          .value['uid'],
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                      SizedBox(height: 12),
                                                      Center(
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child:
                                                              CupertinoButton(
                                                                  color: CupertinoColors
                                                                      .systemGrey,
                                                                  disabledColor:
                                                                      CupertinoColors
                                                                          .systemGrey3,
                                                                  child: Text(
                                                                    "Read it later",
                                                                    style: TextStyle(
                                                                        color: CupertinoColors
                                                                            .black),
                                                                  ),
                                                                  onPressed:
                                                                      null),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Text("nothing");
                              });
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
