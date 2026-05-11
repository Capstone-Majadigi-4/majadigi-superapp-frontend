import 'package:flutter/material.dart';

class TbcQuestionCard extends StatelessWidget {
  final String question;
  final bool? value;
  final ValueChanged<bool> onChanged;

  const TbcQuestionCard({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: ShapeDecoration(
        color: const Color(0x1E0065FF), // Light blue background
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1.33,
            color: Color(0x1A000000), // 10% black
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                color: Color(0xFF4A5565),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildChoiceButton(
                label: 'Iya',
                isSelected: value == true,
                onTap: () => onChanged(true),
              ),
              const SizedBox(width: 8),
              _buildChoiceButton(
                label: 'Tidak',
                isSelected: value == false,
                onTap: () => onChanged(false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 22, // Updated to match Figma
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF5497FF) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF434343),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
