import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/blood_donation_provider.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';

class BloodDonationRelatedQuestion extends ConsumerWidget {
  const BloodDonationRelatedQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalDetail = ref.watch(personalDetailProvider);

    return Background(
      child: Stack(
        children: [
          const MyProgressBar(
            currentPage: 2,
            totalPages: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAppTitle(),
                const SizedBox(height: 20.0),
                _buildNoteContainer(),
                const SizedBox(height: 20.0),
                _buildDateInput(
                  context: context,
                  label: 'Last Blood Donation Date',
                  onSelectDate: (date) {
                    ref
                        .read(personalDetailProvider.notifier)
                        .updateDonationDetails(
                            date, personalDetail.lastDonationReceived);
                  },
                  selectedDate: personalDetail.lastDonationDate,
                ),
                const SizedBox(height: 20.0),
                _buildDateInput(
                  context: context,
                  label: 'Last Blood Received Date',
                  onSelectDate: (date) {
                    ref
                        .read(personalDetailProvider.notifier)
                        .updateDonationDetails(
                            personalDetail.lastDonationDate, date);
                  },
                  selectedDate: personalDetail.lastDonationReceived,
                ),
                const SizedBox(height: 20.0),
                _buildNavigationButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 55.0),
        Center(
          child: Text(
            'Mym Raktaveer',
            style: TextStyle(
              color: Color(0xFFFD1A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Blood Donation journey',
          style: TextStyle(
            color: Color(0xFF242323),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteContainer() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7DA),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: RichText(
        text: const TextSpan(
          text: 'Note: ',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12.0,
          ),
          children: [
            TextSpan(
              text:
                  'You can leave the box empty if you haven\'t donated blood recently.',
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInput({
    required BuildContext context,
    required String label,
    required Function(DateTime) onSelectDate,
    DateTime? selectedDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 8.0),
        InkWell(
          onTap: () => _selectDate(context, onSelectDate),
          child: Container(
            height: 40.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                      : '',
                  style: const TextStyle(color: Colors.black),
                ),
                const Icon(Icons.calendar_today, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFFFD1A00)), // FD1A00 color
              fixedSize: MaterialStateProperty.all<Size>(
                  const Size(120.0, 40.0)), // Width and height
            ),
            child: const Text(
              'Previous',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/health-condition');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFFFD1A00)), // FD1A00 color
              fixedSize: MaterialStateProperty.all<Size>(
                  const Size(120.0, 40.0)), // Width and height
            ),
            child: const Text(
              'Next',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onSelectDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      onSelectDate(picked);
    }
  }
}
