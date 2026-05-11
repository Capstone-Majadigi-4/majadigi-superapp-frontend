import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_textfield.dart';

class RegisterStepOne extends StatelessWidget {
  final VoidCallback onNext;

  RegisterStepOne({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input Fields
        const CustomTextField(
          hintText: 'Nama depan',
        ),
        const SizedBox(height: 20),
        const CustomTextField(
          hintText: 'Nama belakang',
        ),
        const SizedBox(height: 20),
        const CustomTextField(
          hintText: 'No HP',
        ),
        const SizedBox(height: 20),
        const CustomTextField(
          hintText: 'Email',
        ),
        const SizedBox(height: 48),
        
        CustomButton(
          text: 'Selanjutnya',
          onPressed: onNext,
        ),
      ],
    );
  }
}
