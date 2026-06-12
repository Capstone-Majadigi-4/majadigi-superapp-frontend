import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/bapenda_provider.dart';

class BapendaNjkbScreen extends StatefulWidget {
  const BapendaNjkbScreen({super.key});

  @override
  State<BapendaNjkbScreen> createState() => _BapendaNjkbScreenState();
}

class _BapendaNjkbScreenState extends State<BapendaNjkbScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BapendaProvider>(context, listen: false);
      provider.resetNjkbSelection();
      provider.fetchVehicleTypes();
    });
  }

  String _formatMoney(double amount) {
    final str = amount.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0046B2),
      body: Stack(
        children: [
          // 1. Header Gradient
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0078FF), Color(0xFF0046B2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nilai Jual Kendaraan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cek Nilai Jual & Estimasi Pajak Kendaraan',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calculate_outlined, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Main Content Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height - 110,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Consumer<BapendaProvider>(
                builder: (context, provider, child) {
                  final hasResult = provider.njkbResult != null;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hasResult) ...[
                          // Instruction card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline_rounded, color: Color(0xFF1D4ED8), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Pilih jenis, merk, model, tipe, dan tahun pembuatan kendaraan untuk memproses estimasi nilai jual kendaraan bermotor (NJKB).',
                                    style: TextStyle(
                                      color: const Color(0xFF1D4ED8),
                                      fontSize: 12,
                                      height: 1.5,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Step Form Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                // Dropdown 1: Jenis
                                _buildDropdown<String>(
                                  label: 'Jenis Kendaraan',
                                  value: provider.selectedType,
                                  items: provider.vehicleTypes,
                                  hint: 'Pilih Jenis Kendaraan',
                                  enabled: true,
                                  loading: provider.isLoadingTypes,
                                  onChanged: (val) => provider.setSelectedType(val),
                                ),
                                const SizedBox(height: 20),

                                // Dropdown 2: Merk
                                _buildDropdown<String>(
                                  label: 'Merk',
                                  value: provider.selectedBrand,
                                  items: provider.vehicleBrands,
                                  hint: provider.selectedType == null ? 'Pilih jenis kendaraan dahulu' : 'Pilih Merk',
                                  enabled: provider.selectedType != null,
                                  loading: provider.isLoadingBrands,
                                  onChanged: (val) => provider.setSelectedBrand(val),
                                ),
                                const SizedBox(height: 20),

                                // Dropdown 3: Model
                                _buildDropdown<String>(
                                  label: 'Model',
                                  value: provider.selectedModel,
                                  items: provider.vehicleModels,
                                  hint: provider.selectedBrand == null ? 'Pilih merk dahulu' : 'Pilih Model',
                                  enabled: provider.selectedBrand != null,
                                  loading: provider.isLoadingModels,
                                  onChanged: (val) => provider.setSelectedModel(val),
                                ),
                                const SizedBox(height: 20),

                                // Dropdown 4: Tipe
                                _buildDropdown<String>(
                                  label: 'Tipe',
                                  value: provider.selectedSubType,
                                  items: provider.vehicleSubTypes,
                                  hint: provider.selectedModel == null ? 'Pilih model dahulu' : 'Pilih Tipe',
                                  enabled: provider.selectedModel != null,
                                  loading: provider.isLoadingSubTypes,
                                  onChanged: (val) => provider.setSelectedSubType(val),
                                ),
                                const SizedBox(height: 20),

                                // Dropdown 5: Tahun
                                _buildDropdown<String>(
                                  label: 'Tahun Pembuatan',
                                  value: provider.selectedYear,
                                  items: provider.vehicleYears,
                                  hint: provider.selectedSubType == null ? 'Pilih tipe dahulu' : 'Pilih Tahun',
                                  enabled: provider.selectedSubType != null,
                                  loading: provider.isLoadingYears,
                                  onChanged: (val) => provider.setSelectedYear(val),
                                ),
                                const SizedBox(height: 24),

                                // Submit Button
                                Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    gradient: provider.selectedYear == null
                                        ? null
                                        : const LinearGradient(
                                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                    color: provider.selectedYear == null ? const Color(0xFFE2E8F0) : null,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: provider.selectedYear == null
                                        ? null
                                        : [
                                            BoxShadow(
                                              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: provider.selectedYear == null || provider.isCheckingNjkb
                                        ? null
                                        : () => provider.checkVehicleNjkb(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: provider.isCheckingNjkb
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Text(
                                            'Hitung NJKB',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Result ticket/card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Header
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFECFDF5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 24),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Hasil Estimasi NJKB',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF1E293B),
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Estimasi Berhasil Dihitung',
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                                const SizedBox(height: 20),

                                // Vehicle Name / Spec Description
                                Text(
                                  'Spesifikasi Kendaraan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                    letterSpacing: 0.8,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${provider.njkbResult!.merk.toUpperCase()} / ${provider.njkbResult!.model.toUpperCase()} ${provider.njkbResult!.tipe.toUpperCase()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Color(0xFF1E293B),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        provider.njkbResult!.jenisKendaraan,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Color(0xFF475569),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Tahun ${provider.njkbResult!.tahun}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Color(0xFF475569),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                                const SizedBox(height: 20),

                                // Main Values
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Nilai Jual (NJKB)',
                                            style: TextStyle(
                                              color: Color(0xFF64748B),
                                              fontSize: 13,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          Text(
                                            'Rp ${_formatMoney(provider.njkbResult!.njkb)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF1E293B),
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Estimasi PKB Rata-Rata',
                                            style: TextStyle(
                                              color: Color(0xFF64748B),
                                              fontSize: 13,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          Text(
                                            'Rp ${_formatMoney(provider.njkbResult!.pkbRataRata)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF3B82F6),
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Info note
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Nilai jual kendaraan bermotor (NJKB) ditetapkan berdasarkan harga pasaran umum. Nominal pajak (PKB) di atas merupakan estimasi rata-rata dasar dan belum termasuk Sumbangan Wajib Dana Kecelakaan Lalu Lintas Jalan (SWDKLLJ) serta biaya admin.',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 10,
                                          height: 1.5,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Reset Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () => provider.resetNjkbSelection(),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cek Lagi',
                                      style: TextStyle(
                                        color: Color(0xFF3B82F6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String hint,
    required bool enabled,
    required bool loading,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.white : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            hint: loading
                ? Row(
                    children: const [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0065FF)),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Memuat...',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  )
                : Text(
                    hint,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              );
            }).toList(),
            onChanged: enabled && !loading ? onChanged : null,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF64748B),
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
