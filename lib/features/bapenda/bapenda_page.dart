import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/widgets/admin_shell.dart';

class BapendaPage extends StatefulWidget {
  const BapendaPage({super.key});

  @override
  State<BapendaPage> createState() => _BapendaPageState();
}

class _BapendaPageState extends State<BapendaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _filterStatus = 'Semua';

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
          title: const Text('Bapenda Jatim'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer())
              : null,
          bottom: TabBar(
            controller: _tab,
            tabs: const [
              Tab(text: 'Rekapitulasi Transaksi'),
              Tab(text: 'Cari Kode Bayar'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: [
            _RekaptTab(
                filterStatus: _filterStatus,
                onFilterChange: (v) =>
                    setState(() => _filterStatus = v ?? 'Semua')),
            const _CariKodeBayarTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Tab 1: Rekapitulasi ──────────────────────────────────────────────────────
class _RekaptTab extends StatelessWidget {
  final String filterStatus;
  final ValueChanged<String?> onFilterChange;

  const _RekaptTab(
      {required this.filterStatus, required this.onFilterChange});

  @override
  Widget build(BuildContext context) {
    final filtered = filterStatus == 'Semua'
        ? _dummyTransaksi
        : _dummyTransaksi
            .where((t) => t['status'] == filterStatus)
            .toList();

    return Column(
      children: [
        // Stats row
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  child: _MiniStatCard(
                      label: 'Total Hari Ini',
                      value: 'Rp 842 Jt',
                      color: AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(
                  child: _MiniStatCard(
                      label: 'Berhasil',
                      value: '1.284',
                      color: AppColors.success)),
              const SizedBox(width: 12),
              Expanded(
                  child: _MiniStatCard(
                      label: 'Pending',
                      value: '43',
                      color: AppColors.warning)),
            ],
          ),
        ),
        // Filter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('Filter Status: ',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: filterStatus,
                items: ['Semua', 'Berhasil', 'Pending', 'Kedaluwarsa']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: onFilterChange,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Table
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                      AppColors.scaffoldBg),
                  columns: const [
                    DataColumn(label: Text('No. Polisi')),
                    DataColumn(label: Text('Nama WP')),
                    DataColumn(label: Text('Jenis Pajak')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Waktu')),
                  ],
                  rows: filtered
                      .map((t) => DataRow(cells: [
                            DataCell(Text(t['noPolisi']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600))),
                            DataCell(Text(t['nama']!)),
                            DataCell(Text(t['jenis']!)),
                            DataCell(Text(t['total']!)),
                            DataCell(_statusBadge(t['status']!)),
                            DataCell(Text(t['waktu']!,
                                style: const TextStyle(fontSize: 12))),
                          ]))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    StatusType type;
    switch (status) {
      case 'Berhasil':
        type = StatusType.success;
        break;
      case 'Pending':
        type = StatusType.warning;
        break;
      default:
        type = StatusType.neutral;
    }
    return StatusBadge(label: status, type: type);
  }
}

// ─── Tab 2: Cari Kode Bayar ───────────────────────────────────────────────────
class _CariKodeBayarTab extends StatefulWidget {
  const _CariKodeBayarTab();

  @override
  State<_CariKodeBayarTab> createState() => _CariKodeBayarTabState();
}

class _CariKodeBayarTabState extends State<_CariKodeBayarTab> {
  final _ctrl = TextEditingController();
  Map<String, String>? _result;

  void _cari() {
    setState(() {
      _result = {
        'noPolisi': 'B 4567 ABC',
        'nama': 'Dodi Prasetyo',
        'kodeVA': '88810012345678',
        'total': 'Rp 1.250.000',
        'status': 'Menunggu Pembayaran',
        'expiry': '09 Jun 2025, 23:59',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Masukkan Nomor Polisi atau Kode VA',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  decoration: const InputDecoration(
                      hintText: 'Contoh: B 1234 XYZ atau 88810012345678'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _cari,
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Cari'),
              ),
            ],
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hasil Pencarian',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const Divider(),
                    ..._result!.entries.map((e) => Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 140,
                                  child: Text(e.key,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13))),
                              Text(e.value,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Mini stat card ───────────────────────────────────────────────────────────
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStatCard(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── Dummy data ───────────────────────────────────────────────────────────────
final _dummyTransaksi = [
  {
    'noPolisi': 'B 1234 XYZ',
    'nama': 'Dodi Prasetyo',
    'jenis': 'PKB + SWDKLLJ',
    'total': 'Rp 850.000',
    'status': 'Berhasil',
    'waktu': '09:14, 3 Jun 2025'
  },
  {
    'noPolisi': 'L 5678 ABC',
    'nama': 'Siti Rahayu',
    'jenis': 'PKB',
    'total': 'Rp 620.000',
    'status': 'Berhasil',
    'waktu': '09:02, 3 Jun 2025'
  },
  {
    'noPolisi': 'AE 9900 ZZ',
    'nama': 'Budi Santoso',
    'jenis': 'PKB + Denda',
    'total': 'Rp 1.250.000',
    'status': 'Pending',
    'waktu': '08:55, 3 Jun 2025'
  },
  {
    'noPolisi': 'W 4321 QQ',
    'nama': 'Ahmad Fauzi',
    'jenis': 'SWDKLLJ',
    'total': 'Rp 143.000',
    'status': 'Berhasil',
    'waktu': '08:30, 3 Jun 2025'
  },
  {
    'noPolisi': 'N 1111 AA',
    'nama': 'Rina Sari',
    'jenis': 'PKB',
    'total': 'Rp 720.000',
    'status': 'Kedaluwarsa',
    'waktu': '07:50, 3 Jun 2025'
  },
];
