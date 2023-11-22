import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Red Container (1/4 of the screen size)
        Container(
          color: Colors.red,
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 4,
        ),

        // White Container Below Red Container
        Positioned.fill(
          top: MediaQuery.of(context).size.height / 4,
          child: Container(
            color: Colors.white,
          ),
        ),

        // Child widget (e.g., login page, registration page, home page, etc.)
        child,
      ],
    );
  }
}
