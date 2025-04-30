import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../core/camera_service/camera_service.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraHelper cameraHelper;
  late CameraController controller;
  @override
  void initState() {
    super.initState();
    cameraHelper = CameraHelper(context: context);
    controller = CameraController(
        widget.cameras[0], enableAudio: false, ResolutionPreset.max);
    cameraHelper.initialize(controller, onRefreshed: () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Camera Screen"),
      ),
      body: CameraScaffold(
        overlay: const [CameraOverlay()],
        preview: cameraHelper.cameraWidget(controller),
        cameraButton: cameraHelper.cameraButton(
          onTap: () async {
            cameraHelper.showLoading();
            final result = await cameraHelper.takePicture(controller);
            cameraHelper.closeLoading();
            cameraHelper.showExampleImage(result);
          },
        ),
      ),
    );
  }
}
