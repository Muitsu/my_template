import 'package:flutter/material.dart';

class ShrinkTextAppbar extends StatelessWidget {
  final String title;
  final bool pinned;
  final bool floating;
  final double expandedHeight;
  final double? scrolledUnderElevation;
  final Color backgroundColor;
  final Color foregroundColor;
  final List<Widget>? actions;
  const ShrinkTextAppbar({
    super.key,
    required this.title,
    this.pinned = true,
    this.floating = false,
    this.expandedHeight = 120,
    this.scrolledUnderElevation,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      scrolledUnderElevation: scrolledUnderElevation,
      floating: floating,
      expandedHeight: expandedHeight,
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      leading: BackButton(color: foregroundColor),
      flexibleSpace: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double top = constraints.biggest.height;
            final shrinkFactor =
                ((top - kToolbarHeight) / (expandedHeight - kToolbarHeight))
                    .clamp(0.0, 1.0);

            final double fontSize = 24 * shrinkFactor + 18 * (1 - shrinkFactor);
            final double left = 16 * shrinkFactor + 56 * (1 - shrinkFactor);

            final double verticalOffset = 2 * shrinkFactor;

            return Stack(
              children: [
                Positioned(
                  left: left,
                  bottom: 16.0 + verticalOffset,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: foregroundColor,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
