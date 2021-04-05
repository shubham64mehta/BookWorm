import 'package:flutter/material.dart';

class ScaleRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  ScaleRoute({this.enterPage, this.exitPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    reverseCurve: Curves.fastOutSlowIn,
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: exitPage,
              ),
              ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      reverseCurve: Curves.fastOutSlowIn,
                      parent: animation,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: enterPage),
            ],
          ),
          /*ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              ),*/
        );
}
