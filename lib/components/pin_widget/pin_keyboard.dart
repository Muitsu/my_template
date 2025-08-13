import 'package:flutter/material.dart';

class PinKeyboard extends StatefulWidget {
  final Color? textColor;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;
  final Function(String) onKeyPressed;
  final Function() onBackspacePressed;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  const PinKeyboard(
      {super.key,
      required this.onKeyPressed,
      required this.onBackspacePressed,
      this.mainAxisSpacing = 8.0,
      this.crossAxisSpacing = 8.0,
      this.textColor = Colors.white,
      this.bgColor,
      this.padding = const EdgeInsets.all(40.0)});

  @override
  State<PinKeyboard> createState() => _PinKeyboardState();
}

class _PinKeyboardState extends State<PinKeyboard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: widget.mainAxisSpacing,
      crossAxisSpacing: widget.crossAxisSpacing,
      physics: const NeverScrollableScrollPhysics(),
      padding: widget.padding,
      shrinkWrap: true,
      children: List.generate(12, (index) {
        if (index == 9) {
          return Container();
        } else if (index == 11) {
          return _pinButton(
            onPressed: widget.onBackspacePressed,
            size: size,
            child: Icon(Icons.backspace, color: widget.textColor),
          );
        }

        return _pinButton(
          onPressed: () => widget.onKeyPressed(
              (index.toString() == '10' ? 0 : index + 1).toString()),
          size: size,
          child: Text(
            index.toString() == '10' ? '0' : '${index + 1}',
            style: TextStyle(fontSize: 24.0, color: widget.textColor),
          ),
        );
      }),
    );
  }

  Padding _pinButton(
      {required void Function()? onPressed,
      required Widget? child,
      required Size size}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.bgColor ?? widget.textColor!.withValues(alpha: 0.2),
          shadowColor: Colors.transparent,
          shape: const CircleBorder(),
        ),
        child: child,
      ),
    );
  }
}
