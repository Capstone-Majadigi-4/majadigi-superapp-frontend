import 'package:flutter/material.dart';

class PriceAlertModal extends StatefulWidget {
  final String commodityName;
  final String currentPrice;
  final String unit;

  const PriceAlertModal({
    super.key,
    required this.commodityName,
    required this.currentPrice,
    required this.unit,
  });

  @override
  State<PriceAlertModal> createState() => _PriceAlertModalState();
}

class _PriceAlertModalState extends State<PriceAlertModal> {
  bool _isDown = true;
  final TextEditingController _priceController = TextEditingController(text: '15000');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined, color: Color(0xFFF97316), size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Set Price Alert',
                      style: TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF717182), size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Dapatkan notifikasi saat harga ${widget.commodityName} mencapai target Anda',
              style: const TextStyle(
                color: Color(0xFF717182),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Current Price Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Harga Saat Ini',
                    style: TextStyle(
                      color: Color(0xFF3B82F6),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Rp ${widget.currentPrice}',
                          style: const TextStyle(
                            color: Color(0xFF1E40AF),
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${widget.unit}',
                          style: const TextStyle(
                            color: Color(0xFF3B82F6),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Alert Condition
            const Text(
              'Kondisi Alert',
              style: TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildConditionButton(
                    label: 'Turun di Bawah',
                    icon: Icons.trending_down,
                    isSelected: _isDown,
                    onTap: () => setState(() => _isDown = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildConditionButton(
                    label: 'Naik di Atas',
                    icon: Icons.trending_up,
                    isSelected: !_isDown,
                    onTap: () => setState(() => _isDown = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Target Price Input
            const Text(
              'Harga Target (Rp)',
              style: TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Masukkan harga target',
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: const Border(
                  left: BorderSide(color: Color(0xFF22C55E), width: 4),
                ),
              ),
              child: Text.rich(
                TextSpan(
                  text: 'Notifikasi akan dikirim jika harga ${widget.commodityName} ',
                  style: const TextStyle(
                    color: Color(0xFF166534),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: _isDown ? "turun di bawah " : "naik di atas ",
                      style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF15803D)),
                    ),
                    TextSpan(
                      text: 'Rp ${_priceController.text.isEmpty ? "0" : _priceController.text}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF065F46)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Activate Alert logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF97316),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_active, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Aktifkan Alert',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF22C55E) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF22C55E) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF4B5563),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
