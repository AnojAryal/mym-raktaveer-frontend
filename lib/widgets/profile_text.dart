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
        children: [
          TextSpan(
            text: '$label : ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const WidgetSpan(
              child: SizedBox(
            width: 12,
          )),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
