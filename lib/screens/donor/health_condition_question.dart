// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/blood_donation_provider.dart';
import 'package:mym_raktaveer_frontend/models/health_condition_model.dart';
import 'package:mym_raktaveer_frontend/services/blood_donation_service.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';

class HealthConditionQuestion extends ConsumerWidget {
  const HealthConditionQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalDetail = ref.watch(personalDetailProvider);

    return Background(
      child: Stack(
        children: [
          const MyProgressBar(
            currentPage: 3,
            totalPages: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppTitle(),
                const SizedBox(height: 16.0),
                _buildNoteContainer(),
                _buildHealthConditionsList(
                  ref,
                  personalDetail.healthConditions,
                ),
                const SizedBox(height: 16.0),
                _buildNavigationButtons(context, ref),
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
          'Health Conditions',
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
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7DA),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: 'Note : ',
              style: TextStyle(
                color: Color(0xFFFD1A00),
                fontSize: 13,
              ),
            ),
            TextSpan(
              text:
                  'Please indicate if any of the following apply to you by ticking the relevant options.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthConditionsList(
    WidgetRef ref,
    Map<String, bool>? healthConditions,
  ) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4,
        ),
        itemCount: HealthConditionsModel.conditions.length,
        itemBuilder: (context, index) {
          String condition = HealthConditionsModel.conditions[index];
          bool isChecked = healthConditions?[condition] ?? false;

          return CheckboxListTile(
            title: Text(
              condition,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            value: isChecked,
            onChanged: (bool? newValue) {
              Map<String, bool> updatedConditions = {
                ...healthConditions ?? {},
              };
              updatedConditions[condition] = newValue ?? false;
              ref
                  .read(personalDetailProvider.notifier)
                  .updateHealthConditions(updatedConditions);
            },
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          onPressed: () => _handleSubmit(context, ref),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFFFD1A00)), // FD1A00 color
            fixedSize: MaterialStateProperty.all<Size>(
                const Size(120.0, 40.0)), // Width and height
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    final personalDetail = ref.read(personalDetailProvider);
    final BloodDonationService service = BloodDonationService();
    var response = await service.sendPersonalDataToApi(personalDetail, ref);

    if (response.success) {
      Navigator.of(context).pushNamed("/final-question");
    } else {
      // Handle error, show an error dialog or a snackbar
    }
  }
}

class HealthConditionCheckbox extends StatelessWidget {
  final String condition;
  final bool isChecked;
  final void Function(bool?) onChanged;

  const HealthConditionCheckbox({
    super.key,
    required this.condition,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 20,
            child: Text(
              condition,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
