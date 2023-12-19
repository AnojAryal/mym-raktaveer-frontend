// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import '../../widgets/background.dart';
// import '../../widgets/map.dart';

// class BloodRequestForm extends StatefulWidget {
//   const BloodRequestForm({super.key});

//   @override
//   State<BloodRequestForm> createState() => _BloodRequestFormState();
// }

// class _BloodRequestFormState extends State<BloodRequestForm> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   Future<void> _selectDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _selectTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (pickedTime != null && pickedTime != selectedTime) {
//       setState(() {
//         selectedTime = pickedTime;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Background(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildBackButton(),
//           _buildBloodRequestFormTitle(),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildTextField('Patient Name'),
//                   _buildRow(['Age', 'Sex']),
//                   _buildTextFieldWithIcon(
//                       'Hospital Name', Icons.local_hospital,isLocationField: false),
//                   _buildTextFieldWithIcon('Location', Icons.location_on),
//                   _buildRow(['Room No.', 'OPD No.']),
//                   _buildBloodGroupDropdown('Blood Group (ABO)'),
//                   _buildBloodGroupRhDropdown('Blood Group (RH)'),
//                   _buildTextFieldWithFilePicker('Document Upload'),
//                   _buildTextField('Description'),
//                   _buildUrgencyLevelDropdown(),
//                   _buildDateTimePicker('Date and Time'),
//                   _buildNumericTextField('Quantity'),
//                   const SizedBox(height: 16.0),
//                   _buildSignUpButton(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBackButton() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Align(
//         alignment: Alignment.topLeft,
//         child: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//           ),
//           onPressed: () {
//             // Handle back button press
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildBloodRequestFormTitle() {
//     return const Center(
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 16.0),
//         child: Text(
//           'Blood Request Form',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         decoration: _getTextFieldDecoration(label),
//       ),
//     );
//   }

//   InputDecoration _getTextFieldDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       border: const OutlineInputBorder(),
//       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//     );
//   }

//  Widget _buildTextFieldWithIcon(String label, IconData icon, {bool isLocationField = true}) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: TextField(
//       decoration: _getTextFieldWithIconDecoration(label, icon),
//       onTap: isLocationField
//           ? () {
//               // Navigate to MapChoice page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const MapChoice()),
//               );
//             }
//           : null,
//     ),
//   );
// }

//   InputDecoration _getTextFieldWithIconDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon),
//       border: const OutlineInputBorder(),
//       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//     );
//   }

//   Widget _buildTextFieldWithFilePicker(String label) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: _pickFile,
//         child: InputDecorator(
//           decoration: _getTextFieldDecoration(label),
//           child: _buildFilePickerRow(),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilePickerRow() {
//     return const Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text('Choose a file'),
//         Icon(Icons.attach_file),
//       ],
//     );
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();

//     if (result != null) {
//       // Handle the file path as needed
//     }
//   }

//   Widget _buildUrgencyLevelDropdown() {
//     List<String> urgencyLevels = ['Low', 'Medium', 'High'];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButtonFormField(
//         decoration: _getTextFieldDecoration('Urgency Level'),
//         value: urgencyLevels[0],
//         items: urgencyLevels.map((level) {
//           return DropdownMenuItem(
//             value: level,
//             child: Text(level),
//           );
//         }).toList(),
//         onChanged: (value) {
//           // Handle dropdown value change
//         },
//       ),
//     );
//   }

//   Widget _buildRow(List<String> labels) {
//     return Padding(
//       padding: const EdgeInsets.all(1.0),
//       child: Row(
//         children: labels
//             .map((label) => Expanded(
//                   child: _buildTextField(label),
//                 ))
//             .toList(),
//       ),
//     );
//   }

//   Widget _buildBloodGroupDropdown(String label) {
//     List<String> bloodGroups = ['A', 'B', 'AB', 'O'];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButtonFormField(
//         decoration: _getTextFieldDecoration(label),
//         value: bloodGroups[0],
//         items: bloodGroups.map((group) {
//           return DropdownMenuItem(
//             value: group,
//             child: Text(group),
//           );
//         }).toList(),
//         onChanged: (value) {
//           // Handle dropdown value change
//         },
//       ),
//     );
//   }

//   Widget _buildBloodGroupRhDropdown(String label) {
//     List<String> bloodGroupRh = ['Positive (+ve)', 'Negative (-ve)'];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButtonFormField(
//         decoration: _getTextFieldDecoration(label),
//         value: bloodGroupRh[0],
//         items: bloodGroupRh.map((group) {
//           return DropdownMenuItem(
//             value: group,
//             child: Text(group),
//           );
//         }).toList(),
//         onChanged: (value) {
//           // Handle dropdown value change
//         },
//       ),
//     );
//   }

//   Widget _buildDateTimePicker(String label) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: () async {
//           await _selectDate();
//           await _selectTime();
//         },
//         child: InputDecorator(
//           decoration: _getTextFieldDecoration(label),
//           child: _buildDateTimeRow(),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateTimeRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           selectedDate != null && selectedTime != null
//               ? 'Selected: ${DateFormat.yMd().add_jm().format(DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute))}'
//               : 'Select Date and Time',
//         ),
//         const Icon(Icons.calendar_today),
//       ],
//     );
//   }

//   Widget _buildNumericTextField(String label) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextFormField(
//         keyboardType: TextInputType.number,
//         inputFormatters: <TextInputFormatter>[
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         decoration: _getTextFieldDecoration(label),
//       ),
//     );
//   }

//   Widget _buildSignUpButton() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(150, 45),
//             backgroundColor: Colors.red,
//           ),
//           child: const Text(
//             'Sign Up',
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../../widgets/background.dart';
// import '../../widgets/map.dart';

// class BloodRequestForm extends StatefulWidget {
//   const BloodRequestForm({super.key});

//   @override
//   State<BloodRequestForm> createState() => _BloodRequestFormState();
// }

// class _BloodRequestFormState extends State<BloodRequestForm> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _sexController = TextEditingController();
//   final TextEditingController _hospitalNameController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _roomNoController = TextEditingController();
//   final TextEditingController _opdNoController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _urgencyLevelController = TextEditingController();

//   Future<void> _selectDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _selectTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (pickedTime != null && pickedTime != selectedTime) {
//       setState(() {
//         selectedTime = pickedTime;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Background(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildBackButton(),
//           _buildBloodRequestFormTitle(),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildTextField('Patient Name', _patientNameController),
//                   _buildRow(['Age', 'Sex']),
//                   _buildTextField('Hospital Name', _hospitalNameController),
//                   _buildTextFieldWithIcon('Location', Icons.location_on, controller: _locationController),
//                   _buildRow(['Room No.', 'OPD No.']),
//                   _buildBloodGroupDropdown('Blood Group (ABO)'),
//                   _buildBloodGroupRhDropdown('Blood Group (RH)'),
//                   _buildTextFieldWithFilePicker('Document Upload'),
//                   _buildTextField('Description', _descriptionController),
//                   _buildUrgencyLevelDropdown(),
//                   _buildDateTimePicker('Date and Time'),
//                   _buildNumericTextField('Quantity', _quantityController),
//                   const SizedBox(height: 16.0),
//                   _buildSignUpButton(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBackButton() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Align(
//         alignment: Alignment.topLeft,
//         child: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//           ),
//           onPressed: () {
//             // Handle back button press
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildBloodRequestFormTitle() {
//     return const Center(
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 16.0),
//         child: Text(
//           'Blood Request Form',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: controller,
//         decoration: _getTextFieldDecoration(label),
//       ),
//     );
//   }

//   InputDecoration _getTextFieldDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       border: const OutlineInputBorder(),
//       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//     );
//   }

//   Widget _buildTextFieldWithIcon(String label, IconData icon, {bool isLocationField = true, TextEditingController? controller}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: controller,
//         decoration: _getTextFieldWithIconDecoration(label, icon),
//         onTap: isLocationField
//             ? () {
//           // Navigate to MapChoice page
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const MapChoice()),
//           );
//         }
//             : null,
//       ),
//     );
//   }

//   InputDecoration _getTextFieldWithIconDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon),
//       border: const OutlineInputBorder(),
//       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//     );
//   }

//   Widget _buildTextFieldWithFilePicker(String label) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: _pickFile,
//         child: InputDecorator(
//           decoration: _getTextFieldDecoration(label),
//           child: _buildFilePickerRow(),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilePickerRow() {
//     return const Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text('Choose a file'),
//         Icon(Icons.attach_file),
//       ],
//     );
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();

//     if (result != null) {
//       // Handle the file path as needed
//     }
//   }

//   Widget _buildUrgencyLevelDropdown() {
//     List<String> urgencyLevels = ['Low', 'Medium', 'High'];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButtonFormField(
//         decoration: _getTextFieldDecoration('Urgency Level'),
//         value: urgencyLevels[0],
//         items: urgencyLevels.map((level) {
//           return DropdownMenuItem(
//             value: level,
//             child: Text(level),
//           );
//         }).toList(),
//         onChanged: (value) {
//           _urgencyLevelController.text = value.toString();
//         },
//       ),
//     );
//   }

//   Widget _buildRow(List<String> labels) {
//     return Padding(
//       padding: const EdgeInsets.all(1.0),
//       child: Row(
//         children: labels
//             .map((label) => Expanded(
//           child: _buildTextField(label, TextEditingController()),
//         ))
//             .toList(),
//       ),
//     );
//   }

//   Widget _buildBloodGroupDropdown(String label) {
//     List<String> bloodGroups = ['A', 'B', 'AB', 'O'];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButtonFormField(
//         decoration: _getTextFieldDecoration(label),
//         value: bloodGroups[0],
//         items: bloodGroups.map((group) {
//           return DropdownMenuItem(
//             value: group,
//             child: Text(group),
//           );
//         }).toList(),
//         onChanged: (value) {
//           // Handle dropdown value change
//         },
//       ),
//     );
//   }

//   Widget _buildBloodGroupRhDropdown(String label) {
//     List<String> bloodGroupRh = ['Positive (+ve)', 'Negative (-ve)'];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButtonFormField(
//         decoration: _getTextFieldDecoration(label),
//         value: bloodGroupRh[0],
//         items: bloodGroupRh.map((group) {
//           return DropdownMenuItem(
//             value: group,
//             child: Text(group),
//           );
//         }).toList(),
//         onChanged: (value) {
//           // Handle dropdown value change
//         },
//       ),
//     );
//   }

//   Widget _buildDateTimePicker(String label) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: () async {
//           await _selectDate();
//           await _selectTime();
//         },
//         child: InputDecorator(
//           decoration: _getTextFieldDecoration(label),
//           child: _buildDateTimeRow(),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateTimeRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           selectedDate != null && selectedTime != null
//               ? 'Selected: ${DateFormat.yMd().add_jm().format(DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute))}'
//               : 'Select Date and Time',
//         ),
//         const Icon(Icons.calendar_today),
//       ],
//     );
//   }

//   Widget _buildNumericTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         inputFormatters: <TextInputFormatter>[
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         decoration: _getTextFieldDecoration(label),
//       ),
//     );
//   }

//   Widget _buildSignUpButton() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: ElevatedButton(
//           onPressed: () {
//             _sendDataToBackend();
//           },
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(150, 45),
//             backgroundColor: Colors.red,
//           ),
//           child: const Text(
//             'Sign Up',
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _sendDataToBackend() async {
//     Map<String, dynamic> requestData = {
//       'patientName': _patientNameController.text,
//       'age': _ageController.text,
//       'sex': _sexController.text,
//       'hospitalName': _hospitalNameController.text,
//       'location': _locationController.text,
//       'roomNo': _roomNoController.text,
//       'opdNo': _opdNoController.text,
//       'description': _descriptionController.text,
//       'urgencyLevel': _urgencyLevelController.text,
//       'dateAndTime': _getSelectedDateTime(),
//       'quantity': _quantityController.text,
//     };

//     final response = await http.post(
//       Uri.parse('https://71f9-2400-1a00-b030-d590-dedf-3b84-2bdc-7c0e.ngrok-free.app/api/blood-donation-request'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(requestData),
//     );

//     if (response.statusCode == 200) {
//       print('Request sent successfully');
//     } else {
//       print('Failed to send request. Status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   }

//   String _getSelectedDateTime() {
//     if (selectedDate != null && selectedTime != null) {
//       return DateFormat.yMd().add_jm().format(DateTime(
//         selectedDate!.year,
//         selectedDate!.month,
//         selectedDate!.day,
//         selectedTime!.hour,
//         selectedTime!.minute,
//       ));
//     } else {
//       return '';
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/blood_request_model.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';
import '../../widgets/map.dart';

class BloodRequestForm extends StatefulWidget {
  const BloodRequestForm({super.key}) ;

  @override
  State<BloodRequestForm> createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends State<BloodRequestForm> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
                  _buildRow(['Age', 'Sex']),
                  _buildTextField('Hospital Name', _hospitalNameController),
                  _buildTextFieldWithIcon('Location', Icons.location_on, controller: _locationController),
                  _buildRow(['Room No.', 'OPD No.']),
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
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            // Handle back button press
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

  Widget _buildTextFieldWithIcon(String label, IconData icon, {bool isLocationField = true, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: _getTextFieldWithIconDecoration(label, icon),
        onTap: isLocationField
            ? () {
                // Navigate to MapChoice page
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
      child: InkWell(
        onTap: _pickFile,
        child: InputDecorator(
          decoration: _getTextFieldDecoration(label),
          child: _buildFilePickerRow(),
        ),
      ),
    );
  }

  Widget _buildFilePickerRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Choose a file'),
        Icon(Icons.attach_file),
      ],
    );
  }

  Future<void> _pickFile() async {
    // Implement file picking logic here
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

  Widget _buildRow(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        children: labels
            .map((label) => Expanded(
                  child: _buildTextField(label, TextEditingController()),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBloodGroupDropdown(String label) {
    List<String> bloodGroups = ['A', 'B', 'AB', 'O'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        decoration: _getTextFieldDecoration(label),
        value: bloodGroups[0],
        items: bloodGroups.map((group) {
          return DropdownMenuItem(
            value: group,
            child: Text(group),
          );
        }).toList(),
        onChanged: (value) {
          // Handle dropdown value change
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
        value: bloodGroupRh[0],
        items: bloodGroupRh.map((group) {
          return DropdownMenuItem(
            value: group,
            child: Text(group),
          );
        }).toList(),
        onChanged: (value) {
          // Handle dropdown value change
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
              ? 'Selected: ${DateFormat.yMd().add_jm().format(DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute))}'
              : 'Select Date and Time',
        ),
        const Icon(Icons.calendar_today),
      ],
    );
  }

  Widget _buildNumericTextField(String label, TextEditingController controller) {
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
      description: _descriptionController.text,
      urgencyLevel: _urgencyLevelController.text,
      dateAndTime: _getSelectedDateTime(),
      quantity: _quantityController.text,
    );

    BloodRequestService().sendDataToBackend(requestData);
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
