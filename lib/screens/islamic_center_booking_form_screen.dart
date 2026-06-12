import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_textfield.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/providers/islamic_center_provider.dart';
import 'package:majadigi_superapp_frontend/providers/auth_provider.dart';
import 'package:majadigi_superapp_frontend/models/islamic_center_model.dart';
import 'islamic_center_payment_screen.dart';

class IslamicCenterBookingFormScreen extends StatefulWidget {
  final Fasilitas fasilitas;
  final DateTime selectedDate;

  const IslamicCenterBookingFormScreen({
    super.key,
    required this.fasilitas,
    required this.selectedDate,
  });

  @override
  State<IslamicCenterBookingFormScreen> createState() => _IslamicCenterBookingFormScreenState();
}

class _IslamicCenterBookingFormScreenState extends State<IslamicCenterBookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers with Mock SSO Data
  final _nameController = TextEditingController(text: 'Ahmad Syarifuddin');
  final _phoneController = TextEditingController(text: '081234567890');
  final _orgController = TextEditingController();
  final _eventNameController = TextEditingController();
  final _participantsController = TextEditingController();

  List<int>? _selectedFileBytes;
  String? _selectedFileName;
  String? _fileError;

  String get _displayDate {
    const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return '${widget.selectedDate.day} ${months[widget.selectedDate.month - 1]} ${widget.selectedDate.year}';
  }

  String get _formattedTotalPrice {
    return 'Rp ${widget.fasilitas.hargaPerHari.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      _nameController.text = authProvider.user!.nama;
      _phoneController.text = authProvider.user!.noHp;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _orgController.dispose();
    _eventNameController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        if (file.size > 5 * 1024 * 1024) {
          setState(() {
            _fileError = 'Ukuran file maksimal 5MB';
          });
          return;
        }

        setState(() {
          _selectedFileBytes = file.bytes;
          _selectedFileName = file.name;
          _fileError = null;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      setState(() {
        _fileError = 'Gagal memilih file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0065FF),
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            left: -150,
            top: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBookingSummaryCard(),
                            const SizedBox(height: 32),
                            
                            const Text(
                              'Informasi Pemesan (SSO Verified)',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Nama Lengkap',
                              hintText: '',
                              controller: _nameController,
                              prefixIcon: Icons.person_outline,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Nomor WhatsApp',
                              hintText: '',
                              controller: _phoneController,
                              prefixIcon: Icons.phone_outlined,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Instansi / Organisasi',
                              hintText: 'Masukkan nama instansi (Opsional)',
                              controller: _orgController,
                              prefixIcon: Icons.business_outlined,
                            ),
                            
                            const SizedBox(height: 32),
                            const Text(
                              'Detail Acara',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Nama Acara',
                              hintText: 'Contoh: Seminar Keagamaan',
                              controller: _eventNameController,
                              prefixIcon: Icons.event_note_outlined,
                              validator: (value) => (value == null || value.isEmpty) ? 'Nama acara wajib diisi' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Estimasi Jumlah Peserta',
                              hintText: 'Masukkan jumlah orang',
                              controller: _participantsController,
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.people_outline,
                              validator: (value) => (value == null || value.isEmpty) ? 'Jumlah peserta wajib diisi' : null,
                            ),
                            
                             const SizedBox(height: 24),
                             _buildFilePickerSection(),
                             
                             const SizedBox(height: 40),
                             Consumer<IslamicCenterProvider>(
                               builder: (context, provider, child) {
                                 if (provider.isBooking) {
                                   return const Center(
                                     child: CircularProgressIndicator(
                                       color: Color(0xFF0065FF),
                                     ),
                                   );
                                 }
                                 return CustomButton(
                                   text: 'Lanjutkan Booking',
                                   onPressed: () async {
                                     if (_selectedFileName == null || _selectedFileBytes == null) {
                                       setState(() {
                                         _fileError = 'Dokumen pendukung wajib diunggah';
                                       });
                                     }
                                     if (_formKey.currentState!.validate() && _selectedFileName != null && _selectedFileBytes != null) {
                                       final year = widget.selectedDate.year;
                                       final month = widget.selectedDate.month.toString().padLeft(2, '0');
                                       final day = widget.selectedDate.day.toString().padLeft(2, '0');
                                       final apiDateStr = '$year-$month-$day';

                                       final booking = await provider.bookFasilitas(
                                         id: widget.fasilitas.id,
                                         namaAcara: _eventNameController.text,
                                         tanggalMulai: apiDateStr,
                                         tanggalSelesai: apiDateStr,
                                         estimasiPeserta: int.tryParse(_participantsController.text) ?? 0,
                                         fileBytes: _selectedFileBytes!,
                                         fileName: _selectedFileName!,
                                       );

                                       if (booking != null) {
                                         if (context.mounted) {
                                           _showSuccessDialog(context, booking);
                                         }
                                       } else {
                                         if (context.mounted) {
                                           ScaffoldMessenger.of(context).showSnackBar(
                                             SnackBar(
                                               content: Text(provider.errorBooking ?? 'Gagal memproses booking. Silakan coba lagi.'),
                                               backgroundColor: Colors.red,
                                             ),
                                           );
                                         }
                                       }
                                     }
                                   },
                                   borderRadius: 14,
                                 );
                               },
                             ),
                             const SizedBox(height: 40),
                          ],
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Form Pendaftaran Booking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFE0EEFF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(Icons.meeting_room, 'Ruangan', widget.fasilitas.nama),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFBFDBFE), height: 1),
          ),
          _buildSummaryRow(Icons.calendar_month, 'Tanggal Sewa', _displayDate),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF0065FF)),
        ),
        const SizedBox(width: 16),
        Column(
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
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context, BookingFasilitas booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, size: 80, color: Color(0xFF10B981)),
            const SizedBox(height: 24),
            const Text(
              'Booking Berhasil!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Permintaan booking Anda telah diterima. Admin kami akan segera menghubungi Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Lanjutkan Pembayaran',
              onPressed: () {
                final navigator = Navigator.of(context);
                navigator.pop();
                navigator.push(
                  MaterialPageRoute(
                    builder: (context) => IslamicCenterPaymentScreen(
                      roomName: widget.fasilitas.nama,
                      date: _displayDate,
                      totalAmount: _formattedTotalPrice,
                      bookingId: booking.id,
                      kodeBayar: booking.kodeBayar,
                    ),
                  ),
                );
              },
              borderRadius: 12,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dokumen Pendukung',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Unggah surat permohonan atau dokumen pendukung (PDF, JPG, atau PNG. Maksimal 5MB)',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _pickDocument,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _fileError != null
                    ? Colors.red
                    : (_selectedFileName != null ? const Color(0xFF0065FF) : const Color(0xFFCBD5E1)),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _selectedFileName != null
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.insert_drive_file_outlined,
                          color: Color(0xFF0065FF),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedFileName!,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedFileBytes != null
                                  ? '${(_selectedFileBytes!.length / (1024 * 1024)).toStringAsFixed(2)} MB'
                                  : '',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _selectedFileBytes = null;
                            _selectedFileName = null;
                            _fileError = null;
                          });
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        color: Color(0xFF64748B),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedFileName ?? 'Pilih File Dokumen',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (_fileError != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              _fileError!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
