import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/sinaker_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

class SinakerRepository {
  final Dio _dio = DioClient.instance;

  // Storing job applications state locally for high-fidelity fallback simulation
  static final List<JobApplication> _localApplications = [
    JobApplication(
      id: 'app-1',
      title: 'Full Stack Developer',
      company: 'PT Digital Teknologi',
      date: '1 Apr 2026',
      status: 'Sedang Direview',
      statusColor: '0xFFECEEF2',
      statusTextColor: '0xFF030213',
    ),
    JobApplication(
      id: 'app-2',
      title: 'Backend Developer',
      company: 'PT Tech Inovasi',
      date: '28 Mar 2026',
      status: 'Panggilan Interview',
      statusColor: '0xFF155DFC',
      statusTextColor: '0xFFFFFFFF',
    ),
  ];

  static SinakerProfile _localProfile = SinakerProfile(
    education: 'S1 Teknik Informatika',
    skills: ['Flutter', 'Dart', 'Git', 'REST API', 'UI/UX Design'],
    experience: '1 Tahun Magang di Startup',
  );

  Future<List<JobVacancy>> getVacancies() async {
    try {
      final response = await _dio.get('/sinaker/lowongan');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => JobVacancy.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal memuat lowongan pekerjaan');
      }
    } catch (e) {
      print('API ERROR getVacancies: $e');
      // Mock Fallback
      return [
        JobVacancy(
          id: 'vacancy-1',
          title: 'Full Stack Developer',
          company: 'PT Digital Teknologi',
          location: 'Surabaya',
          salary: 'Rp 8.000.000 - 12.000.000',
          type: 'Full Time',
          posted: '2 hari lalu',
          match: '95%',
          description: 'Kami mencari Full Stack Developer berbakat untuk membangun aplikasi skala besar berbasis mobile dan web.',
          requirements: ['Pengalaman 2+ tahun', 'Menguasai Flutter/React', 'NodeJS / Laravel'],
        ),
        JobVacancy(
          id: 'vacancy-2',
          title: 'UI/UX Designer',
          company: 'CV Kreatif Indonesia',
          location: 'Malang',
          salary: 'Rp 6.000.000 - 9.000.000',
          type: 'Full Time',
          posted: '1 minggu lalu',
          match: '85%',
          description: 'Merancang antarmuka pengguna yang luar biasa untuk berbagai platform digital klien kami.',
          requirements: ['Figma expert', 'Portofolio kuat', 'Bisa wireframing & prototyping'],
        ),
        JobVacancy(
          id: 'vacancy-3',
          title: 'Backend Developer',
          company: 'PT Tech Inovasi',
          location: 'Surabaya',
          salary: 'Rp 9.000.000 - 14.000.000',
          type: 'Full Time',
          posted: '3 hari lalu',
          match: '90%',
          description: 'Membangun API handal berkinerja tinggi menggunakan Go/Node.js.',
          requirements: ['Keahlian di Go/Node.js', 'Desain arsitektur DB', 'Keluarga Docker'],
        ),
      ];
    }
  }

  Future<bool> applyJob(String vacancyId) async {
    try {
      final response = await _dio.post('/sinaker/lowongan/$vacancyId/lamar');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Fetch vacancy details to insert in local status
        final vacancies = await getVacancies();
        final matched = vacancies.firstWhere((v) => v.id == vacancyId);
        _addLocalApplication(matched);
        return true;
      } else {
        throw Exception('Gagal mengirim lamaran');
      }
    } catch (e) {
      print('API ERROR applyJob: $e');
      // Mock Fallback: simulate success by inserting into local list
      try {
        final vacancies = await getVacancies();
        final matched = vacancies.firstWhere((v) => v.id == vacancyId);
        _addLocalApplication(matched);
      } catch (_) {
        // Fallback fallback if ID not found
        _localApplications.insert(
          0,
          JobApplication(
            id: 'app-${DateTime.now().millisecondsSinceEpoch}',
            title: 'Lowongan Kerja',
            company: 'PT Perusahaan',
            date: 'Hari ini',
            status: 'Sedang Direview',
            statusColor: '0xFFECEEF2',
            statusTextColor: '0xFF030213',
          ),
        );
      }
      return true;
    }
  }

  void _addLocalApplication(JobVacancy vacancy) {
    // Check if already applied
    if (!_localApplications.any((app) => app.title == vacancy.title && app.company == vacancy.company)) {
      _localApplications.insert(
        0,
        JobApplication(
          id: 'app-${DateTime.now().millisecondsSinceEpoch}',
          title: vacancy.title,
          company: vacancy.company,
          date: 'Hari ini',
          status: 'Sedang Direview',
          statusColor: '0xFFECEEF2',
          statusTextColor: '0xFF030213',
        ),
      );
    }
  }

  Future<List<JobApplication>> getApplications() async {
    try {
      final response = await _dio.get('/sinaker/lamaran');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => JobApplication.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal memuat lamaran pekerjaan');
      }
    } catch (e) {
      print('API ERROR getApplications: $e');
      return _localApplications;
    }
  }

  Future<SinakerProfile> getProfile() async {
    try {
      final response = await _dio.get('/sinaker/profil');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] ?? responseData;
        return SinakerProfile.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception('Gagal memuat profil');
      }
    } catch (e) {
      print('API ERROR getProfile: $e');
      return _localProfile;
    }
  }

  Future<SinakerProfile> updateProfile(SinakerProfile profile) async {
    try {
      final response = await _dio.post('/sinaker/profil', data: profile.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] ?? responseData;
        _localProfile = SinakerProfile.fromJson(data as Map<String, dynamic>);
        return _localProfile;
      } else {
        throw Exception('Gagal memperbarui profil');
      }
    } catch (e) {
      print('API ERROR updateProfile: $e');
      _localProfile = profile;
      return _localProfile;
    }
  }
}
