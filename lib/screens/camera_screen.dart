import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../core/camera_service/camera_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraHelper cameraHelper;
  CameraController? controller;
  static List<CameraDescription> _cameras = [];
  bool isControllerDisposed = false;
  @override
  void initState() {
    super.initState();
    cameraHelper = CameraHelper(context: context);
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }

    final newController = await cameraHelper.initialize(
      controller: controller,
      cameras: _cameras,
      initialCamera: CameraLensDirection.back,
      onRefreshed: () => setState(() {}),
    );

    setState(() {
      controller?.dispose();
      isControllerDisposed = false;
      controller = newController;
    });
  }

  Future<void> _switchCamera() async {
    setState(() => isControllerDisposed = true);

    controller?.dispose();

    final newController = await cameraHelper.switchCameraDirection(
      controller: controller,
      request: CameraLensDirection.front,
      cameras: _cameras,
      onRefreshed: () => setState(() {}),
    );

    setState(() {
      isControllerDisposed = false;
      controller = newController;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
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
        preview: cameraHelper.cameraWidget(controller: controller),
        cameraButton: cameraHelper.cameraButton(
          onTap: () async {
            cameraHelper.showLoading();
            final result = await cameraHelper.takePicture(controller!);
            cameraHelper.closeLoading();
            cameraHelper.showExampleImage(result);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchCamera,
        child: const Icon(Icons.flip_camera_android_outlined),
      ),
    );
  }
}
