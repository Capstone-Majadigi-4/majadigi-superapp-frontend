import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import 'package:provider/provider.dart';
import '../providers/sinaker_provider.dart';
import '../models/sinaker_model.dart';
import '../widgets/job_application_card.dart';
import '../widgets/job_recommendation_card.dart';
import '../widgets/sinaker_status_dialog.dart';

class SinakerJobsScreen extends StatefulWidget {
  const SinakerJobsScreen({super.key});

  @override
  State<SinakerJobsScreen> createState() => _SinakerJobsScreenState();
}

class _SinakerJobsScreenState extends State<SinakerJobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showAllApplications = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SinakerProvider>(context, listen: false);
      provider.fetchVacancies();
      provider.fetchApplications();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    if (status.toLowerCase().contains('review') || status.toLowerCase().contains('proses')) {
      return const Color(0xFFECEEF2);
    } else if (status.toLowerCase().contains('interview') || status.toLowerCase().contains('panggilan')) {
      return const Color(0xFF155DFC);
    } else if (status.toLowerCase().contains('terima') || status.toLowerCase().contains('lolos')) {
      return const Color(0xFFE8F5E9);
    } else {
      return const Color(0xFFFFEBEE);
    }
  }

  Color _getStatusTextColor(String status) {
    if (status.toLowerCase().contains('review') || status.toLowerCase().contains('proses')) {
      return const Color(0xFF030213);
    } else if (status.toLowerCase().contains('interview') || status.toLowerCase().contains('panggilan')) {
      return Colors.white;
    } else if (status.toLowerCase().contains('terima') || status.toLowerCase().contains('lolos')) {
      return const Color(0xFF2E7D32);
    } else {
      return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0065FF), Color(0xFF155DFC)],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'SINAKER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      _buildBookmarkButton(context),
                    ],
                  ),
                ),
                
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Cari posisi atau perusahaan..',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 24,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF155DFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Consumer<SinakerProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading && provider.vacancies.isEmpty && provider.applications.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (provider.errorMessage != null && provider.vacancies.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Gagal memuat lowongan: ${provider.errorMessage}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      provider.fetchVacancies();
                                      provider.fetchApplications();
                                    },
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final displayApplications = _showAllApplications 
                            ? provider.applications 
                            : provider.applications.take(2).toList();

                        final query = _searchQuery.toLowerCase();
                        final filteredVacancies = provider.vacancies.where((vacancy) {
                          return vacancy.title.toLowerCase().contains(query) ||
                              vacancy.company.toLowerCase().contains(query) ||
                              vacancy.location.toLowerCase().contains(query);
                        }).toList();

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Lamaran Saya Section
                                _buildSectionHeader('Lamaran Saya'),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Column(
                                    children: [
                                      if (provider.applications.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 24),
                                          child: Center(
                                            child: Text(
                                              'Anda belum mengirimkan lamaran.',
                                              style: TextStyle(
                                                color: Color(0xFF6A7282),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ),
                                        )
                                      else ...[
                                        ...displayApplications.asMap().entries.map((entry) {
                                          final idx = entry.key;
                                          final app = entry.value;
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: idx == displayApplications.length - 1 ? 0 : 12.0
                                            ),
                                            child: JobApplicationCard(
                                              title: app.title,
                                              company: app.company,
                                              date: app.date,
                                              status: app.status,
                                              statusColor: _getStatusColor(app.status),
                                              statusTextColor: _getStatusTextColor(app.status),
                                            ),
                                          );
                                        }),
                                        if (provider.applications.length > 2) ...[
                                          const SizedBox(height: 12),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showAllApplications = !_showAllApplications;
                                                });
                                              },
                                              child: Text(
                                                _showAllApplications ? 'Sembunyikan' : 'Lihat lainnya',
                                                style: const TextStyle(
                                                  color: Color(0xFF0065FF),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Rekomendasi Section
                                const Text(
                                  'Rekomendasi untuk Anda',
                                  style: TextStyle(
                                    color: Color(0xFF0A0A0A),
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (filteredVacancies.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: Text(
                                        'Tidak ada lowongan pekerjaan ditemukan.',
                                        style: TextStyle(
                                          color: Color(0xFF6A7282),
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  ...filteredVacancies.map((vacancy) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: JobRecommendationCard(
                                      title: vacancy.title,
                                      company: vacancy.company,
                                      match: vacancy.match,
                                      location: vacancy.location,
                                      salary: vacancy.salary,
                                      type: vacancy.type,
                                      posted: vacancy.posted,
                                      onApply: () async {
                                        // Show applying dialog
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                        
                                        final success = await provider.applyJob(vacancy.id);
                                        
                                        if (mounted) {
                                          Navigator.pop(context); // Dismiss loading dialog
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
                                      },
                                    ),
                                  )),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF0A0A0A),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    ModuleProvider? moduleProvider;
    try {
      moduleProvider = Provider.of<ModuleProvider>(context, listen: true);
    } catch (_) {}
    if (moduleProvider == null) {
      return const IconButton(
        icon: Icon(Icons.bookmark_outline, color: Colors.white),
        onPressed: null,
      );
    }
    final isFav = moduleProvider.isFavorite('sinaker');
    return IconButton(
      icon: Icon(
        isFav ? Icons.bookmark : Icons.bookmark_outline,
        color: Colors.white,
      ),
      onPressed: () => moduleProvider!.toggleFavorite('sinaker'),
    );
  }
}
