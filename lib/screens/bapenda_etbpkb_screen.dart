import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/bapenda_provider.dart';

class BapendaEtbpkbScreen extends StatefulWidget {
  final String etbpkbId;

  const BapendaEtbpkbScreen({
    super.key,
    required this.etbpkbId,
  });

  @override
  State<BapendaEtbpkbScreen> createState() => _BapendaEtbpkbScreenState();
}

class _BapendaEtbpkbScreenState extends State<BapendaEtbpkbScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BapendaProvider>(context, listen: false).fetchEtbpkb(widget.etbpkbId);
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
      backgroundColor: const Color(0xFF0065FF),
      body: Stack(
        children: [
          // Background design elements
          Positioned(
            left: -150,
            top: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -100,
            bottom: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'E-TBPKB Digital',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Receipt Card Area
                Expanded(
                  child: Consumer<BapendaProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoadingEtbpkb) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      }

                      if (provider.errorEtbpkb != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, color: Colors.white, size: 48),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal memuat E-TBPKB.\n${provider.errorEtbpkb}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => provider.fetchEtbpkb(widget.etbpkbId),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF0065FF),
                                  ),
                                  child: const Text('Coba Lagi'),
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      final etbpkb = provider.currentEtbpkb;
                      if (etbpkb == null) {
                        return const Center(
                          child: Text(
                            'Data E-TBPKB tidak ditemukan',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Column(
                            children: [
                              // Top content
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF10B981),
                                      size: 56,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'BUKTI PELUNASAN PAJAK DIGITAL',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'No. Transaksi: ${etbpkb.id}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Divider(color: Color(0xFFE2E8F0)),
                                    const SizedBox(height: 16),
                                    _buildDetailRow('No. Registrasi / Nopol', etbpkb.nopol, isBoldValue: true),
                                    const SizedBox(height: 10),
                                    _buildDetailRow('Nama Pemilik', etbpkb.pemilik),
                                    const SizedBox(height: 10),
                                    _buildDetailRow('Merk / Tipe', etbpkb.merkTipe),
                                    const SizedBox(height: 10),
                                    _buildDetailRow('Tahun Pembuatan', etbpkb.tahun.toString()),
                                    const SizedBox(height: 10),
                                    _buildDetailRow('Tanggal Bayar', etbpkb.tanggalBayar),
                                    const SizedBox(height: 10),
                                    _buildDetailRow('Jumlah Bayar', 'Rp ${_formatMoney(etbpkb.jumlah)}', isBoldValue: true, valueColor: const Color(0xFF0065FF)),
                                  ],
                                ),
                              ),

                              // Dashed Line Divider with circles
                              Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0065FF),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: List.generate(
                                            (constraints.constrainWidth() / 10).floor(),
                                            (index) => const SizedBox(
                                              width: 5,
                                              height: 1,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(color: Color(0xFFCBD5E1)),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 16,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0065FF),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Bottom content: QR Code & Status
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Image.network(
                                          etbpkb.qrCodeData,
                                          width: 140,
                                          height: 140,
                                          errorBuilder: (context, error, stackTrace) => const Icon(
                                            Icons.qr_code_2,
                                            size: 140,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'E-TBPKB ini sah dan diterbitkan secara digital oleh Bapenda Provinsi Jawa Timur.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF64748B),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Action Button (Unduh PDF simulation)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('E-TBPKB berhasil diunduh sebagai PDF'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download, color: Color(0xFF0065FF)),
                      label: const Text(
                        'Unduh E-TBPKB (PDF)',
                        style: TextStyle(
                          color: Color(0xFF0065FF),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBoldValue = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF1E293B),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
