import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/models/wisata_model.dart';
import 'package:majadigi_superapp_frontend/providers/wisata_provider.dart';
import 'package:majadigi_superapp_frontend/screens/bus_route_detail_screen.dart';
import 'package:majadigi_superapp_frontend/screens/my_itinerary_screen.dart';

class DestinationDetailModal extends StatefulWidget {
  const DestinationDetailModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DestinationDetailModal(),
    );
  }

  @override
  State<DestinationDetailModal> createState() => _DestinationDetailModalState();
}

class _DestinationDetailModalState extends State<DestinationDetailModal> {
  String selectedCategory = 'Semua';
  Destination? selectedDestination;
  int quantity = 1;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedTime = '09:00 WIB';

  final List<String> categories = ['Semua', 'Alam', 'Pantai', 'Keluarga'];
  final List<String> timeSessions = ['09:00 WIB', '11:00 WIB', '13:00 WIB', '15:00 WIB'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WisataProvider>(context, listen: false);
      if (provider.destinations.isEmpty) {
        provider.fetchDestinations().then((_) {
          _initializeDefaultDestination();
        });
      } else {
        _initializeDefaultDestination();
      }
    });
  }

  void _initializeDefaultDestination() {
    final provider = Provider.of<WisataProvider>(context, listen: false);
    if (provider.destinations.isNotEmpty) {
      setState(() {
        selectedDestination = provider.destinations.first;
      });
    }
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return '${days[dt.weekday % 7]}, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0065FF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wisataProvider = Provider.of<WisataProvider>(context);
    final filteredDestinations = wisataProvider.destinations.where((d) {
      return selectedCategory == 'Semua' || d.category == selectedCategory;
    }).toList();

    // Reset selected destination if it's no longer in the filtered list
    if (selectedDestination == null && filteredDestinations.isNotEmpty) {
      selectedDestination = filteredDestinations.first;
    } else if (selectedDestination != null && !filteredDestinations.any((d) => d.id == selectedDestination!.id)) {
      selectedDestination = filteredDestinations.isNotEmpty ? filteredDestinations.first : null;
    }

    // Calculate total price
    int totalPrice = 0;
    if (selectedDestination != null) {
      final cleanedPrice = selectedDestination!.price.replaceAll('Rp', '').replaceAll('.', '').replaceAll(' ', '').trim();
      final basePrice = int.tryParse(cleanedPrice) ?? 35000;
      totalPrice = basePrice * quantity;
    }

    String _formatRupiah(int val) {
      final str = val.toString();
      final buffer = StringBuffer();
      int count = 0;
      for (int i = str.length - 1; i >= 0; i--) {
        if (count > 0 && count % 3 == 0) {
          buffer.write('.');
        }
        buffer.write(str[i]);
        count++;
      }
      return 'Rp ${buffer.toString().split('').reversed.join()}';
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Header Gradient Area
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0065FF), Color(0xFF155DFC)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              // Modal Handle & Close Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Title
              const Text(
                'Destinasi Wisata',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // White Content Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoBanner(),
                        const SizedBox(height: 24),
                        _buildCategorySelector(),
                        const SizedBox(height: 24),
                        
                        if (wisataProvider.isLoading && wisataProvider.destinations.isEmpty)
                          const Center(child: CircularProgressIndicator())
                        else ...[
                          // Destination Dropdown Selector
                          if (filteredDestinations.isNotEmpty) ...[
                            const Text(
                              'Pilih Tempat Wisata',
                              style: TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Destination>(
                                  value: selectedDestination,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                                  items: filteredDestinations.map((dest) {
                                    return DropdownMenuItem<Destination>(
                                      value: dest,
                                      child: Text(
                                        dest.title,
                                        style: const TextStyle(
                                          color: Color(0xFF1E293B),
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedDestination = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          if (selectedDestination != null) ...[
                            _buildDestinationDetailCard(context, selectedDestination!),
                            const SizedBox(height: 24),
                            _buildBookingForm(context),
                          ] else
                            const Center(
                              child: Text(
                                'Tidak ada destinasi di kategori ini',
                                style: TextStyle(color: Color(0xFF64748B), fontFamily: 'Inter'),
                              ),
                            ),
                        ],
                        const SizedBox(height: 100), // padding for bottom button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Fixed Button
          if (selectedDestination != null)
            Positioned(
              left: 24,
              right: 24,
              bottom: 32,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: wisataProvider.isLoading
                      ? null
                      : () async {
                          final success = await wisataProvider.buyTicket(
                            selectedDestination!.id,
                            quantity,
                            _formatDate(selectedDate),
                            selectedTime,
                          );
                          if (success && mounted) {
                            Navigator.pop(context); // close modal
                            _showSuccessDialog(context, selectedDestination!.title, quantity);
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(wisataProvider.errorMessage ?? 'Gagal membeli tiket'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0065FF),
                    disabledBackgroundColor: const Color(0xFF0065FF).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: wisataProvider.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Beli E-Ticket • ${_formatRupiah(totalPrice)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String title, int qty) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pembelian Berhasil!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'E-Ticket untuk $qty orang ke $title telah berhasil diterbitkan dan masuk ke itinerary Anda.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyItineraryScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0065FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Lihat Tiket Saya'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Color(0xFFEFF6FF), Color(0xFFECFEFF)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -1,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFDBEAFE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: Color(0xFF1C398E), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cross-Ticketing & Bus Integration',
                  style: TextStyle(
                    color: Color(0xFF1C398E),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Color(0xFF1447E6),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'Setiap destinasi sudah terintegrasi dengan '),
                      TextSpan(
                        text: 'Transjatim',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ' untuk rekomendasi rute bus terdekat. Beli E-Ticket langsung dengan QRIS!',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFECECF0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: categories.map((cat) {
          bool isSelected = selectedCategory == cat;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  cat,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF0A0A0A),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDestinationDetailCard(BuildContext context, Destination dest) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: Image.network(
              dest.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dest.title,
                  style: const TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dest.description,
                  style: const TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMetaTag(Icons.access_time, dest.duration),
                    const SizedBox(width: 8),
                    _buildMetaTag(Icons.calendar_today_outlined, dest.openHours),
                  ],
                ),
                const SizedBox(height: 16),
                _buildBusRouteCard(context, dest),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B7280), size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 11,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusRouteCard(BuildContext context, Destination dest) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Color(0xFFFEFCE8), Color(0xFFFFF7ED)],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFFFF085)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.directions_bus_outlined, color: Color(0xFF733E0A), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rute Transjatim',
                      style: TextStyle(
                        color: Color(0xFF733E0A),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dest.route,
                      style: const TextStyle(
                        color: Color(0xFFA65F00),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BusRouteDetailScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFDF20)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, color: Color(0xFF894B00), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Lihat Rute Bus',
                    style: TextStyle(
                      color: Color(0xFF894B00),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Form Pemesanan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),

          // Date Selector Field
          const Text('Tanggal Kunjungan', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'Inter')),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Color(0xFF64748B), size: 18),
                  const SizedBox(width: 12),
                  Text(
                    _formatDate(selectedDate),
                    style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B), fontFamily: 'Inter'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time Session Selector
          const Text('Waktu Kunjungan', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'Inter')),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedTime,
                isExpanded: true,
                items: timeSessions.map((t) {
                  return DropdownMenuItem<String>(
                    value: t,
                    child: Text(t, style: const TextStyle(fontSize: 14, fontFamily: 'Inter')),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedTime = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quantity Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jumlah Pengunjung', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'Inter')),
                  SizedBox(height: 4),
                  Text('Max 10 tiket', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontFamily: 'Inter')),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: quantity > 1
                        ? () {
                            setState(() {
                              quantity--;
                            });
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: quantity > 1 ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: quantity > 1 ? const Color(0xFF0065FF) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: quantity < 10
                        ? () {
                            setState(() {
                              quantity++;
                            });
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: quantity < 10 ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: quantity < 10 ? const Color(0xFF0065FF) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
