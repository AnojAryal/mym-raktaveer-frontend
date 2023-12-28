class FormValidator {
  static String? validatePatientName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the patient\'s name';
    }
    if (value.length > 100) {
      return 'Name is too long (maximum is 100 characters)';
    }
    return null;
  }

  static String? validateHospitalName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Hospital\'s name';
    }
    if (value.length > 100) {
      return 'Hospital Name is too long (maximum is 100 characters)';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select the location';
    }
    return null;
  }

  static String? validateRoomNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a room number';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Please enter a valid room/opd number';
    }
    if (value.length > 10) {
      return 'Room/opd number is too long (maximum is 10 characters)';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    int wordCount = value.trim().split(RegExp(r'\s+')).length;
    if (wordCount > 50) {
      return 'Description can only be up to 50 words';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a quantity';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Quantity must be a number';
    }
    int quantity = int.parse(value);
    if (quantity <= 0) {
      return 'Quantity must be greater than zero';
    }
    return null;
  }
}
