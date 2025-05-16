import 'package:flutter/material.dart';

class SliverOverlapBuilder extends StatelessWidget {
  final Widget child;
  final List<Widget> sliversInjector;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const SliverOverlapBuilder({
    super.key,
    required this.child,
    required this.sliversInjector,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) => CustomScrollView(
        physics: physics,
        controller: controller,
        slivers: [
          ...sliversInjector,
          SliverToBoxAdapter(child: child),
        ],
      ),
    );
  }
}
