import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/donor_available_request_list.dart';
import 'package:mym_raktaveer_frontend/widgets/request_list_page.dart';

class DonorAvailableRequest extends StatefulWidget {
  const DonorAvailableRequest({super.key});

  @override
  State<DonorAvailableRequest> createState() => _RequestListState();
}

class _RequestListState extends State<DonorAvailableRequest> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Separate column for back icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Request Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              const Expanded(
                child: DonorAvailableRequestList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
