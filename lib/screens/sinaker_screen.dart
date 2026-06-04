import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import '../providers/sinaker_provider.dart';
import '../models/sinaker_model.dart';
import '../widgets/sinaker_status_dialog.dart';
import '../widgets/custom_button.dart';

class SinakerScreen extends StatefulWidget {
  const SinakerScreen({super.key});

  @override
  State<SinakerScreen> createState() => _SinakerScreenState();
}

class _SinakerScreenState extends State<SinakerScreen> {
  int _activeTabIndex = 0; // 0 for Lowongan, 1 for Profil, 2 for Lamaran
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SinakerProvider>();
      provider.fetchVacancies();
      provider.fetchApplications();
      provider.fetchProfile();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SinakerProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0046B2),
      body: Stack(
        children: [
          // Header background with gradient
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
                            'SINAKER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Layanan Pelatihan Kerja',
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
                        final isFav = moduleProvider.isFavorite('sinaker');
                        return GestureDetector(
                          onTap: () => moduleProvider.toggleFavorite('sinaker'),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.star_rounded : Icons.star_border_rounded,
                              color: isFav ? const Color(0xFFF59E0B) : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('💼', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height - 110,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC), 
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  _buildTabSelector(),
                  Expanded(
                    child: provider.isLoading && 
                            provider.vacancies.isEmpty && 
                            provider.applications.isEmpty && 
                            provider.profile == null
                        ? const Center(child: CircularProgressIndicator())
                        : _buildTabBody(provider),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0065FF), 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(0, Icons.work_outline_rounded, 'Lowongan'),
          ),
          Expanded(
            child: _buildTabItem(1, Icons.person_outline_rounded, 'Profil'),
          ),
          Expanded(
            child: _buildTabItem(2, Icons.send_rounded, 'Lamaran'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF0065FF) : Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF0065FF) : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBody(SinakerProvider provider) {
    switch (_activeTabIndex) {
      case 0:
        return _buildLowonganTab(provider);
      case 1:
        return _buildProfilTab(provider);
      case 2:
        return _buildLamaranTab(provider);
      default:
        return const SizedBox();
    }
  }

  Widget _buildLowonganTab(SinakerProvider provider) {
    final query = _searchQuery.toLowerCase();
    final filteredVacancies = provider.vacancies.where((v) {
      return v.title.toLowerCase().contains(query) ||
          v.company.toLowerCase().contains(query) ||
          v.location.toLowerCase().contains(query);
    }).toList();

    final highestMatch = provider.vacancies.isNotEmpty ? provider.vacancies.first.match : '85%';

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari lowongan...',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // List Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi Untukmu',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark_outline_rounded, color: Color(0xFF1D4ED8), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '$highestMatch Match',
                          style: const TextStyle(
                            color: Color(0xFF1D4ED8),
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Berdasarkan profil profesional Anda',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: filteredVacancies.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada lowongan ditemukan.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontFamily: 'Inter'),
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: filteredVacancies.length,
                  itemBuilder: (context, index) {
                    final vacancy = filteredVacancies[index];
                    final isApplied = provider.applications.any(
                      (app) => app.title == vacancy.title && app.company == vacancy.company,
                    );
                    final isTopMatch = index == 0 || vacancy.match.contains('95') || vacancy.match.contains('90');

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top header of card
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _getJobIcon(vacancy.title),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vacancy.title,
                                      style: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      vacancy.company,
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isTopMatch)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Top Match',
                                    style: TextStyle(
                                      color: Color(0xFF15803D),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Location & Time posted
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Color(0xFF64748B), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                vacancy.location,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontFamily: 'Inter'),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.access_time, color: Color(0xFF64748B), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                vacancy.posted,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontFamily: 'Inter'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Salary and Job Type Badge
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  vacancy.type,
                                  style: const TextStyle(
                                    color: Color(0xFF1D4ED8),
                                    fontSize: 11,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  vacancy.salary,
                                  style: const TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (vacancy.description != null && vacancy.description!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              vacancy.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                height: 1.4,
                              ),
                            ),
                          ],

                          if (vacancy.requirements != null && vacancy.requirements!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: vacancy.requirements!.map((req) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    req,
                                    style: const TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 11,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // Detail and Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: OutlinedButton(
                                    onPressed: () => _showJobDetailDialog(vacancy),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Lihat Detail',
                                      style: TextStyle(
                                        color: Color(0xFF475569),
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: isApplied
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDCFCE7),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: const Color(0xFF86EFAC)),
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.check, color: Color(0xFF16803D), size: 16),
                                              SizedBox(width: 4),
                                              Text(
                                                'Sudah Dilamar',
                                                style: TextStyle(
                                                  color: Color(0xFF16803D),
                                                  fontSize: 13,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: () => _handleApplyJob(vacancy.id, provider),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF0065FF),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.send_rounded, color: Colors.white, size: 14),
                                              SizedBox(width: 6),
                                              Text(
                                                'Lamar Sekarang',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _getJobIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('designer') || lowerTitle.contains('ui') || lowerTitle.contains('ux') || lowerTitle.contains('design')) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2E6),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text('🎨', style: TextStyle(fontSize: 24)),
      );
    } else if (lowerTitle.contains('market') || lowerTitle.contains('sales') || lowerTitle.contains('pr') || lowerTitle.contains('media')) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text('📢', style: TextStyle(fontSize: 24)),
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text('💻', style: TextStyle(fontSize: 24)),
      );
    }
  }

  void _showJobDetailDialog(JobVacancy vacancy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          vacancy.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vacancy.company,
                style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 4),
              Text(
                '${vacancy.location} • ${vacancy.type}',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi Pekerjaan:',
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 6),
              Text(
                vacancy.description ?? 'Tidak ada deskripsi pekerjaan.',
                style: const TextStyle(color: Color(0xFF334155), fontSize: 14, fontFamily: 'Inter', height: 1.4),
              ),
              if (vacancy.requirements != null && vacancy.requirements!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Persyaratan:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 6),
                ...vacancy.requirements!.map((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              req,
                              style: const TextStyle(color: Color(0xFF334155), fontSize: 14, fontFamily: 'Inter'),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  void _handleApplyJob(String vacancyId, SinakerProvider provider) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );

    final success = await provider.applyJob(vacancyId);
    
    if (mounted) {
      Navigator.pop(context); // dismiss spinner
      if (success) {
        showSinakerStatusDialog(
          context,
          status: SinakerStatus.sent,
        );
      } else {
        showSinakerStatusDialog(
          context,
          status: SinakerStatus.failed,
        );
      }
    }
  }

  Widget _buildProfilTab(SinakerProvider provider) {
    final profile = provider.profile;

    if (profile == null) {
      return const Center(
        child: Text(
          'Profil belum tersedia. Silakan lengkapi profil Anda.',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontFamily: 'Inter'),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          _buildProfileCompletenessCard(profile),
          const SizedBox(height: 20),
          _buildProfileCard(
            title: 'Pendidikan',
            icon: Icons.school_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBg: const Color(0xFFEFF6FF),
            child: _buildProfileField('Jenjang Pendidikan', profile.education),
          ),
          const SizedBox(height: 20),
          _buildProfileCard(
            title: 'Pengalaman Kerja',
            icon: Icons.business_center_outlined,
            iconColor: const Color(0xFF10B981),
            iconBg: const Color(0xFFECFDF5),
            child: _buildProfileField('Pengalaman', profile.experience),
          ),
          if (profile.skills.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildProfileCard(
              title: 'Keahlian',
              icon: Icons.star_border_rounded,
              iconColor: const Color(0xFFF59E0B),
              iconBg: const Color(0xFFFFFBEB),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileCompletenessCard(SinakerProfile profile) {
    int percentage = 0;
    if (profile.education.isNotEmpty) percentage += 33;
    if (profile.experience.isNotEmpty) percentage += 33;
    if (profile.skills.isNotEmpty) percentage += 34;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0065FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0065FF).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelengkapan Profil',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  percentage == 100 ? 'Profil Anda sudah lengkap!' : 'Lengkapi profil Anda agar dilirik perusahaan!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLamaranTab(SinakerProvider provider) {
    final applications = provider.applications;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Applications List Card Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status Lamaran',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${applications.length} Lamaran',
                        style: const TextStyle(
                          color: Color(0xFF0065FF),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (applications.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Anda belum mengirimkan lamaran.',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontFamily: 'Inter'),
                      ),
                    ),
                  )
                else
                  ...applications.map((app) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      app.title,
                                      style: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      app.company,
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusBadge(app.status),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Dilamar: ${app.date}',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Status Meaning Box
          _buildInfoStatusCard(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final lower = status.toLowerCase();
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF475569);
    IconData icon = Icons.info_outline;

    if (lower.contains('review') || lower.contains('proses')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFD97706);
      icon = Icons.visibility_outlined;
    } else if (lower.contains('test') || lower.contains('tes') || lower.contains('interview') || lower.contains('panggilan')) {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF15803D);
      icon = Icons.assignment_turned_in_outlined;
    } else if (lower.contains('tolak')) {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFFB91C1C);
      icon = Icons.cancel_outlined;
    } else if (lower.contains('kirim')) {
      bg = const Color(0xFFDBEAFE);
      fg = const Color(0xFF1D4ED8);
      icon = Icons.send_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 12),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, color: Color(0xFF1D4ED8), size: 18),
              SizedBox(width: 8),
              Text(
                'Info Status Lamaran',
                style: TextStyle(
                  color: Color(0xFF1D4ED8),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoStatusRow(Icons.send_rounded, const Color(0xFF3B82F6), 'Terkirim'),
          const SizedBox(height: 8),
          _buildInfoStatusRow(Icons.visibility_outlined, const Color(0xFFF59E0B), 'Sedang Direview'),
          const SizedBox(height: 8),
          _buildInfoStatusRow(Icons.check_circle_outline_rounded, const Color(0xFF10B981), 'Panggilan Tes'),
          const SizedBox(height: 8),
          _buildInfoStatusRow(Icons.cancel_outlined, const Color(0xFFEF4444), 'Ditolak'),
        ],
      ),
    );
  }

  Widget _buildInfoStatusRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 12),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF475569),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

