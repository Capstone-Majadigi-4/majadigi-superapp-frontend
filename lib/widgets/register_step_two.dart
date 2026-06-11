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

  void _showGenderPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Pilih Jenis Kelamin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.male, color: Color(0xFF0065FF)),
              title: const Text('Laki-laki'),
              onTap: () {
                setState(() {
                  widget.genderController.text = 'Laki-laki';
                });
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.female, color: Color(0xFFEC4899)),
              title: const Text('Perempuan'),
              onTap: () {
                setState(() {
                  widget.genderController.text = 'Perempuan';
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

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
            readOnly: true,
            onTap: () => _showGenderPicker(context),
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
