import 'dart:io';

import 'package:bookworm/Global/global.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

bool check = false;
var message;
AuthResult authResult;
String user;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formkey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController pwd = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pwd1 = new TextEditingController();
  final _auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  File image1;
  final databaseReference = FirebaseDatabase.instance.reference();
  var uid = Uuid();

  final snackBar = SnackBar(
    content: Text('Account created'),
    action: SnackBarAction(
      label: 'Sign in',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  Future uploadToStorage() async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + uid.toString());
      final String today = ('$month-$date');

      final file = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      image1 = File(file.path);
      uploadimage(image1);
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
        setState(() {
          check = !check;
        });
      });
    });
    return downloadurl;
  }

  Future<void> add(BuildContext context) async {
    var uuid = new Uuid().v1();
    DatabaseReference _color2 =
        databaseReference.child("UserDatabase").child(user);
    final TransactionResult transactionResult =
        await _color2.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });
    if (transactionResult.committed) {
      _color2.push().set(<String, String>{
        "image": "true",
        "name": "true",
        "email": "true",
        "pwd": "true",
        "userprofile": "true",
        "uid": "true"
      }).then((_) {
        print('Transaction  committed.');
        name.clear();
        email.clear();
        pwd.clear();
        pwd1.clear();
        setState(() {
          check = !check;
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
    _color2.set({
      "image": downloadurl,
      "name": name.text,
      "email": email.text,
      "pwd": pwd.text,
      "userprofile": user,
      "uid": uuid
    });
  }

  Future<void> _trysubmit(BuildContext ctx) async {
    final isvalid = formkey.currentState.validate();
    FocusScope.of(ctx).unfocus();
    if (isvalid) {
      formkey.currentState.save();
    } else {}
    _submitAuthForm(email.text.trim(), pwd.text.trim(), name.text.trim(), ctx)
        .then((value) {
      if (value == "Success") {
        add(ctx);
      }
    });
  }

  Future<String> _submitAuthForm(
    var email,
    var password,
    var username,
    BuildContext ctx,
  ) async {
    try {
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = authResult.user.uid;
    } on PlatformException catch (err) {
      message = "An error occurred, please check your credentials";
      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
      return "not successfull";
    } catch (err) {
      print(err);
    }
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: HexColor('#232531'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: GradientText(
                  text: "Let's create\nyou an account",
                  colors: [Colors.purple[200], Colors.orange[200]],
                  gradientDirection: GradientDirection.ltr,
                  style: GoogleFonts.kaushanScript(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                uploadToStorage();
              },
              child: Center(
                child: Card(
                  elevation: 9,
                  color: CupertinoColors.tertiarySystemFill,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          image: check == false
                              ? DecorationImage(
                                  image: ExactAssetImage("images/icon.png",
                                      scale: 6),
                                  alignment: Alignment.center)
                              : DecorationImage(
                                  image: NetworkImage(downloadurl),
                                  fit: BoxFit.fill),
                          color: CupertinoColors.tertiarySystemFill,
                          borderRadius: BorderRadius.circular(100))),
                ),
              ),
            ),
            Form(
                key: formkey,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 40.5),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                        child: Card(
                          elevation: 7,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(48),
                                color: CupertinoColors.tertiarySystemFill),
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "    Required";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white54),
                                    hintText: "Full Name",
                                    prefixIcon: Icon(
                                      CupertinoIcons.person,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Center(
                      child: Card(
                        elevation: 7,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(48),
                              color: CupertinoColors.tertiarySystemFill),
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value.isEmpty || !value.contains("@")) {
                                  return "    Kindly enter the correct id";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "@example.com",
                                hintStyle: TextStyle(color: Colors.white54),
                                prefixIcon: Icon(CupertinoIcons.mail,
                                    color: CupertinoColors.systemGrey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Card(
                        elevation: 7,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(48),
                              color: CupertinoColors.tertiarySystemFill),
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: pwd,
                              validator: (value) {
                                if (value.isEmpty || value.length < 7) {
                                  return "    Password must be 7 characters long";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white54),
                                prefixIcon: Icon(CupertinoIcons.lock,
                                    color: CupertinoColors.systemGrey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Card(
                        elevation: 7,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(48),
                              color: CupertinoColors.tertiarySystemFill),
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: pwd1,
                              validator: (value) {
                                if (pwd.text != value) {
                                  return "      Not matched";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: " Confirm Password",
                                hintStyle: TextStyle(color: Colors.white54),
                                prefixIcon: Icon(CupertinoIcons.lock,
                                    color: CupertinoColors.systemGrey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                ),
                Text(
                  "Sign up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.orange),
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.forward,
                    size: 30,
                    color: Colors.orange,
                  ),
                  onPressed: () async {
                    if (formkey.currentState.validate()) {
                      formkey.currentState.save();
                      _trysubmit(context);
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
