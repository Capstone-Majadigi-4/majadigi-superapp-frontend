import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/widgets/admin_shell.dart';

class HargaBahanPokokPage extends StatefulWidget {
  const HargaBahanPokokPage({super.key});

  @override
  State<HargaBahanPokokPage> createState() => _HargaBahanPokokPageState();
}

class _HargaBahanPokokPageState extends State<HargaBahanPokokPage>
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
          title: const Text('Harga Bahan Pokok'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer())
              : null,
          bottom: TabBar(
            controller: _tab,
            tabs: const [
              Tab(text: 'Update Harga Harian'),
              Tab(text: 'Master Komoditas'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: [
            const _UpdateHargaTab(),
            _MasterKomoditasTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Tab 1: Update Harga ──────────────────────────────────────────────────────
class _UpdateHargaTab extends StatefulWidget {
  const _UpdateHargaTab();

  @override
  State<_UpdateHargaTab> createState() => _UpdateHargaTabState();
}

class _UpdateHargaTabState extends State<_UpdateHargaTab> {
  final List<Map<String, dynamic>> _harga =
      _dummyKomoditas.map((k) => {...k, 'ctrl': TextEditingController(text: k['harga'])}).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _showSnack('Fitur CSV upload tersedia di versi berikutnya'),
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text('Bulk Upload CSV'),
              ),
              const Spacer(),
              Text('Terakhir diperbarui: Hari ini, 07:00 WIB',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text('Komoditas',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13))),
                        Expanded(
                            flex: 2,
                            child: Text('Satuan',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13))),
                        Expanded(
                            flex: 3,
                            child: Text('Harga (Rp)',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13))),
                        Expanded(
                            flex: 2,
                            child: Text('Trend',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13))),
                      ],
                    ),
                  ),
                  ..._harga.map((k) => _HargaRow(data: k)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showSnack('Data harga berhasil disimpan!'),
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Simpan Semua Perubahan'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _HargaRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _HargaRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final trend = data['trend'] as String;
    final trendColor = trend == 'naik'
        ? AppColors.danger
        : trend == 'turun'
            ? AppColors.success
            : AppColors.textSecondary;
    final trendIcon = trend == 'naik'
        ? Icons.trending_up
        : trend == 'turun'
            ? Icons.trending_down
            : Icons.trending_flat;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(data['nama'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(
              flex: 2,
              child: Text(data['satuan'],
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary))),
          Expanded(
            flex: 3,
            child: TextField(
              controller: data['ctrl'] as TextEditingController,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(trendIcon, color: trendColor, size: 18),
                const SizedBox(width: 4),
                Text(data['persen'],
                    style: TextStyle(
                        fontSize: 12,
                        color: trendColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab 2: Master Komoditas ──────────────────────────────────────────────────
class _MasterKomoditasTab extends StatefulWidget {
  @override
  State<_MasterKomoditasTab> createState() =>
      _MasterKomoditasTabState();
}

class _MasterKomoditasTabState extends State<_MasterKomoditasTab> {
  final List<Map<String, String>> _list =
      List<Map<String, String>>.from(_dummyKomoditas.map((k) => {
            'nama': k['nama'] as String,
            'satuan': k['satuan'] as String,
            'ikon': k['ikon'] as String,
          }));

  void _showForm({Map<String, String>? existing, int? index}) {
    final namaCtrl =
        TextEditingController(text: existing?['nama'] ?? '');
    final satuanCtrl =
        TextEditingController(text: existing?['satuan'] ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(existing == null ? 'Tambah Komoditas' : 'Edit Komoditas',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
                controller: namaCtrl,
                decoration:
                    const InputDecoration(labelText: 'Nama Komoditas')),
            const SizedBox(height: 12),
            TextField(
                controller: satuanCtrl,
                decoration:
                    const InputDecoration(labelText: 'Satuan (kg/liter)')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    final item = {
                      'nama': namaCtrl.text,
                      'satuan': satuanCtrl.text,
                      'ikon': existing?['ikon'] ?? '🛒',
                    };
                    if (index != null) {
                      _list[index] = item;
                    } else {
                      _list.add(item);
                    }
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
                label: const Text('Tambah Komoditas'),
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
                  leading: Text(item['ikon']!,
                      style: const TextStyle(fontSize: 24)),
                  title: Text(item['nama']!,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('per ${item['satuan']}',
                      style: const TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () =>
                            _showForm(existing: item, index: i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            size: 18, color: AppColors.danger),
                        onPressed: () async {
                          final ok = await showConfirmDialog(context,
                              title: 'Hapus Komoditas',
                              content:
                                  'Yakin ingin menghapus ${item['nama']}?');
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
}

// ─── Dummy data ───────────────────────────────────────────────────────────────
final _dummyKomoditas = [
  {'nama': 'Beras Medium', 'satuan': 'kg', 'ikon': '🌾', 'harga': '12.500', 'trend': 'naik', 'persen': '+2.1%'},
  {'nama': 'Beras Premium', 'satuan': 'kg', 'ikon': '🍚', 'harga': '15.000', 'trend': 'stabil', 'persen': '0%'},
  {'nama': 'Minyak Goreng', 'satuan': 'liter', 'ikon': '🫙', 'harga': '14.200', 'trend': 'turun', 'persen': '-0.7%'},
  {'nama': 'Gula Pasir', 'satuan': 'kg', 'ikon': '🧂', 'harga': '16.000', 'trend': 'naik', 'persen': '+1.5%'},
  {'nama': 'Telur Ayam', 'satuan': 'kg', 'ikon': '🥚', 'harga': '29.500', 'trend': 'stabil', 'persen': '0%'},
  {'nama': 'Daging Sapi', 'satuan': 'kg', 'ikon': '🥩', 'harga': '135.000', 'trend': 'naik', 'persen': '+0.4%'},
  {'nama': 'Cabai Merah', 'satuan': 'kg', 'ikon': '🌶️', 'harga': '42.000', 'trend': 'turun', 'persen': '-5.2%'},
  {'nama': 'Bawang Merah', 'satuan': 'kg', 'ikon': '🧅', 'harga': '28.000', 'trend': 'naik', 'persen': '+3.8%'},
];
