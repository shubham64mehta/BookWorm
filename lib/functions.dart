import 'package:bookworm/Global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

final databaseReference = FirebaseDatabase.instance.reference();
var uid = Uuid();
bool check = false;

Future<void> five(String unique) async {
  var uuid = new Uuid().v1();
  DatabaseReference _color2 =
      databaseReference.child("Five").child(unique).child(uuid);
  final TransactionResult transactionResult =
      await _color2.runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + 1;

    return mutableData;
  });
  if (transactionResult.committed) {
    _color2.push().set(<String, String>{"uid": "true"}).then((_) {
      print('Transaction  committed.');
    });
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
  _color2.set({"uid": uuid});
}

Future<void> four(String unique) async {
  var uuid = new Uuid().v1();
  DatabaseReference _color2 =
      databaseReference.child("Four").child(unique).child(uuid);
  final TransactionResult transactionResult =
      await _color2.runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + 1;

    return mutableData;
  });
  if (transactionResult.committed) {
    _color2.push().set(<String, String>{"uid": "true"}).then((_) {
      print('Transaction  committed.');
    });
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
  _color2.set({"uid": uuid});
}

Future<void> three(String unique) async {
  var uuid = new Uuid().v1();
  DatabaseReference _color2 =
      databaseReference.child("Three").child(unique).child(uuid);
  final TransactionResult transactionResult =
      await _color2.runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + 1;

    return mutableData;
  });
  if (transactionResult.committed) {
    _color2.push().set(<String, String>{"uid": "true"}).then((_) {
      print('Transaction  committed.');
    });
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
  _color2.set({"uid": uuid});
}

Future<void> two(String unique) async {
  var uuid = new Uuid().v1();
  DatabaseReference _color2 =
      databaseReference.child("Two").child(unique).child(uuid);
  final TransactionResult transactionResult =
      await _color2.runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + 1;

    return mutableData;
  });
  if (transactionResult.committed) {
    _color2.push().set(<String, String>{"uid": "true"}).then((_) {
      print('Transaction  committed.');
    });
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
  _color2.set({"uid": uuid});
}

Future<void> one(String unique) async {
  var uuid = new Uuid().v1();
  DatabaseReference _color2 =
      databaseReference.child("One").child(unique).child(uuid);
  final TransactionResult transactionResult =
      await _color2.runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + 1;

    return mutableData;
  });
  if (transactionResult.committed) {
    _color2.push().set(<String, String>{"uid": "true"}).then((_) {
      print('Transaction  committed.');
    });
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
  _color2.set({"uid": uuid});
}

Future<void> fivestar(String userid) async {
  FirebaseDatabase.instance
      .reference()
      .child(userid)
      .once()
      .then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> values;
    values = snapshot.value;
    five1.clear();
    values.forEach((key, value) {
      FirebaseDatabase.instance
          .reference()
          .child("Five")
          .child(userid)
          .child(key)
          .child("uid")
          .once()
          .then((DataSnapshot s) {
        five1.add(s.value);
      });
    });
  });
}

Future<void> favourite(String unique, String summary, String book, String image,
    String author, String unique1) async {
  //var uuid = new Uuid().v1();
  DatabaseReference _color2 =
      databaseReference.child("Favourite").child(unique).child(unique1);
  final TransactionResult transactionResult =
      await _color2.runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + 1;

    return mutableData;
  });
  if (transactionResult.committed) {
    _color2.push().set(<String, String>{
      "uid": "true",
      "summary": "true",
      "book": "true",
      "image": "true",
      "author": "true",
      "userprofile": "true"
    }).then((_) {
      print('Transaction  committed.');
    });
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
  _color2.set({
    "uid": unique1,
    "summary": summary,
    "book": book,
    "image": image,
    "author": author,
    "userprofile": unique
  });
}

Future<Widget> profile1(BuildContext context, String unique) async {
  return showCupertinoModalBottomSheet(
      elevation: 12,
      backgroundColor: HexColor('#232531'),
      context: context,
      builder: (context) {
        return Container(
            color: HexColor('#232531'),
            height: MediaQuery.of(context).size.height / 7,
            child: FutureBuilder<DataSnapshot>(
                future: FirebaseDatabase.instance
                    .reference()
                    .child("UserDatabase")
                    .child(unique)
                    .once(),
                builder: (context, snapshot1) {
                  return snapshot1.hasData &&
                          snapshot1.connectionState == ConnectionState.done
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 7,
                                    color: CupertinoColors.tertiarySystemFill,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot1.data.value['image']),
                                          ),
                                          color: CupertinoColors
                                              .tertiarySystemFill,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  ),
                                ),
                                Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      snapshot1.data.value['name'],
                                      style: GoogleFonts.kaushanScript(
                                          shadows: [
                                            Shadow(
                                                blurRadius: 3,
                                                color: Colors.black12,
                                                offset: Offset(2, 3))
                                          ],
                                          fontSize: 27,
                                          fontWeight: FontWeight.w300,
                                          color: CupertinoColors.white),
                                    ))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      "View Profile",
                                      style: GoogleFonts.kaushanScript(
                                          shadows: [
                                            Shadow(
                                                blurRadius: 3,
                                                color: Colors.black12,
                                                offset: Offset(2, 3))
                                          ],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: CupertinoColors.activeBlue),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }));
      });
}
