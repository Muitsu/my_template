import 'package:flutter/material.dart';

class TransitionAppBar extends StatelessWidget {
  final Widget leading;
  final Widget? title;
  final Widget? trailing;
  final double extent;
  final double appBarHeight;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const TransitionAppBar(
      {super.key,
      required this.leading,
      this.trailing,
      this.title,
      this.extent = 300,
      this.appBarHeight = 300,
      this.backgroundColor,
      this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
          leading: leading,
          title: title,
          backgroundColor: backgroundColor ?? Colors.black,
          foregroundColor: foregroundColor ?? Colors.white,
          extent: extent > 200 ? extent : 200,
          appBarHeight: appBarHeight,
          trailing: trailing),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final _leadingMarginTween = EdgeInsetsTween(
    begin: const EdgeInsets.only(bottom: 10),
    end: const EdgeInsets.only(left: 14.0, top: 45.0),
  );

  final _titleMarginTween = EdgeInsetsTween(
    begin: const EdgeInsets.only(bottom: 20),
    end: const EdgeInsets.only(left: 64.0, top: 50.0),
  );

  final _leadingAlignTween =
      AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.topLeft);
  final _iconAlignTween =
      AlignmentTween(begin: Alignment.bottomRight, end: Alignment.topRight);

  final Widget leading;
  final Widget? title;
  final double extent;
  final double appBarHeight;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? trailing;
  _TransitionAppBarDelegate(
      {required this.leading,
      this.title,
      this.trailing,
      required this.backgroundColor,
      required this.foregroundColor,
      this.extent = 250,
      required this.appBarHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 72 * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final leadingMargin = _leadingMarginTween.lerp(progress);
    final titleMargin = _titleMarginTween.lerp(progress);

    final leadingAlign = _leadingAlignTween.lerp(progress);
    final iconAlign = _iconAlignTween.lerp(progress);

    final leadingSize = (1 - progress) * 150 + 32;
    // final extentHeight = (100 * (1 - progress) * 1.5);

    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: appBarHeight,
          constraints: BoxConstraints(maxHeight: minExtent),
          color: backgroundColor,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              // color: backgroundColor.withValues(alpha:(1 - progress).clamp(0, 1)),
            ),
          ),
        ),
        Padding(
          padding: leadingMargin,
          child: Align(
            alignment: leadingAlign,
            child: SizedBox(
              height: leadingSize,
              width: leadingSize,
              child: FittedBox(child: leading),
            ),
          ),
        ),
        Padding(
          padding: titleMargin,
          child: Align(alignment: leadingAlign, child: title
              // Text(
              //   title, style: TextStyle(color: foregroundColor),
              // capitalize(title),
              // style: bodyText1Style(
              //   context,
              //   color: progress < 0.4 ? Colors.white : Colors.black,
              //   fontSize: 18 + (5 * (1 - progress)),
              //   fontWeight: FontWeight.w600,
              // ),
              // ),
              ),
        ),
        Padding(
          padding: titleMargin,
          child: Align(
            alignment: iconAlign,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: trailing,
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(_TransitionAppBarDelegate oldDelegate) {
    return leading != oldDelegate.leading || title != oldDelegate.title;
  }
}
