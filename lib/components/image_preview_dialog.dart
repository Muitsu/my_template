import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePreviewDialog extends StatefulWidget {
  final Uint8List image;
  final String title;
  final void Function() onDelete;
  final bool canDelete;
  const ImagePreviewDialog(
      {super.key,
      required this.image,
      required this.title,
      required this.canDelete,
      required this.onDelete});

  @override
  State<ImagePreviewDialog> createState() => _ImagePreviewDialogState();

  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (_) => this,
    );
  }
}

class _ImagePreviewDialogState extends State<ImagePreviewDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        color: Colors.black.withOpacity(0.3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
            ScaleTransition(
              scale: CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ),
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InteractiveViewer(
                        child: AspectRatio(
                          aspectRatio: 10 / 10,
                          child: Image.memory(widget.image),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconButton(
                  iconData: Icons.close_rounded,
                  onTap: () => Navigator.pop(context),
                  title: "Kembali",
                ),
                SizedBox(width: widget.canDelete ? 30 : 0),
                Visibility(
                  visible: widget.canDelete,
                  child: _iconButton(
                    isFilled: true,
                    iconData: Icons.delete,
                    onTap: widget.onDelete,
                    title: "Buang",
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _iconButton(
      {required String title,
      bool isFilled = false,
      required IconData iconData,
      required void Function() onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: isFilled ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white)),
            child: Icon(
              iconData,
              color: isFilled ? Colors.black : Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
