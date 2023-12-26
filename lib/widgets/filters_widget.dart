import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPopup extends ConsumerStatefulWidget {
  const FilterPopup({super.key});

  @override
  ConsumerState<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends ConsumerState<FilterPopup> {
  double? minAge;
  double? maxAge;
  String selectedBloodType = 'A';
  String selectedRhesusFactor = 'Positive';
  String selectedStatus = 'Pending';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeading('Search Filter', fontSize: 20),
                const SizedBox(height: 16),
                _buildSectionHeading('Age'),
                _buildAgeRangeInput(),
                const SizedBox(height: 16),
                _buildSectionHeading('Blood Type and Rhesus Factor'),
                _buildBloodTypeAndRhesusFactorInputs(),
                const SizedBox(height: 16),
                _buildStatusDropdown(),
                const SizedBox(height: 16),
                _buildApplyFiltersButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(String text, {double? fontSize}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        heading,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildAgeRangeInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Min Age',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            onSaved: (value) {
              minAge = double.tryParse(value!);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Max Age',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            onSaved: (value) {
              maxAge = double.tryParse(value!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBloodTypeAndRhesusFactorInputs() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Blood Type',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedBloodType,
                onChanged: (value) {
                  setState(() {
                    selectedBloodType = value!;
                  });
                },
                items: ['A', 'B', 'AB', 'O'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rhesus Factor',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedRhesusFactor,
                onChanged: (value) {
                  setState(() {
                    selectedRhesusFactor = value!;
                  });
                },
                items: ['Positive', 'Negative'].map((factor) {
                  return DropdownMenuItem<String>(
                    value: factor,
                    child: Text(factor),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: selectedStatus,
          onChanged: (value) {
            setState(() {
              selectedStatus = value!;
            });
          },
          items: ['Pending', 'Completed', 'Accepted'].map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildApplyFiltersButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          Navigator.pop(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text('Apply Filters'),
    );
  }
}
