import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/services.dart';

class DocScanner {
  static Future<Uint8List?> openScanner({int bulkImages = 1}) async {
    List<String> pictures;
    try {
      pictures =
          await CunningDocumentScanner.getPictures(noOfPages: bulkImages) ?? [];
      final img = await _toUint8List(pictures.first);
      return img;
    } catch (e) {
      // Handle exception here
      return null;
    }
  }

  static Future<Uint8List> _toUint8List(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  }
}
