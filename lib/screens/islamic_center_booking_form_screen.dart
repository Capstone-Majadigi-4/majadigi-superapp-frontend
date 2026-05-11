import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_textfield.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'islamic_center_payment_screen.dart';

class IslamicCenterBookingFormScreen extends StatefulWidget {
  final String roomName;
  final String date;

  const IslamicCenterBookingFormScreen({
    super.key,
    required this.roomName,
    required this.date,
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _orgController.dispose();
    _eventNameController.dispose();
    _participantsController.dispose();
    super.dispose();
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
                            
                            const SizedBox(height: 40),
                            CustomButton(
                              text: 'Lanjutkan Booking',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _showSuccessDialog(context);
                                }
                              },
                              borderRadius: 14,
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
          _buildSummaryRow(Icons.meeting_room, 'Ruangan', widget.roomName),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFBFDBFE), height: 1),
          ),
          _buildSummaryRow(Icons.calendar_month, 'Tanggal Sewa', widget.date),
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

  void _showSuccessDialog(BuildContext context) {
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IslamicCenterPaymentScreen(
                      roomName: widget.roomName,
                      date: widget.date,
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
}
