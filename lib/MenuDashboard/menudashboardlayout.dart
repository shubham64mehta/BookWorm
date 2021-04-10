import 'package:bookworm/Global/global.dart';
import 'package:bookworm/Screens/favourite.dart';
import 'package:bookworm/Screens/home.dart';
import 'package:bookworm/Screens/setting1.dart';
import 'package:bookworm/Screens/settings.dart';
import 'package:bookworm/class/class%20.dart';
import 'package:bookworm/navigationbloc/navigationbloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dashboard.dart';
import 'menu.dart';

final Color backgroundColor = HexColor('#232531');

//Map<dynamic, dynamic> mp;

class MenuDashboardLayout extends StatefulWidget {
  @override
  _MenuDashboardLayoutState createState() => _MenuDashboardLayoutState();
}

class _MenuDashboardLayoutState extends State<MenuDashboardLayout>
    with SingleTickerProviderStateMixin {
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  Future<void> read() async {
    FirebaseDatabase.instance
        .reference()
        .child("Summary")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values;
      values = snapshot.value;
      //image1.clear();
      //book1.clear();
      books.clear();
      values.forEach((key, value) {
        FirebaseDatabase.instance
            .reference()
            .child("Summary")
            .child(key)
            .once()
            .then((DataSnapshot s) {
          // book1.add(s.value);
          bookname = s.value['book'];
          imageurl = s.value['image'];
          uid1 = s.value['uid'];
          Book obj = new Book(bookname, imageurl, uid1);
          books.add(obj);
        });
      });
    });
    read1();
  }

  Future<void> read1() async {
    FirebaseDatabase.instance
        .reference()
        .child("Summary")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values;
      values = snapshot.value;
      //image1.clear();
      //book1.clear();
      books.clear();
      values.forEach((key, value) {
        FirebaseDatabase.instance
            .reference()
            .child("Summary")
            .child(key)
            .child("book")
            .once()
            .then((DataSnapshot s) {
          book1.add(s.value);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    read();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onMenuTap() {
    setState(() {
      if (isCollapsed)
        _controller.forward();
      else
        _controller.reverse();

      isCollapsed = !isCollapsed;
    });
  }

  void onMenuItemClicked() {
    setState(() {
      _controller.reverse();
    });

    isCollapsed = !isCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(onMenuTap: onMenuTap),
        child: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, NavigationStates navigationState) {
                return Menu(
                    slideAnimation: _slideAnimation,
                    menuAnimation: _menuScaleAnimation,
                    selectedIndex: findSelectedIndex(navigationState),
                    onMenuItemClicked: onMenuItemClicked);
              },
            ),
            Dashboard(
              duration: duration,
              onMenuTap: onMenuTap,
              scaleAnimation: _scaleAnimation,
              isCollapsed: isCollapsed,
              screenWidth: screenWidth,
              child: BlocBuilder<NavigationBloc, NavigationStates>(builder: (
                context,
                NavigationStates navigationState,
              ) {
                return navigationState as Widget;
              }),
            ),
          ],
        ),
      ),
    );
  }

  int findSelectedIndex(NavigationStates navigationState) {
    if (navigationState is MyCardsPage) {
      return 0;
    } else if (navigationState is MessagesPage) {
      return 1;
    } else if (navigationState is UtilityBillsPage) {
      return 2;
    } else if (navigationState is Setting1) {
      return 3;
    } else {
      return 0;
    }
  }
}
