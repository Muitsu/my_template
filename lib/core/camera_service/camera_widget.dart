import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as imag;
import 'package:flutter/material.dart';

import 'camera_service.dart';

class CameraWidget extends StatefulWidget {
  final void Function(Uint8List uintImg) onTakePicture;
  final CameraOverlay? overlay;
  const CameraWidget({
    super.key,
    required this.onTakePicture,
    this.overlay,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? controller;
  bool isLoading = false;
  Uint8List? images;
  @override
  void initState() {
    super.initState();
    _getCameraDesc();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  _getCameraDesc() async {
    final cameraDesc = await availableCameras();
    controller = CameraController(cameraDesc[0], ResolutionPreset.veryHigh);

    _cameraPermissionCheck(controller: controller!);
  }

  _cameraPermissionCheck({required CameraController controller}) {
    _checkCameraPermission().then((isGranted) {
      if (!isGranted) {
        Future.delayed(const Duration(seconds: 0)).then((_) {
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white,
              builder: (builder) {
                return PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {},
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
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
                              child: const Icon(Icons.camera_alt)),
                          const SizedBox(height: 15),
                          const Text(
                            'Permission to use\nCamera',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await onPressedAllow(context, controller);
                                  },
                                  child: const Text("Allow"))),
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
                                  'Later',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
      } else {
        initiateCamera(controller);
      }
    });
  }

  Future<void> onPressedAllow(
      BuildContext context, CameraController controller) async {
    await initiateCamera(controller).then((value) async => {
          if (await Permission.camera.status.isGranted)
            {
              if (context.mounted) {Navigator.pop(context)}
            }
        });
  }

  cameraWidget(context) {
    if (!(controller?.value.isInitialized ?? false)) {
      return Container();
    }
    var camera = controller!.value;

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller!),
      ),
    );
  }

  Future<void> initiateCamera(CameraController controller) {
    return controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  Future<bool> _checkCameraPermission() async {
    bool cameraGranted = false;
    var status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        cameraGranted = true;
      });
    }
    return cameraGranted;
  }

  cropImage(Uint8List bytes) {
    imag.Image? image = imag.decodeImage(bytes);
    int height = (image!.height / 2.8).round();
    return imag.copyCrop(image,
        x: 0, y: height, width: image.width, height: 460);
  }

  void closeLoading() => Navigator.pop(context);

  Future<dynamic> showLoading(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => PopScope(
        canPop: false,
        onPopInvoked: (val) async {},
        child: GestureDetector(
          onTap: () {},
          child: Material(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(15),
                    color: Colors.white,
                    child: const CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        cameraWidget(context),
        if (widget.overlay != null) widget.overlay!,
        Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  showLoading(context);
                  await controller!.setFocusMode(FocusMode.locked);
                  await controller!.setExposureMode(ExposureMode.locked);
                  // controller!.pausePreview();
                  final rawImg = await controller!.takePicture();

                  Uint8List uintImg = await rawImg.readAsBytes();

                  closeLoading();
                  widget.onTakePicture(uintImg);
                  // controller!.resumePreview();
                  await controller!.setFocusMode(FocusMode.auto);
                  await controller!.setExposureMode(ExposureMode.auto);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
