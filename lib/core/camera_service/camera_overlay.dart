import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  final double padding;
  final double aspectRatio;
  final Color? bgColor;
  final Color? borderColor;
  const CameraOverlay(
      {super.key,
      this.padding = 25,
      this.aspectRatio = 5 / 3,
      this.bgColor,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      double horizontalPadding;
      double verticalPadding;

      if (parentAspectRatio < aspectRatio) {
        horizontalPadding = padding;
        verticalPadding = (constraints.maxHeight -
                ((constraints.maxWidth - 2 * padding) / aspectRatio)) /
            2;
      } else {
        verticalPadding = padding;
        horizontalPadding = (constraints.maxWidth -
                ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
            2;
      }
      return Stack(fit: StackFit.expand, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                width: horizontalPadding,
                color: bgColor ?? Colors.black.withValues(alpha: 0.5))),
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                width: horizontalPadding,
                color: bgColor ?? Colors.black.withValues(alpha: 0.5))),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: bgColor ?? Colors.black.withValues(alpha: 0.5))),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: bgColor ?? Colors.black.withValues(alpha: 0.5))),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
              border: Border.all(color: borderColor ?? Colors.cyan),
              borderRadius: BorderRadius.circular(10)),
        )
      ]);
    });
  }
}
