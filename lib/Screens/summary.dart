import 'dart:io';

import 'package:bookworm/Global/global.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

bool check = false;

class Summary extends StatefulWidget {
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  TextEditingController book = new TextEditingController();
  TextEditingController author = new TextEditingController();
  TextEditingController summary = new TextEditingController();

  File image1;
  final databaseReference = FirebaseDatabase.instance.reference();
  var uid = Uuid();
  final picker = ImagePicker();

  Future uploadToStorage() async {
    try {
      PickedFile file = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      this.setState(() {
        image1 = File(file.path);
      });

      await uploadimage(image1).then((value) => {
            setState(() {
              check = !check;
            })
          });
    } catch (error) {
      print(error);
    }
  }

  Future<String> uploadimage(var imagefile) async {
    var uuid = new Uuid().v1();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("post_$uuid.jpg");

    await ref.putFile(imagefile).onComplete.then((val) {
      val.ref.getDownloadURL().then((val) {
        print(val);
        downloadurl = val;
      });
    });
    return downloadurl;
  }

  Future<void> add() async {
    var uuid = new Uuid().v1();
    DatabaseReference _color2 = databaseReference.child("Summary").child(uuid);
    final TransactionResult transactionResult =
        await _color2.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });
    if (transactionResult.committed) {
      _color2.push().set(<String, String>{
        "image": "true",
        "book": "true",
        "author": "true",
        "summary": "true",
        "userprofile": "true",
        "uid": "true"
      }).then((_) {
        print('Transaction  committed.');
        showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Center(
                  child: DelayedDisplay(
                fadeIn: true,
                delay: Duration(
                  seconds: 1,
                ),
                child: Material(
                    color: Colors.transparent,
                    child: Text(
                      "Shared",
                      style: GoogleFonts.kaushanScript(
                          shadows: [
                            Shadow(
                                blurRadius: 2,
                                color: Colors.grey[100],
                                offset: Offset(2, 2))
                          ],
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          color: CupertinoColors.systemGreen),
                    )),
              ));
            });
        book.clear();
        author.clear();
        summary.clear();
        setState(() {
          check = !check;
        });
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
    _color2.set({
      "image": downloadurl,
      "book": book.text,
      "author": author.text,
      "summary": summary.text,
      "userprofile": user1,
      "uid": uuid
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#232531'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
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
                  SizedBox(width: MediaQuery.of(context).size.width / 9),
                  Text(
                    "Share Summary",
                    style: GoogleFonts.kaushanScript(
                        shadows: [
                          Shadow(
                              blurRadius: 2,
                              color: Colors.black12,
                              offset: Offset(2, 2))
                        ],
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        color: CupertinoColors.white),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9),
                    child: IconButton(
                        icon: Icon(
                          CupertinoIcons.checkmark,
                          size: 30,
                          color: CupertinoColors.systemGreen,
                        ),
                        onPressed: () {
                          add();
                        }),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                uploadToStorage();
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shadowColor: Colors.transparent,
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey,
                          image: check == false
                              ? DecorationImage(
                                  image: ExactAssetImage("images/icon.png",
                                      scale: 4),
                                  alignment: Alignment.center)
                              : DecorationImage(
                                  image: NetworkImage(downloadurl),
                                  fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  style: GoogleFonts.kaushanScript(
                    fontSize: 23,
                    color: CupertinoColors.white,
                  ),
                  controller: book,
                  decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      hintText: "Book Name",
                      hintStyle: GoogleFonts.kaushanScript(
                          color: CupertinoColors.systemGrey, fontSize: 25)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  style: GoogleFonts.kaushanScript(
                    fontSize: 23,
                    color: CupertinoColors.white,
                  ),
                  controller: author,
                  decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      hintText: "Author",
                      hintStyle: GoogleFonts.kaushanScript(
                          color: CupertinoColors.systemGrey, fontSize: 25)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: GoogleFonts.kaushanScript(
                  fontSize: 23,
                  color: CupertinoColors.white,
                ),
                controller: summary,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted: (string) {},
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Summary",
                    hintStyle: GoogleFonts.kaushanScript(
                        color: CupertinoColors.systemGrey, fontSize: 25)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
