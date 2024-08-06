import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

//Combination of 2 packages
class FileImagePicker {
  static Future<XFile?> onPickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result == null) return null;
    final f = result.files.single;
    return XFile(f.path!, name: f.name, bytes: f.bytes, length: f.size);
  }

  static Future<XFile?> onPickCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  static Future<XFile?> onPickImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  static Future<Uint8List?> toUint8List(XFile file) async {
    return ImageConverter(imgFile: file).toUint8List();
  }
}

class ImageConverter {
  final XFile imgFile;
  ImageConverter({required this.imgFile});

  String getMimeType() {
    bool isPdf = imgFile.path.endsWith('.pdf');
    return imgFile.mimeType ?? (isPdf ? 'application/pdf' : 'image/jpeg');
  }

  String getBase64() {
    final file = File(imgFile.path);
    final fileBytes = file.readAsBytesSync();
    return base64Encode(fileBytes);
  }

  static Future<XFile> toXfile(
      {required Uint8List bytes,
      required String mimeType,
      String? fileName}) async {
    final tempDir = await getTemporaryDirectory();
    final tempName = fileName ?? "attachment.${mimeType.split("/").last}";
    final tempPath = path.join(tempDir.path, tempName);

    final tempFile = await File(tempPath).writeAsBytes(bytes);
    return XFile(tempFile.path, mimeType: mimeType, name: tempName);
  }

  Future<Uint8List?> toUint8List() async {
    bool isDoc = isDocument(imgFile.path);
    if (isDoc) {
      dev.log("Document cant to convert to bytes", name: "File Picker");
      return null;
    }
    try {
      return await imgFile.readAsBytes();
    } catch (e) {
      dev.log("File failed to convert to bytes", name: "File Picker");
      return null;
    }
  }

  static bool isDocument(String path) {
    final documentExtensions = [
      '.pdf',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
      '.ppt',
      '.pptx',
      '.odt',
      '.ods',
      '.odp',
      '.txt',
      '.rtf'
    ];
    return documentExtensions
        .any((extension) => path.toLowerCase().endsWith(extension));
  }

  static bool isImage(String path) {
    final imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.svg',
      '.tiff',
      '.webp'
    ];
    return imageExtensions
        .any((extension) => path.toLowerCase().endsWith(extension));
  }
}
