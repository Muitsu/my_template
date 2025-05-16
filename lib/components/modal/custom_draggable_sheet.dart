import 'package:flutter/material.dart';

class CustomDraggableSheet extends StatefulWidget {
  final double initialChildSize;
  final double maxChildSize;
  final double minChildSize;
  final bool expand;
  final bool useCustomAnimation;
  final bool snapAtFullScreen;
  final BorderRadiusGeometry? borderRadius;
  final Animation<double>? animation;
  final Widget Function(BuildContext context, ScrollController? sc) builder;
  final Widget Function(Animation<double> animation, Widget child)?
      animationBuilder;

  const CustomDraggableSheet({
    super.key,
    this.initialChildSize = .7,
    this.maxChildSize = 1,
    this.minChildSize = .6,
    this.useCustomAnimation = false,
    this.expand = false,
    this.snapAtFullScreen = false,
    required this.builder,
    this.borderRadius,
    this.animation,
    this.animationBuilder,
  });

  @override
  State<CustomDraggableSheet> createState() => _CustomDraggableSheetState();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext context, ScrollController? sc)
        builder,
    double initialChildSize = .7,
    double maxChildSize = 1,
    double minChildSize = .6,
    bool expand = false,
    bool snapAtFullScreen = false,
    bool useCustomAnimation = false,
    BorderRadiusGeometry? borderRadius,
    Animation<double>? animation,
    Widget Function(Animation<double> animation, Widget child)?
        animationBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (_) => CustomDraggableSheet(
        builder: builder,
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: minChildSize,
        expand: expand,
        animation: animation,
        borderRadius: borderRadius,
        snapAtFullScreen: snapAtFullScreen,
        useCustomAnimation: useCustomAnimation,
        animationBuilder: animationBuilder,
      ),
    );
  }
}

class _CustomDraggableSheetState extends State<CustomDraggableSheet> {
  final _dragController = DraggableScrollableController();
  bool isAtTop = false;

  @override
  void initState() {
    super.initState();
    if (widget.snapAtFullScreen) {
      _dragController.addListener(_onDrag);
    }
  }

  void _onDrag() {
    final currentSize = _dragController.size;
    if (currentSize == 1 && isAtTop == false) {
      setState(() => isAtTop = true);
    }
  }

  @override
  void dispose() {
    if (widget.snapAtFullScreen) {
      _dragController.removeListener(_onDrag);
      _dragController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = DraggableScrollableSheet(
      expand: widget.expand,
      controller: _dragController,
      initialChildSize: widget.initialChildSize,
      maxChildSize: widget.maxChildSize,
      minChildSize: widget.minChildSize,
      builder: (context, sc) {
        return ClipRRect(
          borderRadius: widget.borderRadius ??
              const BorderRadius.vertical(top: Radius.circular(20)),
          child: widget.builder(context, isAtTop ? null : sc),
        );
      },
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
