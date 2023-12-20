import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/blood_request_model.dart';
import '../../services/api_service.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';
import '../../widgets/map.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class BloodRequestForm extends StatefulWidget {
  const BloodRequestForm({Key? key}) : super(key: key);

  @override
  State<BloodRequestForm> createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends State<BloodRequestForm> {
  late ApiService _apiService;
  late BloodRequestService _bloodRequestService;

  _BloodRequestFormState() {
    _apiService = ApiService();
    _bloodRequestService = BloodRequestService(_apiService);
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String _selectedBloodGroupAbo = 'A'; // Default value
  String _selectedBloodGroupRh = 'Positive (+ve)'; // Default value
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _opdNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _urgencyLevelController = TextEditingController();
  final TextEditingController _filePathController = TextEditingController();

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
    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(),
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

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
        decoration: _getTextFieldWithIconDecoration(label, icon),
        onTap: isLocationField
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapChoice()),
                );
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InputDecorator(
        decoration: _getTextFieldDecoration(label),
        child: _buildFilePickerRow(),
      ),
    );
  }

  Widget _buildFilePickerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          child: const Text('Choose File'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Selected File: ${_filePathController.text}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    print('pressed!!!!!!');
    bool hasPermission = await _requestPermission(Permission.storage);
    if (hasPermission) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _filePathController.text = result.files.single.path ?? 'No file selected';
        });
      } else {
        // User canceled the picker
      }
    } else {
      // Handle the scenario when permission is not granted
      _showPermissionDeniedMessage();
      print('File permission is required to pick files');
    }
  }

  void _showPermissionDeniedMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content:const  Text('File permission is required to pick files.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally, you can request permission again
                _pickFile();
              },
              child: Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Widget _buildUrgencyLevelDropdown() {
    List<String> urgencyLevels = ['Low', 'Medium', 'High'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        decoration: _getTextFieldDecoration('Urgency Level'),
        value: urgencyLevels[0],
        items: urgencyLevels.map((level) {
          return DropdownMenuItem(
            value: level,
            child: Text(level),
          );
        }).toList(),
        onChanged: (value) {
          _urgencyLevelController.text = value.toString();
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
                        selectedTime!.minute),
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
    BloodRequestModel requestData = BloodRequestModel(
      patientName: _patientNameController.text,
      age: _ageController.text,
      sex: _sexController.text,
      hospitalName: _hospitalNameController.text,
      location: _locationController.text,
      roomNo: _roomNoController.text,
      opdNo: _opdNoController.text,
      bloodGroupAbo: _selectedBloodGroupAbo,
      bloodGroupRh: _selectedBloodGroupRh,
      description: _descriptionController.text,
      urgencyLevel: _urgencyLevelController.text,
      dateAndTime: _getSelectedDateTime(),
      quantity: _quantityController.text,
      filePath: _filePathController.text,
    );

    await _bloodRequestService.sendDataToBackend(requestData);

    print('Requested data: ${requestData.toJson()}');
  }

  String _getSelectedDateTime() {
    if (selectedDate != null && selectedTime != null) {
      return DateFormat.yMd().add_jm().format(DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
            selectedTime!.hour,
            selectedTime!.minute,
          ));
    } else {
      return '';
    }
  }
}
