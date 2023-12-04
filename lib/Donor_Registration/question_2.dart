import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/progress_bar.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/question_3.dart';
import 'package:mym_raktaveer_frontend/background.dart';
import 'package:mym_raktaveer_frontend/personal_detail_model.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.personalDetailModel});

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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                Container(
                  height: 40.0, // Adjust the height as needed
                  // Add child components (e.g., image, back button) here
                ),
                const SizedBox(height: 14.0),
                const Text(
                  'Blood Donation Journey',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7DA),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Note: ',
                      style: TextStyle(
                        color: Colors.red, // Set to red
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
                ),
                const SizedBox(height: 20.0),
                buildDateInput(
                  label: 'Last Blood Donation Date',
                  onSelectDate: (date) {
                    setState(() {
                      _selectedDonationDate = date;
                    });
                  },
                  selectedDate: _selectedDonationDate,
                ),
                const SizedBox(height: 20.0),
                buildDateInput(
                  label: 'Last Blood Received Date',
                  onSelectDate: (date) {
                    setState(() {
                      _selectedReceivedDate = date;
                    });
                  },
                  selectedDate: _selectedReceivedDate,
                ),
                const SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {
                      updateModel();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BloodDonationJourneyPage(
                                personalDetailModel:
                                    widget.personalDetailModel)),
                      );
                      // Handle the 'Next' button click
                      // You can navigate to the next screen or perform any other action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateModel() {
    // Update the PersonalDetailModel with selected dates
    widget.personalDetailModel.lastDonationDate = _selectedDonationDate;
    widget.personalDetailModel.lastDonationReceived = _selectedReceivedDate;
  }

  Widget buildDateInput({
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
