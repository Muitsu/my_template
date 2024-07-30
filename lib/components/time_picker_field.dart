import 'package:flutter/material.dart';

import 'custom_textfield.dart';

class TimePickerField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final Color? fillColor;
  final TimeOfDay? initialTime;
  final TextEditingController controller;
  final bool setDefaultVal;
  final void Function(TimeOfDay picked) onPicked;
  final bool is24hrFormat;
  const TimePickerField({
    super.key,
    this.title,
    this.hintText,
    this.fillColor,
    this.initialTime,
    this.is24hrFormat = false,
    this.setDefaultVal = true,
    required this.controller,
    required this.onPicked,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  late TimeOfDay initialTime;
  @override
  void initState() {
    super.initState();
    initialTime = widget.initialTime ?? TimeOfDay.now();
    if (widget.setDefaultVal) {
      widget.controller.text = getTimeToText();
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
        final picked = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(),
              child: child!,
            );
          },
        );
        if (picked == null) return;
        initialTime = picked;
        widget.controller.text = getTimeToText();
        widget.onPicked(picked);
        setState(() {});
      },
    );
  }

  String getTimeToText() {
    return "${_convertTo12Hour(initialTime.hour)} : ${_getMinute(initialTime.minute)} : ${_getAmPm(initialTime.hour)} ";
  }

  int _convertTo12Hour(int hour) {
    if (widget.is24hrFormat) return hour;
    if (hour == 0) {
      return 12; // Midnight
    } else if (hour > 12) {
      return hour - 12;
    } else {
      return hour;
    }
  }

  String _getMinute(int hour) {
    if (hour < 10) {
      return "0$hour";
    }
    return hour.toString();
  }

  String _getAmPm(int hour) {
    return hour >= 12 ? 'PM' : 'AM';
  }
}
