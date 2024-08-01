import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime startDateTime;
  final DateTime endDateTime;
  final TextStyle? style;
  final void Function()? onEndTimer;
  const CountdownTimer(
      {super.key,
      required this.startDateTime,
      required this.endDateTime,
      this.onEndTimer,
      this.style});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _duration = const Duration();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    final now = DateTime.now();
    if (now.isAfter(widget.endDateTime)) {
      if (widget.onEndTimer != null) {
        setState(() {
          widget.onEndTimer!();
        });
      }
      timer.cancel();
      return;
    }
    setState(() {
      _duration = widget.endDateTime.difference(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');

    return Text('$hours:$minutes:$seconds', style: widget.style);
  }
}
