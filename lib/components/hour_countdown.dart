import 'package:flutter/material.dart';
import 'dart:async';

import 'package:my_template/core/extensions/datetime_extension.dart';

class HourCountdown extends StatefulWidget {
  final List<DateTime> times;

  const HourCountdown({super.key, required this.times});

  @override
  HourCountdownState createState() => HourCountdownState();
}

class HourCountdownState extends State<HourCountdown> {
  Timer? _timer;
  String _timeRemaining = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeRemaining();
    });
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();

    if (_currentIndex < widget.times.length - 1) {
      final startTime = widget.times[_currentIndex];
      final endTime = widget.times[_currentIndex + 1];

      if (now.isBefore(startTime)) {
        _timeRemaining = 'Event hasn\'t started yet';
      } else if (now.isAfter(endTime)) {
        _currentIndex++;
        _updateTimeRemaining(); // Move to next interval
      } else {
        final remainingDuration = endTime.difference(now);
        setState(() {
          _timeRemaining =
              _formatDuration(remainingDuration, endTime.isNextDay());
        });
      }
    } else {
      _timeRemaining = 'Please fetch new data / Not found';
      _timer?.cancel();
      setState(() {});
    }
  }

  String _formatDuration(Duration duration, bool isNextDay) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (isNextDay && hours > 5) {
      return "Take a rest for Subuh";
    }
    if (hours > 0) {
      return '$hours hours $minutes minutes';
    } else {
      return '$minutes minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeRemaining,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
