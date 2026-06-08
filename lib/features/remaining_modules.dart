// ─────────────────────────────────────────────────────────────────────────────
//  remaining_modules.dart  —  Modul 5-10 (simplified admin pages)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/widgets/admin_shell.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  5. NOMER DARURAT
// ═══════════════════════════════════════════════════════════════════════════════
class NomerDaruratPage extends StatefulWidget {
  const NomerDaruratPage({super.key});

  @override
  State<NomerDaruratPage> createState() => _NomerDaruratPageState();
}

class _NomerDaruratPageState extends State<NomerDaruratPage> {
  final List<Map<String, dynamic>> _list = [
    {'kategori': 'Pusat', 'nama': 'Command Center 112', 'nomor': '112', 'icon': Icons.emergency, 'aktif': true},
    {'kategori': 'Polisi', 'nama': 'Polda Jawa Timur', 'nomor': '110', 'icon': Icons.local_police_outlined, 'aktif': true},
    {'kategori': 'Medis', 'nama': 'Ambulans / PSC 119', 'nomor': '119', 'icon': Icons.local_hospital_outlined, 'aktif': true},
    {'kategori': 'Pemadam', 'nama': 'Damkar Jatim', 'nomor': '113', 'icon': Icons.local_fire_department_outlined, 'aktif': true},
    {'kategori': 'SAR', 'nama': 'Basarnas Jatim', 'nomor': '115', 'icon': Icons.health_and_safety_outlined, 'aktif': false},
  ];

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nomer Darurat'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer())
              : null,
          actions: [
            ElevatedButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Tambah'),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.danger.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.danger, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nomor darurat tampil sebagai FAB global di seluruh halaman aplikasi. Pastikan semua nomor valid dan terverifikasi.',
                      style: TextStyle(fontSize: 12, color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final item = _list[i];
                  return Card(
                    child: ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item['icon'] as IconData, color: AppColors.danger, size: 22),
                      ),
                      title: Text(item['nama'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('Kategori: ${item['kategori']}  |  ${item['nomor']}',
                          style: const TextStyle(fontSize: 12)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: item['aktif'] as bool,
                            activeColor: AppColors.success,
                            onChanged: (v) => setState(() => _list[i]['aktif'] = v),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                            onPressed: () async {
                              final ok = await showConfirmDialog(context,
                                  title: 'Hapus Nomor', content: 'Yakin hapus "${item['nama']}"?');
                              if (ok) setState(() => _list.removeAt(i));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    final namaCtrl = TextEditingController();
    final nomorCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Nomor Darurat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama Layanan')),
            const SizedBox(height: 12),
            TextField(controller: nomorCtrl, keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Nomor Telepon')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() => _list.add({
                    'kategori': 'Lainnya', 'nama': namaCtrl.text,
                    'nomor': nomorCtrl.text, 'icon': Icons.phone, 'aktif': true,
                  }));
              Navigator.pop(ctx);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  6. DESTINASI WISATA
// ═══════════════════════════════════════════════════════════════════════════════
class DestinasiWisataPage extends StatefulWidget {
  const DestinasiWisataPage({super.key});

  @override
  State<DestinasiWisataPage> createState() => _DestinasiWisataPageState();
}

class _DestinasiWisataPageState extends State<DestinasiWisataPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Destinasi Wisata'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer())
              : null,
          bottom: TabBar(
            controller: _tab,
            tabs: const [Tab(text: 'Katalog Wisata'), Tab(text: 'Validasi Tiket')],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: [_KatalogWisataTab(), const _ValidasiTiketTab()],
        ),
      ),
    );
  }
}

class _KatalogWisataTab extends StatefulWidget {
  @override
  State<_KatalogWisataTab> createState() => _KatalogWisataTabState();
}

class _KatalogWisataTabState extends State<_KatalogWisataTab> {
  final List<Map<String, String>> _list = [
    {'nama': 'Bromo Tengger Semeru', 'kota': 'Probolinggo', 'kategori': 'Alam', 'harga': '29.000', 'jam': '05:00 - 18:00'},
    {'nama': 'Kawah Ijen', 'kota': 'Banyuwangi', 'kategori': 'Alam', 'harga': '15.000', 'jam': '01:00 - 14:00'},
    {'nama': 'Candi Singosari', 'kota': 'Malang', 'kategori': 'Budaya', 'harga': '5.000', 'jam': '08:00 - 16:00'},
    {'nama': 'Jatim Park 1', 'kota': 'Batu', 'kategori': 'Buatan', 'harga': '110.000', 'jam': '09:00 - 17:00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showForm(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah Destinasi'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final item = _list[i];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00695C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.landscape_outlined, color: Color(0xFF00695C)),
                  ),
                  title: Text(item['nama']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('${item['kota']} • ${item['kategori']} • Rp ${item['harga']}',
                      style: const TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _showForm(existing: item, index: i)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                        onPressed: () async {
                          final ok = await showConfirmDialog(context,
                              title: 'Hapus Destinasi', content: 'Hapus "${item['nama']}"?');
                          if (ok) setState(() => _list.removeAt(i));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showForm({Map<String, String>? existing, int? index}) {
    final namaCtrl = TextEditingController(text: existing?['nama'] ?? '');
    final kotaCtrl = TextEditingController(text: existing?['kota'] ?? '');
    final hargaCtrl = TextEditingController(text: existing?['harga'] ?? '');
    final jamCtrl = TextEditingController(text: existing?['jam'] ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(existing == null ? 'Tambah Destinasi' : 'Edit Destinasi',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 16),
            TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama Destinasi')),
            const SizedBox(height: 12),
            TextField(controller: kotaCtrl, decoration: const InputDecoration(labelText: 'Kota/Kabupaten')),
            const SizedBox(height: 12),
            TextField(controller: hargaCtrl, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Tiket (Rp)')),
            const SizedBox(height: 12),
            TextField(controller: jamCtrl, decoration: const InputDecoration(labelText: 'Jam Operasional')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    final item = {'nama': namaCtrl.text, 'kota': kotaCtrl.text,
                        'harga': hargaCtrl.text, 'jam': jamCtrl.text,
                        'kategori': existing?['kategori'] ?? 'Alam'};
                    if (index != null) _list[index] = item;
                    else _list.add(item);
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValidasiTiketTab extends StatelessWidget {
  const _ValidasiTiketTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(Icons.qr_code_scanner, size: 60, color: AppColors.success),
            ),
            const SizedBox(height: 24),
            const Text('Scanner E-Ticket Wisata', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Fitur scan QR Code digunakan oleh petugas loket wisata untuk memvalidasi tiket pengunjung.',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Kamera scanner akan terbuka di perangkat'))),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Buka Kamera Scanner'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  7. INFO BANSOS
// ═══════════════════════════════════════════════════════════════════════════════
class InfoBansosPage extends StatefulWidget {
  const InfoBansosPage({super.key});

  @override
  State<InfoBansosPage> createState() => _InfoBansosPageState();
}

class _InfoBansosPageState extends State<InfoBansosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Info Bansos'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer())
              : null,
          bottom: TabBar(
            controller: _tab,
            tabs: const [Tab(text: 'Sinkronisasi Data'), Tab(text: 'Pengumuman')],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: [const _SinkronisasiTab(), _PengumumanTab()],
        ),
      ),
    );
  }
}

class _SinkronisasiTab extends StatelessWidget {
  const _SinkronisasiTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.sync, color: AppColors.success),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sinkronisasi DTKS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          Text('Terakhir sinkron: Hari ini, 06:00 WIB',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(child: _StatItem(label: 'Total Penerima', value: '1.248.320')),
                      Expanded(child: _StatItem(label: 'PKH', value: '423.100')),
                      Expanded(child: _StatItem(label: 'BPNT', value: '825.220')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Upload CSV untuk bulk update data'))),
                    icon: const Icon(Icons.upload_file_outlined, size: 18),
                    label: const Text('Upload CSV DTKS Terbaru'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Sinkronisasi dimulai...'))),
                    icon: const Icon(Icons.sync, size: 18),
                    label: const Text('Mulai Sinkronisasi API'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _PengumumanTab extends StatefulWidget {
  @override
  State<_PengumumanTab> createState() => _PengumumanTabState();
}

class _PengumumanTabState extends State<_PengumumanTab> {
  final List<Map<String, String>> _list = [
    {'judul': 'Pencairan BLT Provinsi — Juni 2025', 'tanggal': '1 Jun 2025', 'status': 'Aktif'},
    {'judul': 'Update Data DTKS — Semester I 2025', 'tanggal': '15 Mei 2025', 'status': 'Aktif'},
    {'judul': 'Informasi PKH Tahap 2 2025', 'tanggal': '10 Apr 2025', 'status': 'Selesai'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Buat Pengumuman'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final item = _list[i];
              return Card(
                child: ListTile(
                  title: Text(item['judul']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(item['tanggal']!),
                  trailing: StatusBadge(
                    label: item['status']!,
                    type: item['status'] == 'Aktif' ? StatusType.success : StatusType.neutral,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  8. SKRINING E-TIBI
// ═══════════════════════════════════════════════════════════════════════════════
class EtibiPage extends StatelessWidget {
  const EtibiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skrining E-Tibi'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer())
              : null,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats
              Row(
                children: const [
                  Expanded(child: StatCard(title: 'Total Pasien Aktif', value: '847', icon: Icons.person_outlined, color: Color(0xFF00838F))),
                  SizedBox(width: 12),
                  Expanded(child: StatCard(title: 'Peringatan Mangkir', value: '23', icon: Icons.warning_amber_outlined, color: AppColors.danger)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: StatCard(title: 'Kepatuhan Rata-rata', value: '82%', icon: Icons.check_circle_outline, color: AppColors.success)),
                  SizedBox(width: 12),
                  Expanded(child: StatCard(title: 'Selesai Terapi', value: '124', icon: Icons.verified_outlined, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 20),
              const SectionHeader(title: 'Daftar Pasien — Perlu Perhatian'),
              const SizedBox(height: 12),
              ..._dummyPasienEtibi.map((p) => _EtibiPatientCard(patient: p)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EtibiPatientCard extends StatelessWidget {
  final Map<String, String> patient;
  const _EtibiPatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    final isAlert = patient['status'] == 'Mangkir';
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isAlert ? const BorderSide(color: AppColors.danger, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isAlert ? AppColors.dangerLight : AppColors.successLight,
              child: Icon(Icons.person, color: isAlert ? AppColors.danger : AppColors.success, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient['nama']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text('Fase: ${patient['fase']}  •  Kepatuhan: ${patient['kepatuhan']}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            StatusBadge(
              label: patient['status']!,
              type: isAlert ? StatusType.danger : StatusType.success,
            ),
          ],
        ),
      ),
    );
  }
}

final _dummyPasienEtibi = [
  {'nama': 'Budi Santoso', 'fase': 'Intensif Bulan 2', 'kepatuhan': '65%', 'status': 'Mangkir'},
  {'nama': 'Siti Aminah', 'fase': 'Lanjutan Bulan 4', 'kepatuhan': '40%', 'status': 'Mangkir'},
  {'nama': 'Ahmad Farhan', 'fase': 'Intensif Bulan 1', 'kepatuhan': '90%', 'status': 'Patuh'},
  {'nama': 'Rina Wati', 'fase': 'Lanjutan Bulan 5', 'kepatuhan': '95%', 'status': 'Patuh'},
];

// ═══════════════════════════════════════════════════════════════════════════════
//  9. SINAKER
// ═══════════════════════════════════════════════════════════════════════════════
class SinakerPage extends StatefulWidget {
  const SinakerPage({super.key});

  @override
  State<SinakerPage> createState() => _SinakerPageState();
}

class _SinakerPageState extends State<SinakerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sinaker'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer())
              : null,
          bottom: TabBar(
            controller: _tab,
            tabs: const [Tab(text: 'Lowongan Aktif'), Tab(text: 'Kandidat Pelamar')],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: [_LowonganTab(), const _KandidatTab()],
        ),
      ),
    );
  }
}

class _LowonganTab extends StatefulWidget {
  @override
  State<_LowonganTab> createState() => _LowonganTabState();
}

class _LowonganTabState extends State<_LowonganTab> {
  final List<Map<String, String>> _list = [
    {'judul': 'Flutter Developer', 'perusahaan': 'PT Teknologi Nusantara', 'lokasi': 'Surabaya', 'gaji': '8-12 Jt', 'pelamar': '47', 'status': 'Aktif'},
    {'judul': 'Data Analyst', 'perusahaan': 'PT Astra Agro', 'lokasi': 'Malang', 'gaji': '7-10 Jt', 'pelamar': '92', 'status': 'Aktif'},
    {'judul': 'UI/UX Designer', 'perusahaan': 'CV Kreatif Jatim', 'lokasi': 'Sidoarjo', 'gaji': '6-9 Jt', 'pelamar': '35', 'status': 'Ditutup'},
    {'judul': 'Backend Engineer (Node.js)', 'perusahaan': 'PT Digital Raya', 'lokasi': 'Surabaya', 'gaji': '10-15 Jt', 'pelamar': '28', 'status': 'Aktif'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Posting Lowongan'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final item = _list[i];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF283593).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.work_outline, color: Color(0xFF283593)),
                  ),
                  title: Text(item['judul']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text('${item['perusahaan']} • ${item['lokasi']}',
                          style: const TextStyle(fontSize: 12)),
                      Text('Gaji: ${item['gaji']}  •  ${item['pelamar']} pelamar',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                  trailing: StatusBadge(
                    label: item['status']!,
                    type: item['status'] == 'Aktif' ? StatusType.success : StatusType.neutral,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _KandidatTab extends StatelessWidget {
  const _KandidatTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: _dummyKandidat.map((k) {
          StatusType t;
          if (k['status'] == 'Diterima') t = StatusType.success;
          else if (k['status'] == 'Ditolak') t = StatusType.danger;
          else if (k['status'] == 'Interview') t = StatusType.info;
          else t = StatusType.warning;

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(k['nama']![0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              title: Text(k['nama']!, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Melamar: ${k['posisi']}  •  ${k['tanggal']}',
                  style: const TextStyle(fontSize: 12)),
              trailing: StatusBadge(label: k['status']!, type: t),
            ),
          );
        }).toList(),
      ),
    );
  }
}

final _dummyKandidat = [
  {'nama': 'Fahmi Rachman', 'posisi': 'Flutter Developer', 'tanggal': '2 Jun 2025', 'status': 'Interview'},
  {'nama': 'Dewi Lestari', 'posisi': 'Data Analyst', 'tanggal': '1 Jun 2025', 'status': 'Review'},
  {'nama': 'Andi Kurniawan', 'posisi': 'Flutter Developer', 'tanggal': '31 Mei 2025', 'status': 'Diterima'},
  {'nama': 'Maya Putri', 'posisi': 'UI/UX Designer', 'tanggal': '30 Mei 2025', 'status': 'Ditolak'},
];

// ═══════════════════════════════════════════════════════════════════════════════
//  10. TRANSJATIM
// ═══════════════════════════════════════════════════════════════════════════════
class TransjatimPage extends StatelessWidget {
  const TransjatimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transjatim'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer())
              : null,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fleet stats
              Row(
                children: const [
                  Expanded(child: StatCard(title: 'Armada Beroperasi', value: '34', icon: Icons.directions_bus_outlined, color: Color(0xFF558B2F))),
                  SizedBox(width: 12),
                  Expanded(child: StatCard(title: 'Tiket Terjual Hari Ini', value: '2.841', icon: Icons.confirmation_number_outlined, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(child: StatCard(title: 'Total Penumpang', value: '14.290', icon: Icons.people_outline, color: Color(0xFF00838F))),
                  SizedBox(width: 12),
                  Expanded(child: StatCard(title: 'Koridor Aktif', value: '8', icon: Icons.route_outlined, color: AppColors.warning)),
                ],
              ),
              const SizedBox(height: 20),
              const SectionHeader(title: 'Status Armada Real-Time'),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: _dummyArmada.map((a) {
                    final isActive = a['status'] == 'Beroperasi';
                    return ListTile(
                      leading: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.successLight : AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.directions_bus,
                            color: isActive ? AppColors.success : AppColors.danger, size: 22),
                      ),
                      title: Text(a['plat']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('${a['koridor']}  •  ${a['halte']}',
                          style: const TextStyle(fontSize: 12)),
                      trailing: StatusBadge(
                        label: a['status']!,
                        type: isActive ? StatusType.success : StatusType.danger,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.map_outlined, size: 48, color: AppColors.info),
                    SizedBox(height: 12),
                    Text('Peta Fleet Management', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.info)),
                    Text('Integrasi Google Maps / Mapbox diperlukan', style: TextStyle(fontSize: 12, color: AppColors.info)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _dummyArmada = [
  {'plat': 'B 7001 TJ', 'koridor': 'Koridor 1 — Purabaya–Rajawali', 'halte': 'Halte Wonokromo', 'status': 'Beroperasi'},
  {'plat': 'B 7015 TJ', 'koridor': 'Koridor 2 — MERR', 'halte': 'Halte ITS', 'status': 'Beroperasi'},
  {'plat': 'B 7023 TJ', 'koridor': 'Koridor 3 — Bunder', 'halte': 'Halte Rungkut', 'status': 'Beroperasi'},
  {'plat': 'B 7030 TJ', 'koridor': 'Koridor 1', 'halte': 'Depo Surabaya', 'status': 'Tidak Beroperasi'},
];
