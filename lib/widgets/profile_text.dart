import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String label;
  final String value;

  const CustomRichText({
    super.key,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
