import 'dart:typed_data';

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraHelper {
  final BuildContext context;
  final Key? key;
  CameraHelper({required this.context, this.key});

  Future<void> initialize(CameraController controller,
      {required void Function() onRefreshed}) async {
    checkPermission().then((val) {
      if (!val) {
        showPermissionDialog(
          controller,
          onDissmissed: () {
            onRefreshed();
          },
        );
        return;
      }
      startCamera(controller).then((val) {
        onRefreshed();
      });
    });
  }

  Future<bool> checkPermission() async {
    var status = await Permission.camera.status;
    return (status.isGranted);
  }

  Future<bool> startCamera(CameraController controller) async {
    try {
      await controller.initialize();
      if (!context.mounted) return false;
      return true;
    } catch (e) {
      if (e is CameraException) {
        return false;
      }
      return false;
    }
  }

  Future<Uint8List> takePicture(CameraController controller) async {
    await controller.setFocusMode(FocusMode.locked);
    await controller.setExposureMode(ExposureMode.locked);
    final rawImg = await controller.takePicture();
    await controller.setFocusMode(FocusMode.auto);
    await controller.setExposureMode(ExposureMode.auto);
    return await rawImg.readAsBytes();
  }

  Widget cameraWidget(CameraController controller, {Widget? errorWidget}) {
    if (!controller.value.isInitialized) {
      return errorWidget ?? Container(color: Colors.black);
    }
    var camera = controller.value;

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller),
      ),
    );
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

  Future<void> showPermissionDialog(CameraController controller,
      {required void Function() onDissmissed}) async {
    Future.delayed(const Duration(milliseconds: 150)).then((_) {
      showDialog(
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
                                  color: Colors.grey.withOpacity(0.3),
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
                                bool isCameraStarted =
                                    await startCamera(controller);

                                if (isCameraStarted) {
                                  if (await Permission
                                      .camera.status.isGranted) {
                                    onDissmissed();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
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
                                  Navigator.pop(context);
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
    });
  }

  Future<dynamic> showLoading() {
    return showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {},
        child: GestureDetector(
          onTap: () {},
          child: Material(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CameraBlinkText(
                      "Stay still ...",
                      style: TextStyle(
                          color: Colors.white.withOpacity(.6), fontSize: 18),
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
