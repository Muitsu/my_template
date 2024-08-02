import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  final Widget child;
  final Widget? dragWidget;
  final Offset offset;
  const DraggableWidget(
      {super.key,
      required this.child,
      this.offset = Offset.zero,
      this.dragWidget});

  @override
  DraggableWidgetState createState() => DraggableWidgetState();
}

class DraggableWidgetState extends State<DraggableWidget> {
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _offset = widget.offset == const Offset(0, 0)
            ? _calculateInitialOffset(context)
            : widget.offset;
      });
    });
  }

  Offset _calculateInitialOffset(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    const padding = 16.0; // Padding from the edges of the screen
    const widgetSize = 100.0; // Size of the draggable widget

    return Offset(
      screenSize.width - widgetSize - padding,
      screenSize.height - widgetSize - padding - mediaQuery.padding.bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: <Widget>[
            widget.child,
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: _offset.dx,
              top: _offset.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _offset = Offset(
                      _offset.dx + details.delta.dx,
                      _offset.dy + details.delta.dy,
                    );
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    // Ensure the container stays within the screen boundaries
                    double newX = _offset.dx;
                    double newY = _offset.dy;

                    if (newX < 0) {
                      newX = 0;
                    } else if (newX + 100 > constraints.maxWidth) {
                      newX = constraints.maxWidth - 100;
                    }

                    if (newY < 0) {
                      newY = 0;
                    } else if (newY + 100 > constraints.maxHeight) {
                      newY = constraints.maxHeight - 100;
                    }

                    _offset = Offset(newX, newY);
                  });
                },
                child: widget.dragWidget ??
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12)),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
