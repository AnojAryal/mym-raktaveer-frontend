// ignore_for_file: constant_identifier_names, unnecessary_null_comparison, avoid_print

import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/auth_state_provider.dart';
import 'package:mym_raktaveer_frontend/widgets/firebase/utils.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import '../../main.dart';
import '../../services/firebase_auth_service.dart';

enum Gender { Male, Female, Others }

class SignUpWidget extends ConsumerStatefulWidget {
  final VoidCallback? onClickedSignIn;

  const SignUpWidget({super.key, this.onClickedSignIn});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends ConsumerState<SignUpWidget> {
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
  int? selectedAge;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

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
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Registration',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16.0),
                Form(key: formKey, child: _buildForm()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildCheckbox(),
        const SizedBox(height: 16.0),
        _buildSignUpButton(),
        const SizedBox(
          height: 24,
        ),
        _buildSignInRichText(),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        if (isFormValid()) {
          if (_acceptTermsAndPrivacy) {
            signUp();
          } else {
            showSnackbar('Please accept the terms and conditions');
          }
        } else {
          showSnackbar('Please fill in all required fields');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
    );
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildCheckbox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Fullname Input
        TextFormField(
          controller: fullnameController,
          decoration: const InputDecoration(
            labelText: 'Fullname',
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (email) {
            if (email == null || email.isEmpty) {
              return 'Enter your email';
            } else if (!EmailValidator.validate(email)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16.0),

        // Gender Input
        DropdownButtonFormField<Gender>(
          value: selectedGender,
          onChanged: (value) {
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (gender) => gender == null ? 'Select your gender' : null,
        ),
        const SizedBox(height: 16.0),

        // Age Input
        TextFormField(
          controller: ageController,
          decoration: const InputDecoration(
            labelText: 'Age',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (age) {
            if (age == null || age.isEmpty) {
              return 'Enter your age';
            }
            final intAge = int.tryParse(age);
            if (intAge == null || intAge < 1 || intAge > 110) {
              return 'Please enter a valid age';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),

        // Mobile Number Input
        TextFormField(
          controller: mobileNumberController,
          decoration: const InputDecoration(
            labelText: 'Mobile Number',
            prefixText: '+977 ',
          ),
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) =>
              value!.trim().isEmpty ? 'Enter your Mobile Number' : null,
        ),

        const SizedBox(height: 16.0),

        // Password Input with Show/Hide Icon
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (password) {
            if (password == null || password.length < 6) {
              return 'Password should be at least 6 characters';
            } else if (!password.contains(RegExp(r'(?=.*[A-Z])'))) {
              return 'Password should contain at least one capital letter';
            } else if (!password.contains(RegExp(r'(?=.*[@#$%^&+=*])'))) {
              return 'Password should contain at least one special character';
            }
            return null;
          },
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
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value != null && value != passwordController.text) {
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignInRichText() {
    return RichText(
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
    );
  }

  Future<void> signUp() async {
    final isLocalDbOperationPending =
        ref.read(isLocalDbOperationPendingProvider.notifier);
    if (!isFormValid()) return;
    showLoadingDialog();
    isLocalDbOperationPending.state = false;

    try {
      UserCredential? authResult = await FirebaseAuthService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        ref,
      );

      if (authResult?.user != null) {
        isLocalDbOperationPending.state = true;
        bool dbResult = await sendUserDataToApi(authResult!.user!);

        if (!dbResult) {
          await deleteUser(authResult.user!);
          isLocalDbOperationPending.state = false;
        } else {
          isLocalDbOperationPending.state = false;
        }
      }
    } on FirebaseAuthException catch (e) {
      isLocalDbOperationPending.state =
          false; // Ensure the flag is reset in case of an exception
      if (e.code == 'email-already-in-use') {
        Utils.showSnackBar("The email is already in use");
      } else {
        Utils.showSnackBar("An error has occured: ${e.code}");
      }
    } finally {
      closeLoadingDialog();
    }
  }

  Future<void> deleteUser(User user) async {
    try {
      await user.delete();
    } catch (e) {
      Utils.showSnackBar('Error during user rollback: ${e.toString()}');
      // Handle any additional rollback logic if needed
    }
  }

  Future<bool> sendUserDataToApi(User user) async {
    final apiUrl = '${ApiService().baseUrl}/api/users/register';
    final userData = getUserData(user);

    final response = await ApiService().postAuthData(apiUrl, userData);
    if (response != null &&
        (response['message'] == 'User created successfully')) {
      return true;
    } else if (response != null &&
        (response['message'] == 'The mobile number has already been taken.')) {
      Utils.showSnackBar("mobile number has already been taken.");
      return false;
    } else {
      Utils.showSnackBar(response?['message']);
      return false;
    }
  }

  bool isFormValid() {
    return formKey.currentState?.validate() ?? false;
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void closeLoadingDialog() {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Map<String, dynamic> getUserData(User user) {
    return {
      'mobile_number': mobileNumberController.text.trim(),
      'full_name': fullnameController.text.trim(),
      'gender': selectedGender.toString().split('.').last,
      'age': ageController.text.trim(),
      'email': emailController.text.trim(),
      'firebase_uid': user.uid,
      'user_type': 'user',
    };
  }
}
