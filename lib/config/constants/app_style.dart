import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle headerStyle({Color color = Colors.black, double size = 25}) {
    return _textStyle(color, size, FontWeight.bold, FontStyle.normal);
  }

  static TextStyle headerStyle2({Color color = Colors.black}) {
    return _textStyle(color, 30, FontWeight.bold, FontStyle.normal);
  }

  static TextStyle navigateTitleStyle({Color color = Colors.black}) {
    return _textStyle(color, 20, FontWeight.bold, FontStyle.normal);
  }

  static TextStyle titleStyle(
      {Color color = Colors.black,
      FontWeight fontWeight = FontWeight.w400,
      double? fontsize,
      FontStyle fontStyle = FontStyle.normal}) {
    return _textStyle(color, fontsize ?? 16, fontWeight, fontStyle);
  }

  static TextStyle hintStyle() {
    return _textStyle(
        const Color(0xffA2A0A0), 16, FontWeight.normal, FontStyle.normal);
  }

  static TextStyle labelStyle(
      {Color color = Colors.black,
      double fontSize = 18,
      FontWeight fontWeight = FontWeight.normal,
      FontStyle fontStyle = FontStyle.normal}) {
    return _textStyle(color, fontSize, fontWeight, fontStyle);
  }

  static TextStyle labelStyle2(
      {Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal,
      FontStyle fontStyle = FontStyle.normal}) {
    return _textStyle(color, 16, fontWeight, fontStyle);
  }

  static TextStyle labelStyle13(
      {Color color = Colors.black,
      double? size,
      FontWeight fontWeight = FontWeight.normal,
      FontStyle fontStyle = FontStyle.normal}) {
    return _textStyle(color, size ?? 13, fontWeight, fontStyle);
  }

  static TextStyle labelStyle12(
      {Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal,
      FontStyle fontStyle = FontStyle.normal}) {
    return _textStyle(color, 12, fontWeight, fontStyle);
  }

  static TextStyle labelStyle10(
      {Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal,
      FontStyle fontStyle = FontStyle.normal}) {
    return _textStyle(color, 10, fontWeight, fontStyle);
  }

  static TextStyle labelStyle14(
      {Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal,
      FontStyle fontStyle = FontStyle.normal}) {
    return _textStyle(color, 14, fontWeight, fontStyle);
  }

  static TextStyle bottomTabLabelStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.normal}) {
    return _textStyle(color, 12, fontWeight, FontStyle.normal);
  }

  static TextStyle linkStyle(
      {TextDecoration decoration = TextDecoration.underline}) {
    return TextStyle(
      fontFamily: 'Arial',
      fontSize: 16,
      color: Colors.blue,
      decoration: decoration,
      decorationColor: Colors.blue,
      decorationThickness: 1.0,
      decorationStyle: TextDecorationStyle.solid,
    );
  }

  static TextStyle buttonLabelStyle(
      {Color color = Colors.white,
      FontWeight fontWeight = FontWeight.bold,
      double fontsize = 14}) {
    return _textStyle(color, fontsize, fontWeight, FontStyle.normal);
  }
}

TextStyle _textStyle(
    Color color, double size, FontWeight fontWeight, FontStyle fontStyle) {
  return TextStyle(
      fontFamily: 'Arial',
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
      fontStyle: fontStyle);
}

LinearGradient get appGradient {
  return const LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    tileMode: TileMode.mirror,
    colors: [
      Color(0xFF514A9D),
      Color(0xFF24C6DC),
    ],
  );
}

class CustomOutlineInputBorder extends OutlineInputBorder {
  CustomOutlineInputBorder.roundLine()
      : super(
          borderSide: const BorderSide(color: Color(0xff707070), width: 0.25),
          borderRadius: BorderRadius.circular(10.0),
        );
  const CustomOutlineInputBorder.underline()
      : super(
          borderSide: const BorderSide(color: Color(0xFFA2A0A0), width: 0.25),
        );
}

class CustomUnderlineInputBorder extends UnderlineInputBorder {
  const CustomUnderlineInputBorder.transparent()
      : super(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        );
  const CustomUnderlineInputBorder.underline()
      : super(
          borderSide: const BorderSide(color: Color(0xFFA2A0A0), width: 1),
        );
}

class CustomBoxDecoration extends BoxDecoration {
  CustomBoxDecoration.topRound(
      {Color color = Colors.white, double radius = 20.0})
      : super(
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius)),
        );

  CustomBoxDecoration.topLine({Color color = Colors.white})
      : super(
          color: color,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0)),
          border: Border.all(color: const Color(0xFF707070), width: 0.25),
        );

  CustomBoxDecoration.topRoundLine({Color color = Colors.white})
      : super(
          color: color,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          border: Border.all(color: const Color(0xFF707070), width: 0.25),
        );

  CustomBoxDecoration.roundLine(
      {double radius = 10.0,
      bool withShadow = false,
      bool withLine = true,
      Color color = Colors.white,
      Color? lineColor,
      double width = 0.25})
      : super(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
              color: withLine
                  ? lineColor ?? const Color(0xFF707070)
                  : Colors.transparent,
              width: width),
          boxShadow: withShadow
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        );

  CustomBoxDecoration.roundShadow(
      {Color? color = Colors.white, double radius = 10.0})
      : super(
          borderRadius: BorderRadius.circular(radius),
          color: color ?? Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        );
  CustomBoxDecoration.roundTop(
      {Color? color = Colors.white, double radius = 12.0})
      : super(
          borderRadius: BorderRadius.circular(radius),
          color: color ?? Colors.white,
        );
  CustomBoxDecoration.textFieldBtn({Color? color, double radius = 8})
      : super(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(radius)),
          color: color ?? Colors.black,
        );

  CustomBoxDecoration.shadow({Color color = Colors.white})
      : super(
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 10,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        );

  CustomBoxDecoration.round(
      {Color color = Colors.transparent, double radius = 10.0})
      : super(
          borderRadius: BorderRadius.circular(radius),
          color: color,
        );

  CustomBoxDecoration.circleLine()
      : super(
          // color: const Color(0xFFA2A0A0),
          border: Border.all(color: const Color(0xFF707070), width: 0.25),
          shape: BoxShape.circle,
        );

  const CustomBoxDecoration.circleFill(Color? color)
      : super(
          color: color ?? Colors.grey,
          shape: BoxShape.circle,
        );

  const CustomBoxDecoration.underline()
      : super(
          border: const Border(
            bottom: BorderSide(
              color: Color(0xFFA2A0A0),
              width: 1.0,
            ),
          ),
        );
}

class CustomShader extends ShaderMask {
  const CustomShader.btmNavBar({
    super.key,
    Widget? icon,
    Shader Function(Rect)? shaderCallback,
  }) : super(
          shaderCallback: shaderCallback ?? _defaultShader,
          child: icon,
        );

  static Shader _defaultShader(Rect bounds) {
    return appGradient.createShader(bounds);
  }
}
