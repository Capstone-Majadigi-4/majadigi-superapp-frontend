import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bansos_provider.dart';
import '../providers/module_provider.dart';
import '../widgets/sapabansos_program_card.dart';

class SapabansosStatusScreen extends StatefulWidget {
  const SapabansosStatusScreen({super.key});

  @override
  State<SapabansosStatusScreen> createState() => _SapabansosStatusScreenState();
}

class _SapabansosStatusScreenState extends State<SapabansosStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BansosProvider>(context, listen: false).fetchBansosStatus();
    });
  }

  String _calculateTotalMonthly(List<dynamic> programs) {
    int total = 0;
    for (var p in programs) {
      final nominalText = p.nominal.toLowerCase();
      if (nominalText.contains('/bulan') || nominalText.contains('per bulan')) {
        final regExp = RegExp(r'\d[\d.]*');
        final match = regExp.firstMatch(p.nominal);
        if (match != null) {
          final cleanNum = match.group(0)!.replaceAll('.', '');
          final parsed = int.tryParse(cleanNum);
          if (parsed != null) {
            total += parsed;
          }
        }
      }
    }
    if (total == 0) {
      return 'Rp 200.000';
    }
    final formatted = total.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0078FF), Color(0xFF0046B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
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
                            'Status Penerima Bansos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Layanan Administrasi Bansos',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<ModuleProvider>(
                      builder: (context, moduleProvider, _) {
                        final isFav = moduleProvider.isFavorite('sapabansos');
                        return GestureDetector(
                          onTap: () => moduleProvider.toggleFavorite('sapabansos'),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? const Color(0xFFEF4444) : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // 2. Main Content Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC), 
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Consumer<BansosProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (provider.errorMessage != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal memuat status: ${provider.errorMessage}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => provider.fetchBansosStatus(),
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final status = provider.bansosStatus;
                      if (status == null) {
                        return const Center(
                          child: Text('Tidak ada data status bansos'),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Green Status Kelayakan Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981), // Emerald Green
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Status Kelayakan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const Spacer(),
                                      Consumer<ModuleProvider>(
                                        builder: (context, moduleProvider, _) {
                                          final isFav = moduleProvider.isFavorite('sapabansos');
                                          return GestureDetector(
                                            onTap: () => moduleProvider.toggleFavorite('sapabansos'),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                isFav ? Icons.favorite : Icons.favorite_border,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Terdaftar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Inter',
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Anda berhak menerima bantuan sosial',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Bottom Statistics Panel
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total Bantuan Bulanan',
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.8),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _calculateTotalMonthly(status.programs),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 36,
                                          width: 1,
                                          color: Colors.white.withOpacity(0.3),
                                          margin: const EdgeInsets.symmetric(horizontal: 16),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Terdaftar di',
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.8),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${status.programs.length} Program',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Rincian Bantuan Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Rincian Bantuan',
                                  style: TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Update: Hari ini',
                                  style: TextStyle(
                                    color: const Color(0xFF64748B),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Program Cards List
                            ...status.programs.map((program) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: SapabansosProgramCard(
                                title: program.title,
                                status: program.status,
                                nominal: program.nominal,
                                distributionDate: program.distributionDate,
                              ),
                            )),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
