import 'package:flutter/material.dart';

import 'custom_textfield.dart';

class DatePickerField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final Color? fillColor;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final TextEditingController controller;
  final bool setDefaultVal;
  final void Function(DateTime picked) onPicked;

  const DatePickerField({
    super.key,
    this.title,
    this.hintText,
    this.fillColor,
    this.initialDate,
    required this.controller,
    required this.onPicked,
    this.firstDate,
    this.lastDate,
    this.setDefaultVal = true,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? initialDate;
  @override
  void initState() {
    super.initState();
    if (widget.setDefaultVal) {
      initialDate = widget.initialDate ?? DateTime.now();
      widget.controller.text = formatDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      title: widget.title,
      hintText: widget.hintText,
      controller: widget.controller,
      fillColor: widget.fillColor ?? Colors.white,
      suffixIcon: Icons.keyboard_arrow_down,
      readOnly: true,
      onTap: () async {
        final currDate = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: widget.firstDate ?? currDate,
          lastDate: widget.lastDate ?? currDate.add(const Duration(days: 3650)),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(),
              child: child!,
            );
          },
        );
        if (picked == null) return;
        initialDate = picked;
        widget.controller.text = formatDate();
        widget.onPicked(picked);
        setState(() {});
      },
    );
  }

  String formatDate() {
    return initialDate.toString();
  }
}
