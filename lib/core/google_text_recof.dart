import 'dart:typed_data';
import 'package:image/image.dart' as imag;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GoogleTextRecog {
  //Process text
  static Future<List<String>> rercognizedText(
      {required Uint8List bytes}) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final croppedImg = cropImage(bytes);
    final path = await createTempPath(croppedImg);
    final inputImage = InputImage.fromFilePath(path);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    String text = recognizedText.text;
    return text.split("\n").toList();
  }

  //Crop image for better result
  static Uint8List cropImage(Uint8List bytes) {
    imag.Image? image = imag.decodeImage(bytes);
    int height = (image!.height / 2.8).round();
    final cropImg =
        imag.copyCrop(image, x: 0, y: height, width: image.width, height: 460);
    final bmp = imag.encodeBmp(cropImg);
    return Uint8List.fromList(bmp);
  }

  static Future<String> createTempPath(Uint8List uint8) async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/trimmed.png').create();
    file.writeAsBytesSync(uint8);
    return file.path;
  }
}
