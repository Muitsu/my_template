import 'package:flutter/material.dart';

class ElevatedButton3d extends StatefulWidget {
  const ElevatedButton3d({super.key});

  @override
  State<ElevatedButton3d> createState() => _ElevatedButton3dState();
}

class _ElevatedButton3dState extends State<ElevatedButton3d> {
  double _btmPadding = 6;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _btmPadding = 0),
      onTapUp: (_) => setState(() => _btmPadding = 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.only(bottom: _btmPadding),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(10)),
            child: const Text("CLICK ME")),
      ),
    );
  }
}
