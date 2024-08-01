import 'dart:async';

import 'package:flutter/material.dart';

class ChangingText extends StatefulWidget {
  final List<String> textList;
  final Duration? duration;
  final double? fontSize;
  const ChangingText(
      {super.key, required this.textList, this.duration, this.fontSize = 16});

  @override
  State<ChangingText> createState() => _ChangingTextState();
}

class _ChangingTextState extends State<ChangingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_animationController);

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(
        widget.duration ?? const Duration(milliseconds: 300), _changeText);
  }

  void _changeText() {
    setState(() {
      _currentIndex++;
      if (_currentIndex >= widget.textList.length) {
        _currentIndex = 0;
      }
      _animationController.reset();
      _animationController.forward();
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        widget.textList[_currentIndex],
        textAlign: TextAlign.center,
        maxLines: 1,
        style: TextStyle(fontSize: widget.fontSize),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
