import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/widgets/admin_shell.dart';

class IslamicCenterPage extends StatefulWidget {
  const IslamicCenterPage({super.key});

  @override
  State<IslamicCenterPage> createState() => _IslamicCenterPageState();
}

class _IslamicCenterPageState extends State<IslamicCenterPage>
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
          title: const Text('Islamic Center'),
          leading: MediaQuery.of(context).size.width < 900
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer())
              : null,
          bottom: TabBar(
            controller: _tab,
            tabs: const [
              Tab(text: 'Permohonan Sewa'),
              Tab(text: 'Kelola Event'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: [
            _PermohonanSewaTab(),
            _EventTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Tab 1: Permohonan Sewa ───────────────────────────────────────────────────
class _PermohonanSewaTab extends StatefulWidget {
  @override
  State<_PermohonanSewaTab> createState() => _PermohonanSewaTabState();
}

class _PermohonanSewaTabState extends State<_PermohonanSewaTab> {
  final List<Map<String, String>> _list =
      List.from(_dummyBooking);

  void _updateStatus(int i, String status) {
    setState(() => _list[i] = {..._list[i], 'status': status});
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status diubah menjadi $status')));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final item = _list[i];
        final status = item['status']!;
        StatusType sType;
        if (status == 'Disetujui') {
          sType = StatusType.success;
        } else if (status == 'Ditolak') {
          sType = StatusType.danger;
        } else {
          sType = StatusType.warning;
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(item['nama']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                    StatusBadge(label: status, type: sType),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(Icons.meeting_room_outlined, item['fasilitas']!),
                _InfoRow(Icons.event_outlined, item['tanggal']!),
                _InfoRow(Icons.description_outlined, item['acara']!),
                _InfoRow(Icons.attach_money, item['biaya']!),
                if (status == 'Menunggu') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _updateStatus(i, 'Ditolak'),
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Tolak'),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(
                                  color: AppColors.danger)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _updateStatus(i, 'Disetujui'),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Setujui'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── Tab 2: Event ─────────────────────────────────────────────────────────────
class _EventTab extends StatefulWidget {
  @override
  State<_EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<_EventTab> {
  final List<Map<String, String>> _events = List.from(_dummyEvents);

  void _showForm({Map<String, String>? existing, int? index}) {
    final judulCtrl =
        TextEditingController(text: existing?['judul'] ?? '');
    final tanggalCtrl =
        TextEditingController(text: existing?['tanggal'] ?? '');
    final kuotaCtrl =
        TextEditingController(text: existing?['kuota'] ?? '');
    final deskCtrl =
        TextEditingController(text: existing?['deskripsi'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                existing == null
                    ? 'Buat Event Baru'
                    : 'Edit Event',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
                controller: judulCtrl,
                decoration:
                    const InputDecoration(labelText: 'Judul Acara')),
            const SizedBox(height: 12),
            TextField(
                controller: tanggalCtrl,
                decoration:
                    const InputDecoration(labelText: 'Tanggal Pelaksanaan')),
            const SizedBox(height: 12),
            TextField(
                controller: kuotaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Kuota Maks. Peserta')),
            const SizedBox(height: 12),
            TextField(
                controller: deskCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Deskripsi Acara')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    final item = {
                      'judul': judulCtrl.text,
                      'tanggal': tanggalCtrl.text,
                      'kuota': kuotaCtrl.text,
                      'deskripsi': deskCtrl.text,
                      'pendaftar': existing?['pendaftar'] ?? '0',
                    };
                    if (index != null) {
                      _events[index] = item;
                    } else {
                      _events.add(item);
                    }
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Simpan Event'),
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
                label: const Text('Buat Event Baru'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final e = _events[i];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(e['judul']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _InfoRow(Icons.event, e['tanggal']!),
                      _InfoRow(Icons.people_outline,
                          '${e['pendaftar']} / ${e['kuota']} peserta'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 18),
                          onPressed: () =>
                              _showForm(existing: e, index: i)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            size: 18, color: AppColors.danger),
                        onPressed: () async {
                          final ok = await showConfirmDialog(context,
                              title: 'Hapus Event',
                              content:
                                  'Yakin hapus event "${e['judul']}"?');
                          if (ok)
                            setState(() => _events.removeAt(i));
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
final _dummyBooking = [
  {'nama': 'Ahmad Fauzi', 'fasilitas': 'Aula Utama (kap. 1000)', 'tanggal': '15 Jun 2025', 'acara': 'Pengajian Akbar Muharram', 'biaya': 'Rp 5.000.000', 'status': 'Menunggu'},
  {'nama': 'Yayasan Baitul Ilmi', 'fasilitas': 'Ruang Seminar (kap. 200)', 'tanggal': '20 Jun 2025', 'acara': 'Seminar Parenting Islami', 'biaya': 'Rp 1.500.000', 'status': 'Menunggu'},
  {'nama': 'Komunitas Pemuda Masjid', 'fasilitas': 'Ruang Kelas A', 'tanggal': '10 Jun 2025', 'acara': 'Workshop Tilawah', 'biaya': 'Rp 500.000', 'status': 'Disetujui'},
  {'nama': 'PT Amanah Sejahtera', 'fasilitas': 'Aula Utama', 'tanggal': '5 Jun 2025', 'acara': 'Gathering Karyawan', 'biaya': 'Rp 5.000.000', 'status': 'Ditolak'},
];

final _dummyEvents = [
  {'judul': 'Kajian Ramadan — Ustadz Abdul Somad', 'tanggal': '25 Jun 2025', 'kuota': '2000', 'pendaftar': '1847', 'deskripsi': 'Kajian akbar menyambut bulan suci'},
  {'judul': 'Bimbingan Tahsin Al-Quran', 'tanggal': 'Setiap Sabtu', 'kuota': '50', 'pendaftar': '42', 'deskripsi': 'Kelas rutin perbaikan bacaan Al-Quran'},
  {'judul': 'Festival Nasyid Jawa Timur', 'tanggal': '12 Jul 2025', 'kuota': '500', 'pendaftar': '123', 'deskripsi': 'Kompetisi nasyid tingkat provinsi'},
];
