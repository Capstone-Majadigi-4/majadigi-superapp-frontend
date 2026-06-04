import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_textfield.dart';

class RegisterStepOne extends StatelessWidget {
  final VoidCallback onNext;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const RegisterStepOne({
    super.key,
    required this.onNext,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Input Fields
          CustomTextField(
            hintText: 'Nama depan',
            controller: firstNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama depan wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Nama belakang',
            controller: lastNameController,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'No HP',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nomor HP wajib diisi';
              }
              final numericRegExp = RegExp(r'^[0-9]+$');
              if (!numericRegExp.hasMatch(value.trim())) {
                return 'Nomor HP harus berupa angka';
              }
              if (value.trim().length < 10 || value.trim().length > 15) {
                return 'Nomor HP harus berjarak 10-15 digit';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegExp.hasMatch(value.trim())) {
                  return 'Format email tidak valid';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 48),
          
          CustomButton(
            text: 'Selanjutnya',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onNext();
              }
            },
          ),
        ],
      ),
    );
  }
}
