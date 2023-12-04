import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double circularRadiusPercentage = 10.0;

    return Scaffold(
      body: Stack(
        children: [
          // White Container
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
          ),
          // Red Container
          Container(
            color: Colors.red,
            width: double.infinity,
            height:
                MediaQuery.of(context).size.height * 0.25,
          ),
          // Another container
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.height * 0.04,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width *
                      (circularRadiusPercentage / 230),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
