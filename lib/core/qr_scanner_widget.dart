import 'dart:io';

import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScannerWidget extends StatefulWidget {
  final bool showHelper;
  final void Function()? onNext;
  final void Function(String data) onScan;
  const QrCodeScannerWidget(
      {super.key, this.showHelper = false, this.onNext, required this.onScan});

  @override
  State<QrCodeScannerWidget> createState() => _QrCodeScannerWidgetState();
}

class _QrCodeScannerWidgetState extends State<QrCodeScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
              Visibility(
                visible: widget.showHelper,
                child: qrHelper(),
              ),
            ],
          ),
          Positioned(
              bottom: 200,
              child: GestureDetector(
                onTap: () async {
                  await controller!.pauseCamera();
                  if (widget.onNext != null) {
                    widget.onNext!();
                  } else {
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: StadiumBorder(), color: Colors.black26),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Seterusnya",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget qrHelper() {
    return Expanded(
      flex: 1,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (result != null)
              Text('Barcode Type: ${result!.format}   Data: ${result!.code}')
            else
              const Text('Scan a code'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      child: FutureBuilder(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          return Text('Flash: ${snapshot.data}');
                        },
                      )),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      child: FutureBuilder(
                        future: controller?.getCameraInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Text('Camera facing ${snapshot.data!}');
                          } else {
                            return const Text('loading');
                          }
                        },
                      )),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller?.pauseCamera();
                    },
                    child: const Text('pause', style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller?.resumeCamera();
                    },
                    child: const Text('resume', style: TextStyle(fontSize: 20)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      await controller.pauseCamera();
      widget.onScan(result?.code ?? "");
      dev.log("dapat data:${result?.code}");
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    dev.log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
