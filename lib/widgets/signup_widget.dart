// ignore_for_file: constant_identifier_names, unnecessary_null_comparison, avoid_print

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/models/firebase_auth/utils.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import '../main.dart';
import '../services/firebase_auth_service.dart';

enum Gender { Male, Female, Others }

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super. key,
    required this.onClickedSignIn,
  }) ;

  final VoidCallback? onClickedSignIn;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Gender? selectedGender = Gender.Male;
  bool isPasswordVisible = false;
  bool _acceptTermsAndPrivacy = false;

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    ageController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Registration',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16.0),

              // Form
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Fullname Input
                    TextFormField(
                      controller: fullnameController,
                      decoration: const InputDecoration(
                        labelText: 'Fullname',
                      ),
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Enter your fullname' : null,
                    ),
                    const SizedBox(height: 16.0),

                    // Email Input
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),

                    // Gender Input
                    DropdownButtonFormField<Gender>(
                      value: selectedGender,
                      onChanged: (value) {
                        // Update the selected gender when changed
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: Gender.Male,
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: Gender.Female,
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(
                          value: Gender.Others,
                          child: Text('Others'),
                        ),
                      ],
                      validator: (gender) =>
                          gender == null ? 'Select your gender' : null,
                    ),
                    const SizedBox(height: 16.0),

                    // Age Input
                    TextFormField(
                      controller: ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Enter your age' : null,
                    ),

                    const SizedBox(height: 16.0),

                    // Age Input
                    TextFormField(
                      controller: mobileNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.trim().isEmpty
                          ? 'Enter your Mobile Number'
                          : null,
                    ),

                    const SizedBox(height: 16.0),

                    // Password Input with Show/Hide Icon
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) =>
                          value != null && value.length < 6
                              ? 'Password is too short'
                              : null,
                      obscureText: !isPasswordVisible,
                    ),
                    const SizedBox(height: 16.0),

                    // Confirm Password Input with Show/Hide Icon
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value != null &&
                            value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      obscureText: !isPasswordVisible,
                    ),
                    const SizedBox(height: 24.0),

                    // Checkbox for accepting Terms and Conditions & Privacy Policy
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Checkbox for accepting Terms and Conditions & Privacy Policy
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTermsAndPrivacy,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTermsAndPrivacy = value!;
                                  });
                                },
                              ),
                              const Text(
                                'I accept ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Terms and Conditions & Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          // Red Sign-Up Button with White Text
                          ElevatedButton(
                            onPressed: signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Color.fromARGB(255, 56, 55, 55),
                              ),
                              text: 'Already have an account? ',
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (widget.onClickedSignIn != null) {
                                        widget.onClickedSignIn!();
                                      }
                                    },
                                  text: 'Login',
                                  style: const TextStyle(
                                    color: Color(0xFFFD1A00),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> signUp() async {
    if (formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      try {
        final authResult = await FirebaseAuthService.signUp(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (authResult != null) {
          await sendUserDataToApi(authResult.user?.uid);
        } else {
          Utils.showSnackBar('User creation failed');
        }
      } on Exception catch (e) {
        Utils.showSnackBar(e.toString());
      } finally {
        navigatorKey.currentState!
            .popUntil((route) => route.isFirst); 
      }
    }
  }

  Future<void> sendUserDataToApi(String? userUid) async {
    if (userUid == null) {
      Utils.showSnackBar('User UID is null');
      return;
    }

    final apiUrl = '${ApiService().baseUrl}/api/users';

    final userData = {
      'mobile_number': mobileNumberController.text.trim(),
      'full_name': fullnameController.text.trim(),
      'gender': selectedGender.toString().split('.').last,
      'age': ageController.text.trim(),
      'email': emailController.text.trim(),
      'firebase_uid': userUid,
      'user_type': 'user',
    };

    try {
      final response = await ApiService().postData(apiUrl, userData);

      if (response != null) {
        print('User created successfully');
        print('Response: $response');
      } else {
        print('Failed to create user. Response is null.');
      }
    } catch (error) {
      print('Error creating user: $error');
      print(userData);
    }
  }
}
