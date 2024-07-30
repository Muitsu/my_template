import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar {
  final BuildContext context;
  final Key? key;
  CustomFlushbar({required this.context, this.key});
  factory CustomFlushbar.of(BuildContext context, {Key? key}) {
    return CustomFlushbar(context: context, key: key);
  }
  Future<dynamic> showSuccess({required String msg}) async {
    return Flushbar(
      message: msg,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.check_circle,
        size: 28.0,
        color: Color.fromARGB(255, 54, 247, 128),
      ),
      duration: const Duration(milliseconds: 1300),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  Future<dynamic> showFailed({required String msg}) async {
    return Flushbar(
      message: msg,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.cancel,
        size: 28.0,
        color: Colors.red,
      ),
      duration: const Duration(milliseconds: 1300),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  Future<dynamic> showWarning({required String msg}) async {
    return Flushbar(
      isDismissible: false,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(milliseconds: 1300),
      icon: const Icon(
        Icons.error,
        color: Colors.amber,
      ),
      message: msg,
    ).show(context);
  }

  Future<dynamic> showInfo({required String msg}) async {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(milliseconds: 1300),
      icon: const Icon(
        Icons.info,
        color: Colors.blue,
      ),
      message: msg,
    ).show(context);
  }

  Future<dynamic> showCustom({required String msg, Widget? icon}) async {
    return Flushbar(
      message: msg,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: icon,
      duration: const Duration(milliseconds: 1300),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
