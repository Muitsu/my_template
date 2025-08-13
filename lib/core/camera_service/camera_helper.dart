import 'dart:io';
import 'dart:typed_data';

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;

class CameraHelper {
  final BuildContext context;
  final Key? key;
  CameraHelper({required this.context, this.key});

  Future<CameraController?> initialize(
      {CameraController? controller,
      CameraLensDirection initialCamera = CameraLensDirection.back,
      required List<CameraDescription> cameras,
      required void Function() onRefreshed}) async {
    final isGranted = await checkPermission();
    //Permission is denied
    if (!isGranted) {
      final control = await showPermissionDialog(
        controller,
        cameras,
        initialCamera,
        onDissmissed: () {
          onRefreshed();
        },
      );
      onRefreshed();
      return control;
    }
    //Permission granted
    controller = await startCamera(controller, cameras, initialCamera);
    onRefreshed();
    return controller;
  }

  Future<bool> checkPermission() async {
    var status = await Permission.camera.status;
    return (status.isGranted);
  }

  Future<CameraController?> startCamera(
    CameraController? controller,
    List<CameraDescription> cameras,
    CameraLensDirection initialCamera,
  ) async {
    final requestCamera = _findCamera(initialCamera, cameras);
    controller = CameraController(
      requestCamera,
      enableAudio: false,
      ResolutionPreset.max,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    try {
      await controller.initialize();
      if (!context.mounted) return null;
      return controller;
    } catch (e) {
      if (e is CameraException) {
        return null;
      }
      return null;
    }
  }

  CameraDescription _findCamera(
      CameraLensDirection initialCamera, List<CameraDescription> cameras) {
    int cameraIndex = -1;
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == initialCamera) {
        cameraIndex = i;
        break;
      }
    }
    if (cameraIndex == -1) {
      // Request camera not found
      dev.log(
          name: "CameraHelper", " Request camera not found : $initialCamera");
      cameraIndex = 0; // default camera
    }
    return cameras[cameraIndex];
  }

  Future<CameraController?> switchCameraDirection(
      {CameraController? controller,
      required CameraLensDirection request,
      required List<CameraDescription> cameras,
      required void Function() onRefreshed}) async {
    final requestCamera = _findCamera(request, cameras);
    // await controller?.stopImageStream();
    await controller?.dispose();
    controller = null;
    controller = CameraController(
      requestCamera,
      enableAudio: false,
      ResolutionPreset.max,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    onRefreshed();
    return await startCamera(controller, cameras, request);
  }

  Future<Uint8List> takePicture(CameraController controller) async {
    await controller.setFocusMode(FocusMode.locked);
    await controller.setExposureMode(ExposureMode.locked);
    final rawImg = await controller.takePicture();
    await controller.setFocusMode(FocusMode.auto);
    await controller.setExposureMode(ExposureMode.auto);
    return await rawImg.readAsBytes();
  }

  Widget cameraWidget(
      {CameraController? controller,
      Widget? errorWidget,
      bool isControllerDispose = false}) {
    if (controller == null) return Container(color: Colors.black);
    if (isControllerDispose == true) return Container(color: Colors.black);

    // Check if controller is disposed
    if (!controller.value.isInitialized || controller.value.isRecordingPaused) {
      return errorWidget ?? Container(color: Colors.black);
    }

    try {
      final size = MediaQuery.of(context).size;
      var scale = size.aspectRatio * controller.value.aspectRatio;
      if (scale < 1) scale = 1 / scale;

      return Transform.scale(
        scale: scale,
        child: Center(
          child: CameraPreview(controller),
        ),
      );
    } catch (e) {
      // Fallback UI if anything goes wrong
      return errorWidget ?? Container(color: Colors.black);
    }
  }

  Widget cameraButton({void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white), shape: BoxShape.circle),
        child: Container(
          width: 60,
          height: 60,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          // child: const Icon(Icons.search),
        ),
      ),
    );
  }

  Future<CameraController?> showPermissionDialog(CameraController? controller,
      List<CameraDescription> cameras, CameraLensDirection initialCamera,
      {required void Function() onDissmissed}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final result = await showDialog<CameraController?>(
        // ignore: use_build_context_synchronously
        context: context,
        useSafeArea: false,
        barrierDismissible: false,
        builder: (builder) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: PopScope(
              canPop: false,
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.3),
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 50,
                            )),
                        const SizedBox(height: 15),
                        const Text(
                          "We would like to access to camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber),
                            onPressed: () async {
                              final isCameraStarted = await startCamera(
                                  controller, cameras, initialCamera);

                              if (isCameraStarted != null) {
                                if (await Permission.camera.status.isGranted) {
                                  onDissmissed();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context, isCameraStarted);
                                }
                              }
                            },
                            child: const Text(
                              'Enable Camera Access',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context, null);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'No Thanks',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
    return result;
  }

  Future<dynamic> showLoading() {
    return showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {},
        child: GestureDetector(
          onTap: () {},
          child: Material(
              color: Colors.black.withValues(alpha: 0.6),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CameraBlinkText(
                      "Stay still ...",
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: .6),
                          fontSize: 18),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void closeLoading() {
    Navigator.pop(context);
  }

  void showExampleImage(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.memory(imageBytes),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class CameraBlinkText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final TextAlign? textAlign;
  const CameraBlinkText(
    this.text, {
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 500),
    this.textAlign,
  });

  @override
  CameraBlinkTextState createState() => CameraBlinkTextState();
}

class CameraBlinkTextState extends State<CameraBlinkText> {
  bool _isVisible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBlinking() {
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: widget.duration,
      child: Text(
        widget.text,
        textAlign: widget.textAlign,
        style: widget.style,
      ),
    );
  }
}
