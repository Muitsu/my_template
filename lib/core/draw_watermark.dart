import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'package:image/image.dart' as imag;
import 'package:intl/intl.dart';

class DrawWatermark {
  static late imag.BitmapFont _bitMapFont;

  static final DrawWatermark _instance = DrawWatermark._internal();
  factory DrawWatermark() {
    return _instance;
  }
  DrawWatermark._internal();
  static Future<void> initializeFont() async {
    try {
      final assetFont = await rootBundle.load(OpenSansFont.white.path);
      final font = assetFont.buffer
          .asUint8List(assetFont.offsetInBytes, assetFont.lengthInBytes);
      _bitMapFont = ImageFont.readOtherFontZip(font);
    } catch (e) {
      dev.log("Failed to initialize", name: "Watermark");
      _bitMapFont = imag.arial48;
    }
  }

  ///Note: [onRunDraw] Running on Isolate.run
  static Future<Uint8List> onRunDraw(
      {required Uint8List bytes, required String text}) async {
    //The insideFont variable is declare inside function to fix the LateInitializationError
    final insideFont = _bitMapFont;
    return await Isolate.run(() async => bgProcessImg(bytes, insideFont, text));
  }

  ///Note: [onSpawnDraw] Running on Isolate.spawn
  static Future<Uint8List> onSpawnDraw({required Uint8List bytes}) async {
    try {
      //Recive port and Send port
      final receivePort = ReceivePort();
      final sendPort = receivePort.sendPort;
      //Start background
      await Isolate.spawn(onSpawn, [sendPort, bytes, _bitMapFont],
          onError: sendPort);
      final val = await receivePort.first;
      //End Backrground
      return val;
    } catch (e) {
      dev.log("Image not initialize", name: "Watermark");
      throw Exception();
    }
  }

/*INSIDE ISOLATE*/
  static Future<void> onSpawn(List<dynamic> args) async {
    //Variable receive from spawn
    SendPort sendPort = args[0];
    Uint8List image = args[1];
    imag.BitmapFont bitmap = args[2];
    //Start Function process
    final result = await bgProcessImg(image, bitmap);
    sendPort.send(result);
    Isolate.exit(sendPort, result);
  }

/*FUNCTION TO RUN*/
  static Future<Uint8List> bgProcessImg(Uint8List bytes, imag.BitmapFont bitmap,
      [String? textVal, WatermarkSize size = WatermarkSize.small]) async {
    imag.Image imgs = imag.decodeImage(bytes)!;

    // Resize the image to the specified dimensions
    final resizedImage = imag.copyResize(imgs,
        width: size.dimensionWidth, height: size.dimensionHeight);

    // Get the current timestamp for the watermark
    final now = DateTime.now();
    final text = DateFormat('yyyy-MM-dd  hh:mm:ss a').format(now);

    final imgWidth = resizedImage.width;
    final imgHeight = resizedImage.height;

    // Position the text in the bottom area of the resized image
    final x = (imgWidth ~/ 5);
    final y = imgHeight - 180;

    // New text, if passed in, otherwise use the default text
    final newText = textVal ?? "";

    // Draw the watermark text onto the resized image
    imag.drawString(
      resizedImage,
      "$text\n$newText",
      font: bitmap, // Use the specified bitmap font (arial48)
      color: _bgGetColor(), // Use white or another color
      x: x,
      y: y,
    );

    // Encode the image as JPEG or BMP and return it
    // final bmp = imag.encodeBmp(resizedImage);
    // return Uint8List.fromList(bmp);
    final jpg = imag.encodeJpg(resizedImage);
    return Uint8List.fromList(jpg);
  }

  static imag.Color _bgGetColor([Color color = Colors.white]) =>
      imag.ColorRgba8(color.red, color.green, color.blue, color.alpha);
}

abstract class ImageFont {
  static imag.BitmapFont readOtherFontZip(List<int> bytes) =>
      imag.readFontZip(bytes);

  static imag.BitmapFont readOtherFont(String font, Uint8List imgBytes) {
    final map = imag.decodeImage(imgBytes)!;
    return imag.readFont(font, map);
  }
}

enum OpenSansFont {
  black(path: "assets/fonts/OpenSans-Regular-Black.ttf.zip"),
  white(path: "assets/fonts/OpenSans-Regular-White.ttf.zip");

  final String path;
  const OpenSansFont({required this.path});
}

enum WatermarkSize {
  extraSmall(dimensionWidth: 2160, dimensionHeight: 3840),
  small(dimensionWidth: 1440, dimensionHeight: 2560),
  medium(dimensionWidth: 1080, dimensionHeight: 1920),
  large(dimensionWidth: 720, dimensionHeight: 1280),
  extraLarge(dimensionWidth: 540, dimensionHeight: 960),
  ;

  final int dimensionWidth;
  final int dimensionHeight;
  const WatermarkSize(
      {required this.dimensionWidth, required this.dimensionHeight});
}
