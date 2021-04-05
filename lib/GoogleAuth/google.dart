import 'package:bookworm/Global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

final databaseReference = FirebaseDatabase.instance.reference();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  // Only taking the first part of the name, i.e., First Name

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  user1 = user.uid;
  /* SharedPreferences pref15 = await SharedPreferences.getInstance();
  pref15.setString("alreadyregistered", user.uid);
  SharedPreferences pref1 = await SharedPreferences.getInstance();
  pref1.setString("name", name);
  SharedPreferences pref2 = await SharedPreferences.getInstance();
  pref2.setString("image", imageUrl);
  SharedPreferences pref3 = await SharedPreferences.getInstance();
  pref3.setString("email", email);*/
  userdatabase();
  return 'signInWithGoogle succeeded: $user';
}

Future<String> signOutGoogle() async {
  await googleSignIn.signOut();

  return "User Sign Out";
}

Future<void> userdatabase() async {
  var uuid = new Uuid().v1();
  DatabaseReference _color2 =
      databaseReference.child("UserDatabase").child(user1);
  final TransactionResult transactionResult =
      await _color2.runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + 1;

    return mutableData;
  });
  if (transactionResult.committed) {
    _color2.push().set(<String, String>{
      "uid": "true",
      "name": "true",
      "image": "true",
      "email": "true"
    }).then((_) {
      print('Transaction  committed.');
    });
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
  _color2.set({"uid": user1, "name": name, "image": imageUrl, "email": email});
}
