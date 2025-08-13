import 'package:flutter/material.dart';

class CustomPageTransition {
  //CURVE ANIMATION
  static PageRouteBuilder curveToPage(
      {required Widget page, Curve curve = Curves.easeOutExpo}) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          alignment: Alignment.center,
          scale: Tween<double>(begin: 0.5, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
          ),
          child: child,
        );
      },
    );
  }

  //SLIDE ANIMATION
  static PageRouteBuilder slideToPage(
      {required Widget page, required SlideFrom slide}) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
                  begin: Offset(slide.offset[0], slide.offset[1]),
                  end: const Offset(0.0, 0.0))
              .animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return page;
      },
    );
  }
}

enum SlideFrom {
  right(offset: [1.0, 0.0]),
  left(offset: [-1.0, 0.0]),
  bottom(offset: [0.0, 1.0]),
  top(offset: [0.0, -1.0]);

  final List<double> offset;
  const SlideFrom({required this.offset});
}
