import 'package:flutter/material.dart';

class BehanceStyleAppbar extends SliverPersistentHeader {
  final Widget leading;
  final Widget? title;
  final Widget? trailing;
  final double extent;
  final double appBarHeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String name;
  const BehanceStyleAppbar(
      {super.key,
      required this.leading,
      this.trailing,
      this.title,
      required this.name,
      this.extent = 380,
      this.appBarHeight = 270,
      this.backgroundColor,
      this.foregroundColor,
      required super.delegate});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _BehanceStyleAppbarDelegate(
          leading: leading,
          title: title,
          name: name,
          backgroundColor: backgroundColor ?? Colors.black,
          foregroundColor: foregroundColor ?? Colors.black,
          extent: extent > 200 ? extent : 200,
          appBarHeight: appBarHeight,
          trailing: trailing),
    );
  }
}

class _BehanceStyleAppbarDelegate extends SliverPersistentHeaderDelegate {
  final _leadingMarginTween = EdgeInsetsTween(
    begin: const EdgeInsets.only(bottom: 120),
    end: const EdgeInsets.only(left: 14.0, top: 30.0),
  );

  final _titleMarginTween = EdgeInsetsTween(
    begin: const EdgeInsets.only(bottom: 0),
    end: const EdgeInsets.only(left: 64.0, top: 50.0),
  );
  final _btmTitleMarginTween = EdgeInsetsTween(
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
  final String name;
  _BehanceStyleAppbarDelegate(
      {required this.leading,
      this.title,
      this.trailing,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.name,
      this.extent = 250,
      required this.appBarHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 72 * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final leadingMargin = _leadingMarginTween.lerp(progress);
    final titleMargin = _titleMarginTween.lerp(progress);
    final btmTitleMargin = _btmTitleMarginTween.lerp(progress);

    final leadingAlign = _leadingAlignTween.lerp(progress);
    final iconAlign = _iconAlignTween.lerp(progress);

    final leadingSize = (1 - progress) * 150 + 32;
    // final extentHeight = (100 * (1 - progress) * 1.5);
    return LayoutBuilder(builder: (context, constraint) {
      return Stack(
        children: <Widget>[
          //Bottom appbar
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.black12
                              .withValues(alpha: (1 - progress).clamp(0, 1))))
                  // color: backgroundColor.withValues(alpha:(1 - progress).clamp(0, 1)),
                  ),
            ),
          ),
          //Top appbar
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: appBarHeight,
            constraints: const BoxConstraints(maxHeight: 200),
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          Padding(
            padding: leadingMargin,
            child: Align(
              alignment: leadingAlign,
              child: SizedBox(
                height: constraint.maxWidth * .34,
                width: leadingSize,
                child: FittedBox(child: leading),
              ),
            ),
          ),
          //Top title
          Padding(
            padding: titleMargin,
            child: Align(
                alignment: leadingAlign,
                child: Opacity(
                  opacity: (progress).clamp(0, 1),
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16 + (5 * (1 - progress))),
                  ),
                )
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
          //Bottom title
          Padding(
            padding: btmTitleMargin,
            child: Align(
                alignment: leadingAlign,
                child: Visibility(
                  visible: (1 - progress).clamp(0, 1) > 0.8,
                  // opacity: (1 - progress).clamp(0, 1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18 + (5 * (1 - progress)),
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: LayoutBuilder(builder: (context, cnstrnt) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: constraint.maxHeight * .05),
                              padding: EdgeInsets.symmetric(
                                  horizontal: cnstrnt.maxWidth * .06,
                                  vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.edit,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12 + (5 * (1 - progress)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }))
                    ],
                  ),
                )
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
    });
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(_BehanceStyleAppbarDelegate oldDelegate) {
    return leading != oldDelegate.leading || title != oldDelegate.title;
  }
}

class TemparoryDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    throw UnimplementedError();
  }

  @override
  double get maxExtent => throw UnimplementedError();

  @override
  double get minExtent => throw UnimplementedError();

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    throw UnimplementedError();
  }
}
