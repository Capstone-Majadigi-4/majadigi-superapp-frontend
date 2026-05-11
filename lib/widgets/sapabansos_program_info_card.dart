import 'package:flutter/material.dart';

class SapabansosProgramInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String totalFunds;
  final String quota;

  const SapabansosProgramInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.totalFunds,
    required this.quota,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 1.33,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Deskripsi:',
            style: TextStyle(
              color: Color(0xFF4A5565),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF6E6E6E),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Total dana:', totalFunds),
          const SizedBox(height: 8),
          _buildDetailRow('Kuota:', quota),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A5565),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.43,
          ),
        ),
      ],
    );
  }
}
