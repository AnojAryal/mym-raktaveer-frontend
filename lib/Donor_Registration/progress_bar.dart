import 'package:flutter/material.dart';

class MyProgressBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const MyProgressBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
  }) ;

  @override
  Widget build(BuildContext context) {
    double progress = currentPage / totalPages;

    double progressBarHeight = MediaQuery.of(context).size.height * 0.02;
    double progressBarPadding = MediaQuery.of(context).size.width * 0.1;

    return Padding(
      padding: EdgeInsets.all(progressBarPadding),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: LinearProgressIndicator(
          backgroundColor: Colors.black,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
          value: progress,
          minHeight: progressBarHeight,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
