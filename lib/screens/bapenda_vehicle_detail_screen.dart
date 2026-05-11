import 'package:flutter/material.dart';
import 'bapenda_billing_screen.dart';

class BapendaVehicleDetailScreen extends StatelessWidget {
  final String platNomor;
  final String merk;

  const BapendaVehicleDetailScreen({
    super.key,
    required this.platNomor,
    required this.merk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0046B2), // Matches gradient bottom
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Orange Alert Box
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
                          BoxShadow(color: const Color(0xFFFF5E00).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                        ]
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Segera Jatuh Tempo!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 2),
                              Text('5 hari lagi • 2026-05-15', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          )
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300)
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.history, size: 14, color: Colors.black54),
                                  SizedBox(width: 4),
                                  Text('Riwayat', style: TextStyle(fontSize: 10, color: Colors.black87)),
                                ],
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
                              child: const Text('1 Kendaraan', style: TextStyle(fontSize: 10, color: Colors.black87)),
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
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
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
                                    Text(platNomor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                                    const SizedBox(height: 2),
                                    Text(merk, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7ED),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFFDBA74)),
                                ),
                                child: const Text('Belum Bayar', style: TextStyle(color: Color(0xFFC2410C), fontSize: 10, fontWeight: FontWeight.bold)),
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
                              color: const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFDE68A)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, color: Color(0xFFD97706), size: 20),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Jatuh Tempo Pembayaran', style: TextStyle(color: Color(0xFF92400E), fontSize: 10)),
                                    SizedBox(height: 2),
                                    Text('20 April 2025', style: TextStyle(color: Color(0xFF92400E), fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Rincian Tagihan
                          const Text('Rincian Tagihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('PKB (Pajak Kendaraan Bermotor)', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                              Text('Rp 150.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('SWDKLLJ', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                              Text('Rp 35.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Total Tagihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                              Text('Rp 185.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3B82F6))),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Blue Gradient Button
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
                                BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                              ]
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BapendaBillingScreen(
                                    platNomor: platNomor,
                                    merk: merk,
                                  )),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
