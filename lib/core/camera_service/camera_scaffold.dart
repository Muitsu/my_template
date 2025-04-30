import 'package:flutter/material.dart';

class CameraScaffold extends StatelessWidget {
  final Widget preview;
  final List<Widget>? overlay;
  final Widget? cameraButton;
  final Widget? zoomSlider;

  const CameraScaffold({
    super.key,
    required this.preview,
    this.overlay,
    this.cameraButton,
    this.zoomSlider,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        preview,
        if (overlay != null) ...overlay!,
        button(),
        zoomWidget(),
      ],
    );
  }

  Widget button() {
    if (cameraButton == null) return const SizedBox();

    return Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: Align(alignment: Alignment.bottomCenter, child: cameraButton));
  }

  Widget zoomWidget() {
    if (zoomSlider == null) return const SizedBox();
    return Positioned(bottom: 200, right: 10, left: 10, child: zoomSlider!);
  }
}
