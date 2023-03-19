import 'package:core/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../bloc/registration_bloc.dart';
import 'dart:typed_data';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  int _currentStep = 0;

  String _username = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  final String _telephone = '';
  String _profileImage = '';
  late Uint8List _profileImageByte;
  String _address = '';
  String _city = '';
  String _province = '';
  String _country = '';
  final TextEditingController _telephoneController = TextEditingController();
  final FocusNode _telephoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _telephoneController.text = '+';
    _telephoneFocusNode.addListener(_onTelephoneFocusChange);
  }

  void _onTelephoneFocusChange() {
    if (_telephoneFocusNode.hasFocus &&
        !_telephoneController.text.startsWith('+')) {
      _telephoneController.value = TextEditingValue(
        text: '+${_telephoneController.text}',
        selection: TextSelection.collapsed(
            offset: _telephoneController.text.length + 1),
      );
    }
  }

  @override
  void dispose() {
    _telephoneController.dispose();
    _telephoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Form')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepTapped: (step) => setState(() => _currentStep = step),
        steps: [
          Step(
            title: const Text('Account Information'),
            content: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Username (Email)'),
                  onChanged: (value) => _username = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  onChanged: (value) => _password = value,
                  obscureText: true,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Personal Information'),
            content: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First Name'),
                  onChanged: (value) => _firstName = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  onChanged: (value) => _lastName = value,
                ),
                TextField(
                  controller: _telephoneController,
                  focusNode: _telephoneFocusNode,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _telephoneController.value = const TextEditingValue(
                        text: '+',
                        selection: TextSelection.collapsed(offset: 1),
                      );
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Telephone',
                    hintText: 'Enter your telephone number',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  onChanged: (value) => _address = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'City'),
                  onChanged: (value) => _city = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Province'),
                  onChanged: (value) => _province = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Country'),
                  onChanged: (value) => _country = value,
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Profile Image'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      setState(() => _currentStep = 1);
    } else {
      final user = User(
        username: _username,
        password: _password,
        firstName: _firstName,
        lastName: _lastName,
        telephone: _telephone,
        profileImage: _profileImage,
        profileImageByte: _profileImageByte,
        address: _address,
        city: _city,
        province: _province,
        country: _country,
      );
      context.read<RegistrationBloc>().add(RegistrationSubmit(user: user));

      context.read<RegistrationBloc>().stream.listen((state) {
        if (state is RegistrationInProgress) {
          _showLoadingIndicator();
        } else {
          Navigator.of(context).pop();

          if (state is RegistrationSuccess) {
            _showResponseModal('Registration successful!');
          } else if (state is RegistrationFailure) {
            _showResponseModal('Error: ${state.error}');
          }
        }
      });
    }
  }

  void _showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showResponseModal(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Result'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: false,
    );
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      setState(() {
        _profileImage = fileName;
        _profileImageByte = fileBytes!;
      });
    }
  }
}
