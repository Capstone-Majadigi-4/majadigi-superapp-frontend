import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/widgets/admin_shell.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      child: Scaffold(
        appBar: MobileAdminBar(title: 'Dashboard'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selamat Datang, Admin 👋',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 4),
                    Text(
                        'Portal Admin Majadigi — Super App Layanan Publik Jawa Timur',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _QuickStat(
                            label: 'Modul Aktif',
                            value: '10',
                            icon: Icons.grid_view),
                        const SizedBox(width: 16),
                        _QuickStat(
                            label: 'Total Pengguna',
                            value: '124.8K',
                            icon: Icons.people_outline),
                        const SizedBox(width: 16),
                        _QuickStat(
                            label: 'Transaksi Hari Ini',
                            value: '3.241',
                            icon: Icons.receipt_outlined),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stat cards
              const SectionHeader(title: 'Ringkasan Sistem'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 2 : 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.8,
                children: const [
                  StatCard(
                      title: 'Pembayaran Pajak Hari Ini',
                      value: 'Rp 842 Jt',
                      icon: Icons.directions_car_outlined,
                      color: AppColors.primary,
                      subtitle: '+12% dari kemarin'),
                  StatCard(
                      title: 'Antrean RSUD Online',
                      value: '218',
                      icon: Icons.local_hospital_outlined,
                      color: Color(0xFFC62828),
                      subtitle: 'Hari ini'),
                  StatCard(
                      title: 'Lowongan Aktif (Sinaker)',
                      value: '1.042',
                      icon: Icons.work_outline,
                      color: Color(0xFF283593),
                      subtitle: 'Dari 342 perusahaan'),
                  StatCard(
                      title: 'Booking Islamic Center',
                      value: '37',
                      icon: Icons.mosque_outlined,
                      color: Color(0xFF6A1B9A),
                      subtitle: 'Menunggu approval'),
                ],
              ),
              const SizedBox(height: 24),

              // Module Grid
              const SectionHeader(title: 'Akses Cepat Modul'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 3 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: allModules
                    .map((m) => _ModuleCard(module: m))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Recent activity
              const SectionHeader(title: 'Aktivitas Terbaru'),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: _recentActivity
                      .map((a) => _ActivityTile(activity: a))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Supporting widgets ───────────────────────────────────────────────────────

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _QuickStat(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins')),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                    fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final ModuleInfo module;
  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go(module.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: module.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(module.icon, color: module.color, size: 26),
              ),
              const SizedBox(height: 10),
              Text(module.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(module.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityData {
  final String title;
  final String time;
  final IconData icon;
  final Color color;
  _ActivityData(this.title, this.time, this.icon, this.color);
}

final _recentActivity = [
  _ActivityData('Pembayaran pajak PKB berhasil — B 1234 XYZ',
      '2 menit lalu', Icons.check_circle_outline, AppColors.success),
  _ActivityData('Booking Islamic Center baru — Ahmad Fauzi',
      '15 menit lalu', Icons.event_outlined, const Color(0xFF6A1B9A)),
  _ActivityData('Lowongan baru diterbitkan — PT Semen Indonesia',
      '1 jam lalu', Icons.work_outline, const Color(0xFF283593)),
  _ActivityData('Harga beras diperbarui — Admin Disperindag',
      '2 jam lalu', Icons.shopping_basket_outlined, const Color(0xFF2E7D32)),
  _ActivityData('Antrean RSUD — 50 pasien terdaftar hari ini',
      '3 jam lalu', Icons.local_hospital_outlined, const Color(0xFFC62828)),
];

class _ActivityTile extends StatelessWidget {
  final _ActivityData activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: activity.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(activity.icon, color: activity.color, size: 20),
      ),
      title: Text(activity.title,
          style: const TextStyle(fontSize: 13)),
      subtitle: Text(activity.time,
          style: const TextStyle(
              fontSize: 11, color: AppColors.textHint)),
      dense: true,
    );
  }
}
