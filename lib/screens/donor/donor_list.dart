import 'package:flutter/material.dart';
import '../../widgets/background.dart';


class DonorList extends StatefulWidget {
  final Map<String, dynamic> response;

  const DonorList({super.key, required this.response});

  @override
  State<DonorList> createState() => _DonorListState();
}

class _DonorListState extends State<DonorList> {
  @override
  Widget build(BuildContext context) {
    return const Background(
      child: Stack(
        children: [
          Text(
            'Your request has been approved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}