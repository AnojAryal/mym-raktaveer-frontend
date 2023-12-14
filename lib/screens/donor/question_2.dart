import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';
import 'package:mym_raktaveer_frontend/screens/donor/blood_donation_journey.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/models/personal_detail_model.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({
    super.key,
    required this.personalDetailModel,
  });

  final PersonalDetailModel personalDetailModel;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  DateTime? _selectedDonationDate;
  DateTime? _selectedReceivedDate;

  @override
  Widget build(BuildContext context) {
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
              children: [
                _buildAppBar(),
                const SizedBox(height: 14.0),
                _buildNoteContainer(),
                const SizedBox(height: 20.0),
                _buildDateInput(
                  label: 'Last Blood Donation Date',
                  onSelectDate: (date) {
                    setState(() {
                      _selectedDonationDate = date;
                    });
                  },
                  selectedDate: _selectedDonationDate,
                ),
                const SizedBox(height: 20.0),
                _buildDateInput(
                  label: 'Last Blood Received Date',
                  onSelectDate: (date) {
                    setState(() {
                      _selectedReceivedDate = date;
                    });
                  },
                  selectedDate: _selectedReceivedDate,
                ),
                const SizedBox(height: 20.0),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 40.0,
      // Add child components (e.g., image, back button) here
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
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInput({
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
            fontWeight: FontWeight.normal,
          ),
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

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationButton(
            text: 'Previous',
            onPressed: () => Navigator.pop(context),
          ),
          _buildNavigationButton(
            text: 'Next',
            onPressed: () {
              updateModel();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BloodDonationJourneyPage(
                    personalDetailModel: widget.personalDetailModel,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        fixedSize: const Size(100, 40),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  void updateModel() {
    widget.personalDetailModel.lastDonationDate = _selectedDonationDate;
    widget.personalDetailModel.lastDonationReceived = _selectedReceivedDate;
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
