import 'package:flutter/material.dart';
import 'package:my_template/components/modal/custom_modal_sheet.dart';
import 'package:my_template/components/modal/sliver_overlap_builder.dart';
import 'package:my_template/core/mobile_info.dart';

import '../components/appbar/shrink_text_appbar.dart';

class ShrinkAppbarScreen extends StatefulWidget {
  const ShrinkAppbarScreen({super.key});

  @override
  State<ShrinkAppbarScreen> createState() => _ShrinkAppbarScreenState();
}

class _ShrinkAppbarScreenState extends State<ShrinkAppbarScreen> {
  final _appBar = SliverOverlapAbsorberHandle();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181D),
      body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: _appBar,
                sliver: ShrinkTextAppbar(
                  title: 'Trusted device',
                  scrolledUnderElevation: 0,
                  backgroundColor: const Color(0xFF17181D),
                  actions: [
                    IconButton(
                        onPressed: () {
                          CustomModalSheet.show(
                              context: context,
                              builder: (context) {
                                return Container(
                                    padding: const EdgeInsets.all(10),
                                    color: const Color(0xFF20242F),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PreferredSize(
                                              preferredSize:
                                                  const Size.fromHeight(18),
                                              child: Align(
                                                  child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                height: 5,
                                                width: 60,
                                              ))),
                                          ...List.generate(
                                              2,
                                              (index) => ListTile(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  title: Text(
                                                    "Setting $index",
                                                    style: TextStyle(
                                                      color: index == 0
                                                          ? Colors.red
                                                          : Colors
                                                              .grey.shade300,
                                                    ),
                                                  ))),
                                        ]));
                              });
                        },
                        icon: const Icon(Icons.more_vert))
                  ],
                ),
              ),
            ];
          },
          body: SliverOverlapBuilder(
            physics: const BouncingScrollPhysics(),
            sliversInjector: [
              SliverOverlapInjector(handle: _appBar),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Link a trusted device to prevent unauthorized access",
                    style: TextStyle(color: Color(0xFF5E6167)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF20242F)),
                    child: Column(
                      children: [
                        const CircleAvatar(radius: 30),
                        const SizedBox(height: 10),
                        Text(
                          MobileInfo.deviceName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _simpleTile(
                            title: "Model", subtitle: MobileInfo.deviceModel),
                        _simpleTile(
                            title: "OS Version",
                            subtitle: MobileInfo.deviceOSVersion),
                        _simpleTile(
                            title: "Activation Name",
                            subtitle: "15 May 2025, 9:08 am"),
                        const Divider(height: 20, color: Color(0xFF17181D)),
                        const SizedBox(height: 6),
                        const Text(
                          "This is the only authorised device to approve for other login activities",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF5E6167)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _simpleTile({required String title, required String subtitle}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      minVerticalPadding: 10,
      minTileHeight: 8,
      dense: false,
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF5E6167), fontSize: 12),
      ),
      trailing: Text(
        subtitle,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
