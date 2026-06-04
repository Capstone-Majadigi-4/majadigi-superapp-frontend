import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_textfield.dart';

class RegisterStepTwo extends StatefulWidget {
  final VoidCallback onBack;
  final GlobalKey<FormState> formKey;
  final TextEditingController addressController;
  final TextEditingController nikController;
  final TextEditingController dateController;
  final TextEditingController genderController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;

  const RegisterStepTwo({
    super.key,
    required this.onBack,
    required this.formKey,
    required this.addressController,
    required this.nikController,
    required this.dateController,
    required this.genderController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
  });

  @override
  State<RegisterStepTwo> createState() => _RegisterStepTwoState();
}

class _RegisterStepTwoState extends State<RegisterStepTwo> {

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0065FF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        widget.dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Input Fields
          CustomTextField(
            hintText: 'Alamat',
            controller: widget.addressController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'NIK',
            controller: widget.nikController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'NIK wajib diisi';
              }
              final numericRegExp = RegExp(r'^[0-9]+$');
              if (!numericRegExp.hasMatch(value.trim())) {
                return 'NIK harus berupa angka';
              }
              if (value.trim().length != 16) {
                return 'NIK harus tepat 16 digit';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Tanggal Lahir',
            controller: widget.dateController,
            suffixIcon: Icons.calendar_today_outlined,
            onTap: () => _selectDate(context),
            readOnly: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Jenis Kelamin',
            controller: widget.genderController,
            suffixIcon: Icons.keyboard_arrow_down,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Kata sandi',
            controller: widget.passwordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kata sandi wajib diisi';
              }
              if (value.length < 8) {
                return 'Kata sandi minimal 8 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Ulangi Kata sandi',
            controller: widget.confirmPasswordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ulangi kata sandi wajib diisi';
              }
              if (value != widget.passwordController.text) {
                return 'Kata sandi tidak cocok';
              }
              return null;
            },
          ),
          const SizedBox(height: 40),
          
          CustomButton(
            text: 'Daftar',
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                widget.onSubmit();
              }
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Kembali',
            backgroundColor: Colors.white,
            textColor: const Color(0xFF64748B),
            borderColor: const Color(0xFFE2E8F0),
            onPressed: widget.onBack,
          ),
        ],
      ),
    );
  }
}
