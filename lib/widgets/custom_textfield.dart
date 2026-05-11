import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.onTap,
    this.readOnly = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: Color(0xFF4A5565),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 12),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword,
          onTap: onTap,
          readOnly: readOnly,
          validator: validator,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.33),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.33),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF0065FF), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.33),
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: const Color(0xFF94A3B8), size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: const Color(0xFF94A3B8), size: 20)
                : null,
          ),
        ),
      ],
    );
  }
}
