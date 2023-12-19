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
          const MyProgressBar(currentPage: 3, totalPages: 4),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Health Conditions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16.0),
                _buildNoteContainer(),
                const SizedBox(height: 16.0),
                _buildHealthConditionsList(
                    ref, personalDetail.healthConditions),
                const SizedBox(height: 16.0),
                _buildNavigationButtons(context, ref),
              ],
            ),
          ),
        ],
      ),
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
              ),
            ),
            TextSpan(
              text:
                  'Please indicate if any of the following apply to you by ticking the relevant options.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthConditionsList(
      WidgetRef ref, Map<String, bool>? healthConditions) {
    return Expanded(
      child: ListView.builder(
        itemCount: HealthConditionsModel.conditions.length,
        itemBuilder: (context, index) {
          String condition = HealthConditionsModel.conditions[index];
          return CheckboxListTile(
            title: Text(condition),
            value: healthConditions?[condition] ?? false,
            onChanged: (bool? newValue) {
              Map<String, bool> updatedConditions = {...healthConditions ?? {}};
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Previous'),
        ),
        ElevatedButton(
          onPressed: () => _handleSubmit(context, ref),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    final personalDetail = ref.read(personalDetailProvider);
    final BloodDonationService service = BloodDonationService();
    var response = await service.sendPersonalDataToApi(personalDetail);

    if (response.success) {
      Navigator.of(context).pushNamed("/final-question");
    } else {
      // Handle error, show an error dialog or a snackbar
    }
  }
}
