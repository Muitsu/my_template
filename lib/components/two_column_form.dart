import 'package:flutter/material.dart';

class TwoColumnForm extends StatelessWidget {
  final List<Widget> children;
  const TwoColumnForm({super.key, this.children = const <Widget>[]});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of items per row
        childAspectRatio: getGridAspectRatio(size), // Aspect ratio of each item
        mainAxisSpacing: 10.0, // Spacing between rows
        crossAxisSpacing: 10.0, // Spacing between columns
      ),
      children: children,
    );
  }

  double getGridAspectRatio(Size size) {
    final isMobile = size.width < 400;
    final isBigTablet = size.width > 490;
    const mRatio = 16 / 8;
    const smallTabRatio = 16 / 4.2;
    return isMobile
        ? mRatio
        : isBigTablet
            ? 16 / 6
            : smallTabRatio;
  }
}
