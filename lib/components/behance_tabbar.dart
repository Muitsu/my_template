import 'package:flutter/material.dart';

class BehanceTabbar extends StatelessWidget {
  final void Function(int index) onTap;
  final List<String> tabs;
  final int initialTab;
  final ScrollController? controller;
  final List<GlobalKey>? keys;
  const BehanceTabbar(
      {super.key,
      required this.onTap,
      required this.tabs,
      required this.initialTab,
      this.controller,
      this.keys});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: BehanceTabbarDelegate(
          currentTab: initialTab,
          controller: controller,
          onTap: onTap,
          keys: keys,
          tabs: tabs,
        ));
  }
}

class BehanceTabbarDelegate extends SliverPersistentHeaderDelegate {
  final List<String> tabs;
  double height = 64;
  final void Function(int index) onTap;
  final int currentTab;
  final ScrollController? controller;
  final List<GlobalKey>? keys;
  BehanceTabbarDelegate(
      {required this.currentTab,
      required this.onTap,
      this.keys,
      required this.tabs,
      this.controller});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: Colors.white24))),
        height: height,
        child: Center(
          child: ListView.separated(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            itemBuilder: (BuildContext context, int index) => InkWell(
              onTap: () {
                onTap(index);
              },
              child: AnimatedContainer(
                  key: keys?[index],
                  margin: tabs.isNotEmpty
                      ? EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                          left: index == 0 ? 10 : 0,
                          right: index == tabs.length - 1 ? 10 : 0)
                      : const EdgeInsets.only(top: 12, bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: currentTab == index
                        ? Colors.white24
                        : Colors.transparent,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
          ),
        ));
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
