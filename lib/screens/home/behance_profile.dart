import 'package:flutter/material.dart';
import 'package:my_template/components/appbar/behance_appbar.dart';
import 'package:my_template/components/behance_tabbar.dart';

/*REFERENCE: https://github.com/AmirBayat0/flutter_scroll_animation/blob/main/flutter_scroll_animation/lib/pages/home.dart */
class BehanceProfile extends StatefulWidget {
  const BehanceProfile({super.key});

  @override
  State<BehanceProfile> createState() => _BehanceProfileState();
}

class _BehanceProfileState extends State<BehanceProfile> {
  late PageController _pageController;
  int currentIndex = 0;
  final tabs = const [
    "Privacy",
    "User Agreement",
    "My Project",
    "Transfer Data"
  ];
  late ScrollController _sc;
  late List<GlobalKey> profileTabKey;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    profileTabKey = List.generate(tabs.length, (index) => GlobalKey());
    _sc = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    scrollToIndex(page);
    setState(() => currentIndex = page);
  }

  void scrollToIndex(int index) async {
    final profileTab = profileTabKey[index].currentContext!;
    await Scrollable.ensureVisible(
      profileTab,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              //To avoid extra scrolling Absorber & Injector
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: BehanceStyleAppbar(
                delegate: TemparoryDelegate(),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200),
                  child: const Icon(
                    Icons.person,
                  ),
                ),
                name: "Ahmad Muizzuddin",
              ),
            ),
            BehanceTabbar(
              initialTab: currentIndex,
              keys: profileTabKey,
              controller: _sc,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  _pageController.jumpToPage(index);
                });
              },
              tabs: tabs,
            ),
          ];
        },
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: tabs
              .map((tab) => Container(
                  color: Colors.black,
                  child: Center(
                      child: Text(
                    tab,
                    style: const TextStyle(color: Colors.white),
                  ))))
              .toList(),
        ),
      ),
    );
  }
}
