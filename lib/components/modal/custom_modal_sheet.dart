import 'package:flutter/material.dart';

class CustomModalSheet extends StatefulWidget {
  final BorderRadiusGeometry borderRadius;
  final Animation<double>? animation;
  final bool useCustomAnimation;
  final bool isScrollControlled;
  final Widget Function(BuildContext context) builder;
  final Widget Function(Animation<double> animation, Widget child)?
      animationBuilder;

  const CustomModalSheet({
    super.key,
    required this.builder,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(20)),
    this.animation,
    this.useCustomAnimation = false,
    this.isScrollControlled = false,
    this.animationBuilder,
  });

  @override
  State<CustomModalSheet> createState() => _CustomModalSheetState();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.vertical(top: Radius.circular(20)),
    Animation<double>? animation,
    bool useCustomAnimation = false,
    bool isScrollControlled = false,
    Widget Function(Animation<double> animation, Widget child)?
        animationBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (_) => CustomModalSheet(
        builder: builder,
        borderRadius: borderRadius,
        animation: animation,
        useCustomAnimation: useCustomAnimation,
        animationBuilder: animationBuilder,
      ),
    );
  }
}

class _CustomModalSheetState extends State<CustomModalSheet> {
  @override
  Widget build(BuildContext context) {
    final child = ClipRRect(
      borderRadius: widget.borderRadius,
      child: widget.builder(context),
    );

    if (!widget.useCustomAnimation) {
      return child;
    }

    final animation = widget.animation ??
        CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );

    if (widget.animationBuilder != null) {
      return widget.animationBuilder!(animation, child);
    }

    // Default: Scale transition
    return ScaleTransition(scale: animation, child: child);
  }
}
