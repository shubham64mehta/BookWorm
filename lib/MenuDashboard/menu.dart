import 'package:bookworm/Authentication/login.dart';
import 'package:bookworm/Global/global.dart';
import 'package:bookworm/GoogleAuth/google.dart';
import 'package:bookworm/navigationbloc/navigationbloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

bool check = false;

class Menu extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> menuAnimation;
  final int selectedIndex;
  final Function onMenuItemClicked;

  const Menu(
      {Key key,
      this.slideAnimation,
      this.menuAnimation,
      this.selectedIndex,
      @required this.onMenuItemClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: menuAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      elevation: 9,
                      color: CupertinoColors.tertiarySystemFill,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                            ),
                            color: CupertinoColors.tertiarySystemFill,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesome.home,
                        color: selectedIndex == 0
                            ? CupertinoColors.activeOrange
                            : CupertinoColors.systemGrey,
                      ),
                      SizedBox(
                        width: 17,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.DashboardClickedEvent);
                          onMenuItemClicked();
                        },
                        child: Text(
                          "Home",
                          style: TextStyle(
                            color: selectedIndex == 0
                                ? CupertinoColors.white
                                : CupertinoColors.systemGrey,
                            fontSize: 22,
                            fontWeight: selectedIndex == 0
                                ? FontWeight.w900
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesome.heart,
                        color: selectedIndex == 1
                            ? CupertinoColors.activeOrange
                            : CupertinoColors.systemGrey,
                      ),
                      SizedBox(
                        width: 17,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.MessagesClickedEvent);
                          onMenuItemClicked();
                        },
                        child: Text(
                          "Favourite",
                          style: TextStyle(
                            color: selectedIndex == 1
                                ? CupertinoColors.white
                                : CupertinoColors.systemGrey,
                            fontSize: 22,
                            fontWeight: selectedIndex == 1
                                ? FontWeight.w900
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesome.clock_o,
                        color: selectedIndex == 2
                            ? CupertinoColors.activeOrange
                            : CupertinoColors.systemGrey,
                      ),
                      SizedBox(
                        width: 17,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.UtilityClickedEvent);
                          onMenuItemClicked();
                        },
                        child: Text(
                          "Read it later",
                          style: TextStyle(
                            color: selectedIndex == 2
                                ? CupertinoColors.white
                                : CupertinoColors.systemGrey,
                            fontSize: 22,
                            fontWeight: selectedIndex == 2
                                ? FontWeight.w900
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesome.gear,
                        color: selectedIndex == 3
                            ? CupertinoColors.activeOrange
                            : CupertinoColors.systemGrey,
                      ),
                      SizedBox(
                        width: 17,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.Setting1ClickedEvent);
                          onMenuItemClicked();
                        },
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            color: selectedIndex == 3
                                ? CupertinoColors.white
                                : CupertinoColors.systemGrey,
                            fontSize: 22,
                            fontWeight: selectedIndex == 3
                                ? FontWeight.w900
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesome.power_off,
                          color: CupertinoColors.systemGrey,
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        GestureDetector(
                          onTap: () {
                            signOutGoogle().whenComplete(() async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Authentication()));
                            });
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
