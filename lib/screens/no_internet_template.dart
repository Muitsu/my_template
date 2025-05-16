import 'dart:ui';

import 'package:flutter/material.dart';

class NoInternetTemplate extends StatelessWidget {
  const NoInternetTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    container(height: 25),
                    const SizedBox(height: 15),
                    ...List.generate(
                      5,
                      (index) => listDummy(),
                    )
                  ],
                ),
              ),
            ),
          ),
          generateBluredImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                width: double.infinity,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 55,
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "The screen isn't loading.\nPlease check your network connection",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget generateBluredImage() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
      child: Container(
        //you can change opacity with color here(I used black) for background.
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.02)),
      ),
    );
  }

  Widget listDummy() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                container(height: 15),
                const SizedBox(height: 15),
                container(height: 15, width: 180),
                const SizedBox(height: 6),
                container(height: 15, width: 200),
                const SizedBox(height: 6),
                container(height: 15, width: 200),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget container({double height = 100, double width = 100}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
