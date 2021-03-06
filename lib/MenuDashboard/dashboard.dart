import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Dashboard extends StatelessWidget {
  final bool isCollapsed;
  final double screenWidth;
  final Duration duration;
  final Animation<double> scaleAnimation;
  final Function onMenuTap;
  final Widget child;

  const Dashboard(
      {Key key,
      this.isCollapsed,
      this.screenWidth,
      this.duration,
      this.scaleAnimation,
      this.onMenuTap,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Material(
          color: HexColor('#25231'),
          shadowColor: Colors.white60,
          animationDuration: duration,
          child: child,
        ),
      ),
    );
  }
}
