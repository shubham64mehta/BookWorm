import 'package:bookworm/Authentication/signup.dart';
import 'package:bookworm/Global/global.dart';
import 'package:bookworm/GoogleAuth/google.dart';
import 'package:bookworm/MenuDashboard/menudashboardlayout.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert' as JSON;

AuthResult user;
final fb = FacebookLogin();

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoggedin = false;
  Map<String, dynamic> userprofile;

  FirebaseAuth _auth = FirebaseAuth.instance;

  /* Future loginwithfb() async {
// Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final FacebookAccessToken accessToken = res.accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);

        final result =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile.name}! You ID: ${profile.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) print('And your email is $email');

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }*/

  /* Future<String> logout() async {
    facebooklogin.logOut();
    setState(() {
      isLoggedin = false;
    });

    return "user signed out";
  }*/

  final formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  TextEditingController email1 = new TextEditingController();
  TextEditingController pwd = new TextEditingController();

  Future<AuthResult> signIn(String email, String password) async {
    try {
      user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      assert(user != null);
      assert(await user.user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.user.uid == currentUser.uid);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#232531'),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 17,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(seconds: 1),
                            reverseDuration: Duration(seconds: 1),
                            child: Signup(),
                            type: PageTransitionType.rightToLeft));
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemGrey,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: GradientText(
                  text: "Nice\nto see you\nAgain",
                  colors: [Colors.purple[200], Colors.orange[200]],
                  gradientDirection: GradientDirection.ltr,
                  style: GoogleFonts.kaushanScript(
                      fontSize: 60, fontWeight: FontWeight.bold),
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
                                controller: email1,
                                validator: (value) {
                                  if (value.isEmpty || !value.contains("@")) {
                                    return "     Please Enter the correct emailid";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white54),
                                    hintText: "Input Email",
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
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 14,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "forgot password?",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.systemGrey),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                        Text(
                          "Sign in",
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
                              signIn(email1.text, pwd.text).then((value) {
                                email1.clear();
                                pwd.clear();
                                imageUrl = user.user.photoUrl;

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MenuDashboardLayout()));
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                "Or continue with",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.systemGrey),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5.3,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Card(
                    elevation: 7,
                    color: CupertinoColors.tertiarySystemFill,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                          color: CupertinoColors.tertiarySystemFill,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: Icon(
                          FontAwesome.twitter,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    /* loginwithfb().whenComplete(() async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuDashboardLayout()));
                    });*/
                  },
                  child: Card(
                    elevation: 7,
                    color: CupertinoColors.tertiarySystemFill,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                          color: CupertinoColors.tertiarySystemFill,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: Icon(
                          FontAwesome.facebook,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    signInWithGoogle().whenComplete(() async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuDashboardLayout()));
                    });
                  },
                  child: Card(
                    elevation: 7,
                    color: CupertinoColors.tertiarySystemFill,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                          color: CupertinoColors.tertiarySystemFill,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: Icon(
                          FontAwesome.google,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
