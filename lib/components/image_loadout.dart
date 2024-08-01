import 'package:flutter/material.dart';

class ImageLoadout extends StatelessWidget {
  final String url;
  final Widget? errorWidget;
  const ImageLoadout({super.key, required this.url, this.errorWidget});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
              child: Text(
            'Loading...',
            style: TextStyle(
              color: Colors.grey,
            ),
          )),
        );
      },
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ??
          Container(
              color: Colors.grey.shade200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              )),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ));
      },
    );
  }
}
