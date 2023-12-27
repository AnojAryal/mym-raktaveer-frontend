// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Providers/location_Provider.dart';
import '../../models/blood_request_model.dart';
import '../../services/api_service.dart';
import '../../services/blood_request_service.dart';
import '../../services/location_service.dart';
import '../../widgets/background.dart';

class BloodRequestForm extends ConsumerStatefulWidget {
  const BloodRequestForm({
    super.key,
  });

  @override
  ConsumerState<BloodRequestForm> createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends ConsumerState<BloodRequestForm> {
  late ApiService _apiService;
  late BloodRequestService _bloodRequestService;

  _BloodRequestFormState() {
    _apiService = ApiService();
    _bloodRequestService = BloodRequestService(_apiService);
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  File? selectedFile;
  final ImagePicker _picker = ImagePicker();

  String _selectedBloodGroupAbo = 'A';
  String _selectedBloodGroupRh = 'Positive (+ve)';
  String _selectedUrgencyLevel = 'Low';
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _opdNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = ref.watch(locationDataProvider);

    if (locationData != null) {
      _locationController.text = locationData.geoLocation ?? '';
    }

    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(ref),
          _buildBloodRequestFormTitle(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField('Patient Name', _patientNameController),
                  _buildRow(['Age', 'Sex'], [_ageController, _sexController]),
                  _buildTextField('Hospital Name', _hospitalNameController),
                  _buildTextFieldWithIcon(
                    'Location',
                    Icons.location_on,
                    controller: _locationController,
                  ),
                  _buildRow(['Room No.', 'OPD No.'],
                      [_roomNoController, _opdNoController]),
                  _buildBloodGroupDropdown('Blood Group (ABO)'),
                  _buildBloodGroupRhDropdown('Blood Group (RH)'),
                  _buildTextFieldWithFilePicker('Document Upload'),
                  _buildTextField('Description', _descriptionController),
                  _buildUrgencyLevelDropdown(),
                  _buildDateTimePicker('Date and Time'),
                  _buildNumericTextField('Quantity', _quantityController),
                  const SizedBox(height: 16.0),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            ref.read(locationDataProvider.notifier).state;
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildBloodRequestFormTitle() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'Blood Request Form',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: _getTextFieldDecoration(label),
      ),
    );
  }

  InputDecoration _getTextFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    );
  }

  Widget _buildTextFieldWithIcon(String label, IconData icon,
      {bool isLocationField = true, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: _getTextFieldWithIconDecoration(label, icon),
        onTap: isLocationField
            ? () {
                Navigator.pushNamed(context, '/map-page');
              }
            : null,
      ),
    );
  }

  InputDecoration _getTextFieldWithIconDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    );
  }

  Widget _buildTextFieldWithFilePicker(String label) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Medical Document",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Choose File'),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: _takePicture,
                child: const Text('Take Picture'),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          if (selectedFile != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        selectedFile!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    // Close Icon Button
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          selectedFile = null;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedFile = File(image.path);
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedFile = File(image.path);
      });
    }
  }

  Widget _buildUrgencyLevelDropdown() {
    List<String> urgencyLevels = ['Low', 'Medium', 'High'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        decoration: _getTextFieldDecoration('Urgency Level'),
        value: _selectedUrgencyLevel,
        items: urgencyLevels.map((level) {
          return DropdownMenuItem(
            value: level,
            child: Text(level),
          );
        }).toList(),
        onChanged: (value) {
          _selectedUrgencyLevel = value.toString();
        },
      ),
    );
  }

  Widget _buildBloodGroupDropdown(String label) {
    List<String> bloodGroups = ['A', 'B', 'AB', 'O'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        decoration: _getTextFieldDecoration(label),
        value: _selectedBloodGroupAbo,
        items: bloodGroups.map((group) {
          return DropdownMenuItem(
            value: group,
            child: Text(group),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedBloodGroupAbo = value.toString();
          });
        },
      ),
    );
  }

  Widget _buildRow(
      List<String> labels, List<TextEditingController> controllers) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        children: List.generate(labels.length, (index) {
          return Expanded(
            child: _buildTextField(labels[index], controllers[index]),
          );
        }),
      ),
    );
  }

  Widget _buildBloodGroupRhDropdown(String label) {
    List<String> bloodGroupRh = ['Positive (+ve)', 'Negative (-ve)'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        decoration: _getTextFieldDecoration(label),
        value: _selectedBloodGroupRh,
        items: bloodGroupRh.map((group) {
          return DropdownMenuItem(
            value: group,
            child: Text(group),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedBloodGroupRh = value.toString();
          });
        },
      ),
    );
  }

  Widget _buildDateTimePicker(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          await _selectDate();
          await _selectTime();
        },
        child: InputDecorator(
          decoration: _getTextFieldDecoration(label),
          child: _buildDateTimeRow(),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          selectedDate != null && selectedTime != null
              ? 'Selected: ${DateFormat.yMd().add_jm().format(
                    DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    ),
                  )}'
              : 'Select Date and Time',
        ),
        const Icon(Icons.calendar_today),
      ],
    );
  }

  Widget _buildNumericTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: _getTextFieldDecoration(label),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () {
            _sendDataToBackend();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 45),
            backgroundColor: Colors.red,
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendDataToBackend() async {
    try {
      if (selectedFile == null) {
        return;
      }

      final locationData = ref.watch(locationDataProvider);

      if (locationData != null && locationData.coordinates != null) {
        String? locationId = await _sendLocationData(locationData);

        if (locationId != null) {
          BloodRequestModel requestData = BloodRequestModel(
            patientName: _patientNameController.text,
            age: _ageController.text,
            sex: _sexController.text,
            hospitalName: _hospitalNameController.text,
            location: locationId,
            roomNo: _roomNoController.text,
            opdNo: _opdNoController.text,
            bloodGroupAbo: _selectedBloodGroupAbo,
            bloodGroupRh: _selectedBloodGroupRh,
            description: _descriptionController.text,
            urgencyLevel: _selectedUrgencyLevel,
            dateAndTime: _getSelectedDateTime(),
            quantity: _quantityController.text,
            filePath: selectedFile!.path,
          );

          Uint8List imageBytes =
              Uint8List.fromList(await selectedFile!.readAsBytes());

          await _sendBloodRequestData(requestData, imageBytes);
        }
      }
    } catch (error) {
      print("Error sending data and image to backend: $error");
    }
  }

  Future<String?> _sendLocationData(LocationData? locationData) async {
    try {
      if (locationData == null) {
        // Handle the case where locationData is null
        return null;
      }
      LocationService service = LocationService(_apiService);

      return await service.sendLocationData(
        ref,
        locationData.coordinates!,
        locationData.geoLocation!,
      );

      // );
    } catch (e) {
      // Handle error in sending location data
      return null;
    }
  }

  Future<void> _sendBloodRequestData(
    BloodRequestModel requestData,
    Uint8List imageBytes,
  ) async {
    try {
      _bloodRequestService.sendDataAndImageToBackend(
        requestData,
        imageBytes,
        ref,

        // location: requestData.location, // Pass location to the service
      );

      // Handle successful submission (e.g., show success message)
    } catch (e) {
      // Handle error in sending blood request data
      print("Error sending blood request data: $e");
    }
  }

  String _getSelectedDateTime() {
    if (selectedDate != null && selectedTime != null) {
      final dateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      return dateTime.toUtc().toIso8601String();
    } else {
      return '';
    }
  }
}
