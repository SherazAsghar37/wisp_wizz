import 'package:flutter/material.dart';

class BouncyPageRoute extends PageRouteBuilder {
  final Widget widget;
  BouncyPageRoute({required this.widget})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.elasticInOut;

            final curevedAnimation =
                CurvedAnimation(parent: animation, curve: curve);
            return ScaleTransition(
              scale: curevedAnimation,
              child: child,
            );
          },
        );
}
