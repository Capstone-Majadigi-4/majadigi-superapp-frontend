import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/screens/login_screen.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_textfield.dart';

class RegisterStepTwo extends StatefulWidget {
  final VoidCallback onBack;

  RegisterStepTwo({super.key, required this.onBack});

  @override
  State<RegisterStepTwo> createState() => _RegisterStepTwoState();
}

class _RegisterStepTwoState extends State<RegisterStepTwo> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
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
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input Fields
        const CustomTextField(
          hintText: 'Alamat',
        ),
        const SizedBox(height: 16),
        const CustomTextField(
          hintText: 'NIK',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          hintText: 'Tanggal Lahir',
          controller: _dateController,
          suffixIcon: Icons.calendar_today_outlined,
          onTap: () => _selectDate(context),
          readOnly: true,
        ),
        const SizedBox(height: 16),
        const CustomTextField(
          hintText: 'Jenis Kelamin',
          suffixIcon: Icons.keyboard_arrow_down,
        ),
        const SizedBox(height: 16),
        const CustomTextField(
          hintText: 'Kata sandi',
          isPassword: true,
        ),
        const SizedBox(height: 16),
        const CustomTextField(
          hintText: 'Ulangi Kata sandi',
          isPassword: true,
        ),
        const SizedBox(height: 40),
        
        CustomButton(
          text: 'Daftar',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
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
    );
  }
}
