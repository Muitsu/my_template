import 'package:flutter/material.dart';

class PingPongImageScroller extends StatefulWidget {
  final String imageAsset;
  final double speed; // smaller = faster
  final Axis scrollDirection;

  const PingPongImageScroller({
    super.key,
    required this.imageAsset,
    this.speed = 30.0,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  PingPongImageScrollerState createState() => PingPongImageScrollerState();
}

class PingPongImageScrollerState extends State<PingPongImageScroller>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  double? _imageExtent;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.speed.toInt()),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        if (mounted) setState(() {});
      });

    _controller.repeat(reverse: true);
  }

  void _onImageLoaded(ImageInfo imageInfo, bool _) {
    final size = widget.scrollDirection == Axis.horizontal
        ? imageInfo.image.width.toDouble()
        : imageInfo.image.height.toDouble();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _imageExtent = size;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final containerExtent = widget.scrollDirection == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;

        final offset =
            (_imageExtent == null || _imageExtent! <= containerExtent)
                ? 0.0
                : _animation.value * (_imageExtent! - containerExtent);

        return ClipRect(
          child: Stack(
            children: [
              Positioned(
                left: widget.scrollDirection == Axis.horizontal ? -offset : 0,
                top: widget.scrollDirection == Axis.vertical ? -offset : 0,
                child: Image.asset(
                  widget.imageAsset,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (!_imageLoaded && frame != null) {
                      _imageLoaded = true;
                      final imgStream = AssetImage(widget.imageAsset)
                          .resolve(const ImageConfiguration());
                      imgStream.addListener(
                        ImageStreamListener(_onImageLoaded),
                      );
                    }
                    return child;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
