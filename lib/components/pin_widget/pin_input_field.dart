import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinNumTextField extends StatelessWidget {
  final String label;
  final int pinLength;
  final bool readOnly;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool obscureText;
  final void Function(String pinCode)? onChanged;
  final Color? backgorundColor;
  final Color? textColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String pin)? onCompleted;
  const PinNumTextField(
      {super.key,
      required this.label,
      this.controller,
      this.readOnly = false,
      this.obscureText = false,
      this.pinLength = 6,
      this.onCompleted,
      this.validator,
      this.fontSize = 20,
      this.backgorundColor,
      this.width,
      this.height,
      this.onChanged,
      this.textColor = const Color.fromRGBO(30, 60, 87, 1)});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: width ?? 56,
      height: height ?? 56,
      textStyle: TextStyle(
          fontFamily: "Roboto",
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: backgorundColor ?? const Color(0xFFF4F4F4),
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(8),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Pinput(
          // pinContentAlignment: Alignment.topCenter,
          onChanged: onChanged,
          length: pinLength,
          readOnly: readOnly,
          obscureText: obscureText,
          // obscuringCharacter: ',
          defaultPinTheme: defaultPinTheme,
          controller: controller,
          focusedPinTheme: focusedPinTheme,
          validator: validator,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          onCompleted: onCompleted,
        ),
      ],
    );
  }
}
