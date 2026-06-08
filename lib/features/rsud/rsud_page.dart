import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/widgets/admin_shell.dart';

class RsudPage extends StatefulWidget {
  const RsudPage({super.key});

  @override
  State<RsudPage> createState() => _RsudPageState();
}

class _RsudPageState extends State<RsudPage>
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
          title: const Text('RSUD Dr. Saiful Anwar'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer())
              : null,
          bottom: TabBar(
            controller: _tab,
            tabs: const [
              Tab(text: 'Daftar Antrean Poli'),
              Tab(text: 'Manajemen Antrean'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: [
            const _AntreanListTab(),
            _ManajemenAntreanTab(),
          ],
        ),
      ),
    );
  }
}

class _AntreanListTab extends StatelessWidget {
  const _AntreanListTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat row
          Row(
            children: [
              Expanded(
                  child: _PoliCard(
                      poli: 'Poli Umum',
                      total: 48,
                      sedangDilayani: 12,
                      warna: AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(
                  child: _PoliCard(
                      poli: 'Poli Dalam',
                      total: 35,
                      sedangDilayani: 7,
                      warna: const Color(0xFFC62828))),
              const SizedBox(width: 12),
              Expanded(
                  child: _PoliCard(
                      poli: 'Poli Anak',
                      total: 29,
                      sedangDilayani: 5,
                      warna: const Color(0xFF00838F))),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Daftar Pasien Online — Hari Ini',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                    AppColors.scaffoldBg),
                columns: const [
                  DataColumn(label: Text('No. Antrean')),
                  DataColumn(label: Text('Nama Pasien')),
                  DataColumn(label: Text('Poli')),
                  DataColumn(label: Text('Dokter')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('ETA')),
                ],
                rows: _dummyAntrean
                    .map((a) => DataRow(cells: [
                          DataCell(Text(a['nomor']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary))),
                          DataCell(Text(a['nama']!)),
                          DataCell(Text(a['poli']!)),
                          DataCell(Text(a['dokter']!,
                              style: const TextStyle(fontSize: 12))),
                          DataCell(_statusBadge(a['status']!)),
                          DataCell(Text(a['eta']!,
                              style: const TextStyle(fontSize: 12))),
                        ]))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String s) {
    StatusType t;
    if (s == 'Sedang Dilayani') t = StatusType.info;
    else if (s == 'Selesai') t = StatusType.success;
    else if (s == 'Menunggu') t = StatusType.warning;
    else t = StatusType.neutral;
    return StatusBadge(label: s, type: t);
  }
}

class _PoliCard extends StatelessWidget {
  final String poli;
  final int total;
  final int sedangDilayani;
  final Color warna;

  const _PoliCard(
      {required this.poli,
      required this.total,
      required this.sedangDilayani,
      required this.warna});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: warna.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(poli,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: warna)),
          const SizedBox(height: 6),
          Text('$total',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700, color: warna)),
          Text('antrean total',
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Dilayani: #$sedangDilayani',
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ManajemenAntreanTab extends StatefulWidget {
  @override
  State<_ManajemenAntreanTab> createState() => _ManajemenAntreanTabState();
}

class _ManajemenAntreanTabState extends State<_ManajemenAntreanTab> {
  int _current = 12;
  String _selectedPoli = 'Poli Umum';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Pilih Poli
          Row(
            children: [
              const Text('Poli: ',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedPoli,
                items: ['Poli Umum', 'Poli Dalam', 'Poli Anak', 'Poli THT']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _selectedPoli = v ?? _selectedPoli),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Big counter
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC62828), Color(0xFFE53935)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Nomor Sedang Dilayani',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 8),
                Text('$_current',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w800)),
                Text(_selectedPoli,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Control buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      setState(() => _current = (_current - 1).clamp(1, 999)),
                  icon: const Icon(Icons.skip_previous),
                  label: const Text('Mundur'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _current++),
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Panggil Berikutnya'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Antrean dilompati'))),
              icon: const Icon(Icons.fast_forward),
              label: const Text('Skip (Tidak Hadir)'),
            ),
          ),
        ],
      ),
    );
  }
}

final _dummyAntrean = [
  {'nomor': '001', 'nama': 'Budi Santoso', 'poli': 'Poli Umum', 'dokter': 'dr. Hendra, Sp.U', 'status': 'Selesai', 'eta': '08:30'},
  {'nomor': '012', 'nama': 'Siti Rahayu', 'poli': 'Poli Umum', 'dokter': 'dr. Hendra, Sp.U', 'status': 'Sedang Dilayani', 'eta': '09:15'},
  {'nomor': '013', 'nama': 'Ahmad Fauzi', 'poli': 'Poli Dalam', 'dokter': 'dr. Rina, Sp.PD', 'status': 'Menunggu', 'eta': '09:30'},
  {'nomor': '014', 'nama': 'Rina Puspita', 'poli': 'Poli Dalam', 'dokter': 'dr. Rina, Sp.PD', 'status': 'Menunggu', 'eta': '09:45'},
  {'nomor': '015', 'nama': 'Dodi Prasetyo', 'poli': 'Poli Anak', 'dokter': 'dr. Sari, Sp.A', 'status': 'Menunggu', 'eta': '10:00'},
];
