import 'package:flutter/services.dart';

class MalaysianMoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final String formattedText = _formatText(newValue.text, oldValue.text);
    return newValue.copyWith(
      text: formattedText,
      selection: updateCursorPosition(newValue, formattedText),
    );
  }

  String _formatText(String newvalue, String oldValue) {
    String formattedString = '0.00';
    final cleanNewText = newvalue.replaceAll('.', '');
    RegExp removeLeadingZero = RegExp(r'^0+(?!$)');
    final nonZeroCleanText = cleanNewText.replaceAll(removeLeadingZero, '');

    formattedString = nonZeroCleanText.padLeft(3, '0');
    final secondLastDigit = formattedString.substring(
        formattedString.length - 2, formattedString.length - 1);
    final lastDigit = formattedString.substring(formattedString.length - 1);

    formattedString =
        '${formattedString.substring(0, formattedString.length - 2)}.$secondLastDigit$lastDigit';

    return formattedString;
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  TextSelection updateCursorPosition(
      TextEditingValue newValue, String formattedText) {
    final cursorOffset = newValue.selection.baseOffset;
    final formattedCursorOffset =
        formattedText.length - (newValue.text.length - cursorOffset);
    return newValue.selection.copyWith(
      baseOffset: formattedCursorOffset,
      extentOffset: formattedCursorOffset,
    );
  }
}

class MalaysianPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formatted = formatMalaysianPhoneNumber(phoneNo: newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      ),
    );
  }
}

String formatMalaysianPhoneNumber(
    {String prefix = "+60", required String phoneNo}) {
  // Remove any non-digit characters from the user input
  String cleanNumber = phoneNo.replaceAll(RegExp(r'[^\d]'), '');

  // Check if the clean number has a valid length (9 or 10 digits)
  if (cleanNumber.length < 9 || cleanNumber.length > 11) {
    // Handle invalid input
    return "Invalid input";
  }

  // If the number doesn't start with "0", add it
  if (prefix.contains('+60')) {
    if (!cleanNumber.startsWith("0")) {
      cleanNumber = "0$cleanNumber";
    }
  }
  // Add the +60 prefix to the cleaned number
  String formattedNumber = "$prefix${cleanNumber.substring(1)}";

  return formattedNumber;
}
