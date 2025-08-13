import 'package:flutter/material.dart';

class FadeBottomMask extends StatelessWidget {
  final Widget child;
  final double fadeHeight;
  final double startFade; // 0.0 to 1.0 (e.g., 0.7 means fade starts at 70%)

  const FadeBottomMask({
    super.key,
    required this.child,
    this.fadeHeight = 1.0,
    this.startFade = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.white,
            Colors.transparent,
          ],
          stops: [startFade, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
