import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

class DocScanner {
  static Future<Uint8List?> openScanner({int bulkImages = 1}) async {
    List<String> pictures;
    try {
      DocumentScannerOptions documentOptions = DocumentScannerOptions(
        documentFormat: DocumentFormat.jpeg, // set output document format
        mode: ScannerMode.filter, // to control what features are enabled
        pageLimit: 1, // setting a limit to the number of pages scanned
        isGalleryImport: true, // importing from the photo gallery
      );
      final documentScanner = DocumentScanner(options: documentOptions);
      DocumentScanningResult result = await documentScanner.scanDocument();
      pictures = result.images;
      final img = await _toUint8List(pictures.first);
      return img;
    } catch (e) {
      debugPrint(e.toString());
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
