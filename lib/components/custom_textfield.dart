import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final Color? fillColor;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final String? Function(String? value)? validator;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final AutovalidateMode autovalidateMode;
  final TextStyle errorStyle;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final int? maxLines;
  final bool? enabled;
  final bool addBorder;
  final bool isMandatory;
  const CustomTextField({
    super.key,
    this.title,
    this.fillColor,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.labelStyle,
    this.titleStyle,
    this.hintStyle,
    this.validator,
    this.onTap,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.errorStyle = const TextStyle(height: 0.01),
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.maxLines = 1,
    this.enabled = true,
    this.addBorder = true,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Row(
            children: [
              Text(
                title!,
                style: titleStyle ?? const TextStyle(fontSize: 14),
              ),
              if (isMandatory)
                const Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
        const SizedBox(height: 5),
        TextFormField(
          enabled: enabled,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          validator: validator,
          onTap: onTap,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            hintText: hintText,
            fillColor: fillColor,
            enabledBorder: addBorder
                ? OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFA4A8AD)),
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            contentPadding: contentPadding ??
                const EdgeInsets.only(left: 12.0, right: 12.0),
            labelStyle: labelStyle ??
                const TextStyle(color: Colors.black, fontSize: 18),
            hintStyle: hintStyle ??
                const TextStyle(color: Color(0xffA2A0A0), fontSize: 16),
            prefixIcon: prefixWidget ??
                (prefixIcon != null
                    ? Icon(prefixIcon, color: Colors.grey)
                    : null),
            suffixIcon:
                suffixWidget ?? (suffixIcon != null ? Icon(suffixIcon) : null),
          ),
        ),
      ],
    );
  }
}
