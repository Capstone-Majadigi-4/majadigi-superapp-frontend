import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/bapenda_provider.dart';
import 'package:majadigi_superapp_frontend/models/bapenda_model.dart';
import 'bapenda_billing_screen.dart';
import 'bapenda_etbpkb_screen.dart';

class BapendaVehicleDetailScreen extends StatefulWidget {
  final String platNomor;
  final String merk;

  const BapendaVehicleDetailScreen({
    super.key,
    required this.platNomor,
    required this.merk,
  });

  @override
  State<BapendaVehicleDetailScreen> createState() => _BapendaVehicleDetailScreenState();
}

class _BapendaVehicleDetailScreenState extends State<BapendaVehicleDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BapendaProvider>(context, listen: false);
      provider.fetchBillDetail(widget.platNomor);
      provider.fetchPaymentHistory();
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
                          color: Colors.white.withOpacity(0.2),
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
                            'Bapenda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pajak Daerah Kota Malang',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
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
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('💰', style: TextStyle(fontSize: 20)),
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
                  if (provider.isLoadingBill) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0065FF)),
                      ),
                    );
                  }

                  if (provider.errorBill != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'Gagal memuat detail tagihan.\n${provider.errorBill}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => provider.fetchBillDetail(widget.platNomor),
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              label: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0065FF),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }

                  final bill = provider.currentBill;
                  if (bill == null) {
                    return const Center(
                      child: Text('Data tagihan tidak ditemukan'),
                    );
                  }

                  final vehicle = provider.vehicles.firstWhere(
                    (v) => v.platNomor == widget.platNomor,
                    orElse: () => BapendaVehicle(
                      platNomor: widget.platNomor,
                      merk: widget.merk.split(' / ').first,
                      tipe: widget.merk.contains(' / ') ? widget.merk.split(' / ').last : '',
                      tanggalJatuhTempo: bill.jatuhTempo,
                      isWarning: false,
                      statusText: bill.statusBayar,
                      pemilik: 'Budi Sintara',
                      noRangka: 'MH1JM3118KK123456',
                      noMesin: 'JM31E1234567',
                      tahun: 2021,
                    ),
                  );

                  final isPaid = bill.statusBayar.toLowerCase() == 'lunas';

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Alert Box
                        if (isPaid)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFF059669).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                              ]
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Pembayaran Lunas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      SizedBox(height: 2),
                                      Text('Pajak kendaraan Anda telah terbayar.', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        else if (vehicle.isWarning)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF8A00), Color(0xFFFF5E00)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFFFF5E00).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                              ]
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.white, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Segera Jatuh Tempo!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      const SizedBox(height: 2),
                                      Text(vehicle.statusText, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Kendaraan Terdaftar Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Kendaraan Terdaftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            Row(
                              children: [
                                if (isPaid)
                                  GestureDetector(
                                    onTap: () {
                                      final payment = provider.paymentHistory.firstWhere(
                                        (p) => p.platNomor == widget.platNomor,
                                        orElse: () => BapendaPaymentHistory(
                                          id: 'VA-${widget.platNomor.replaceAll(' ', '')}',
                                          platNomor: widget.platNomor,
                                          tanggalBayar: '',
                                          jumlah: bill.totalTagihan,
                                          status: 'success',
                                          kodeBayar: '',
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BapendaEtbpkbScreen(etbpkbId: payment.id),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300)
                                      ),
                                      child: Row(
                                        children: const [
                                          Icon(Icons.assignment_turned_in, size: 14, color: Color(0xFF10B981)),
                                          SizedBox(width: 4),
                                          Text('E-TBPKB', style: TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300)
                                  ),
                                  child: Text('${provider.vehicles.length} Kendaraan', style: const TextStyle(fontSize: 10, color: Colors.black87)),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Tagihan Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Vehicle Info
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                                    child: const Icon(Icons.directions_car, color: Color(0xFF3B82F6), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.platNomor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                                        const SizedBox(height: 2),
                                        Text('${bill.merk} / ${bill.tipe}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isPaid ? const Color(0xFFECFDF5) : const Color(0xFFFFF7ED),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: isPaid ? const Color(0xFF10B981) : const Color(0xFFFDBA74)),
                                    ),
                                    child: Text(
                                      isPaid ? 'Lunas' : 'Belum Bayar',
                                      style: TextStyle(
                                        color: isPaid ? const Color(0xFF047857) : const Color(0xFFC2410C),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                              const SizedBox(height: 20),

                              // Jatuh Tempo Box
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isPaid ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isPaid ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isPaid ? Icons.check_circle_outline : Icons.calendar_today_outlined,
                                      color: isPaid ? const Color(0xFF059669) : const Color(0xFFD97706),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isPaid ? 'Status Pembayaran' : 'Jatuh Tempo Pembayaran',
                                          style: TextStyle(
                                            color: isPaid ? const Color(0xFF047857) : const Color(0xFF92400E),
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isPaid ? 'Lunas' : vehicle.tanggalJatuhTempo,
                                          style: TextStyle(
                                            color: isPaid ? const Color(0xFF047857) : const Color(0xFF92400E),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Detail Teknis Kendaraan (Premium Feel)
                              const Text('Detail Kendaraan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                              const SizedBox(height: 12),
                              _buildDetailRow('Pemilik', vehicle.pemilik),
                              const SizedBox(height: 8),
                              _buildDetailRow('No. Rangka', vehicle.noRangka),
                              const SizedBox(height: 8),
                              _buildDetailRow('No. Mesin', vehicle.noMesin),
                              const SizedBox(height: 8),
                              _buildDetailRow('Tahun Pembuatan', vehicle.tahun.toString()),
                              const SizedBox(height: 20),
                              const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                              const SizedBox(height: 20),

                              // Rincian Tagihan
                              const Text('Rincian Tagihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('PKB (Pajak Kendaraan Bermotor)', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  Text('Rp ${_formatMoney(bill.pkbPokok)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('SWDKLLJ', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  Text('Rp ${_formatMoney(bill.swdkljj)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Biaya Admin', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  Text('Rp ${_formatMoney(bill.biayaAdmin)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Denda', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  Text('Rp ${_formatMoney(bill.denda)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Tagihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                                  Text('Rp ${_formatMoney(bill.totalTagihan)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3B82F6))),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Button
                              if (isPaid)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: const Color(0xFF059669).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                                    ]
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final payment = provider.paymentHistory.firstWhere(
                                        (p) => p.platNomor == widget.platNomor,
                                        orElse: () => BapendaPaymentHistory(
                                          id: 'VA-${widget.platNomor.replaceAll(' ', '')}',
                                          platNomor: widget.platNomor,
                                          tanggalBayar: '',
                                          jumlah: bill.totalTagihan,
                                          status: 'success',
                                          kodeBayar: '',
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BapendaEtbpkbScreen(etbpkbId: payment.id),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.assignment_turned_in, color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Text('Lihat E-TBPKB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                                    ]
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final dynamicResult = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => BapendaBillingScreen(
                                          platNomor: widget.platNomor,
                                          merk: '${bill.merk} / ${bill.tipe}',
                                        )),
                                      );
                                      if (dynamicResult == true) {
                                        provider.fetchBillDetail(widget.platNomor);
                                        provider.fetchPaymentHistory();
                                        provider.fetchVehicles();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.payment, color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Text('Bayar Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Footer
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Sumber Data : Badan Pendapatan Daerah Provinsi Jawa Timur',
                                style: TextStyle(color: Color(0xFF3B82F6), fontSize: 11),
                              ),
                            )
                          ],
                        ),
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

  Widget _buildDetailRow(String label, String value) {
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
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
