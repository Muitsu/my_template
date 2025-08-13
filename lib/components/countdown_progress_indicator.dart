import 'dart:async';

import 'package:flutter/material.dart';

class CountdownProgressIndicator extends StatefulWidget {
  final DateTime startDateTime;
  final DateTime endDateTime;
  final double width;
  final double height;
  final double strokeWidth;
  final Color inidicatorBgColor;
  final Color? frontColor;
  final Color? bgColor;

  const CountdownProgressIndicator({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
    this.width = 160,
    this.height = 160,
    this.strokeWidth = 12,
    this.inidicatorBgColor = const Color(0xFFDBDBF0),
    this.frontColor,
    this.bgColor,
  });

  @override
  CountdownProgressIndicatorState createState() =>
      CountdownProgressIndicatorState();
}

class CountdownProgressIndicatorState
    extends State<CountdownProgressIndicator> {
  late Timer _timer;
  late Duration _duration;
  double progress = 1;
  @override
  void initState() {
    super.initState();
    _duration = widget.endDateTime.difference(widget.startDateTime);
    startCounter();
  }

  void startCounter() {
    if (DateTime.now().isAfter(widget.endDateTime)) {
      progress = 0;
      _timer = Timer(Duration.zero, () {});
      _timer.cancel();
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = widget.endDateTime.difference(DateTime.now());
        progress = (_duration.inSeconds /
                widget.endDateTime.difference(widget.startDateTime).inSeconds)
            .abs();
        if (_duration <= Duration.zero) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:
            BoxDecoration(color: widget.bgColor, shape: BoxShape.circle),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: widget.height,
                  width: widget.width,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: widget.strokeWidth,
                    color: widget.inidicatorBgColor,
                  ),
                ),
                SizedBox(
                  height: widget.height,
                  width: widget.width,
                  child: CircularProgressIndicator(
                    value: 1 - progress,
                    strokeWidth: 12,
                    color: widget.frontColor,
                  ),
                ),
              ],
            ),
            // SizedBox(height: 10),
            // Text(
            //     'Time remaining: ${_duration.inDays} days, ${_duration.inHours.remainder(24)} hours, ${_duration.inMinutes.remainder(60)} minutes, ${_duration.inSeconds.remainder(60)} seconds'),
            // Text('Progress: $progressString'),
          ],
        ),
      ),
    );
  }
}
