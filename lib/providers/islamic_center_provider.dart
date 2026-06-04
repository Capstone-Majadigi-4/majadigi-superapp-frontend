import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/islamic_center_model.dart';
import 'package:majadigi_superapp_frontend/services/api/islamic_center_repository.dart';

class IslamicCenterProvider extends ChangeNotifier {
  final IslamicCenterRepository _repository = IslamicCenterRepository();

  bool _isLoadingAcara = false;
  bool _isLoadingFasilitas = false;
  String? _errorAcara;
  String? _errorFasilitas;

  List<Acara> _acaraList = [];
  List<Fasilitas> _fasilitasList = [];

  bool get isLoadingAcara => _isLoadingAcara;
  bool get isLoadingFasilitas => _isLoadingFasilitas;
  String? get errorAcara => _errorAcara;
  String? get errorFasilitas => _errorFasilitas;

  List<Acara> get acaraList => _acaraList;
  List<Fasilitas> get fasilitasList => _fasilitasList;

  Future<void> fetchAcara() async {
    _isLoadingAcara = true;
    _errorAcara = null;
    notifyListeners();

    try {
      _acaraList = await _repository.getAcara();
    } catch (e) {
      _errorAcara = e.toString();
    } finally {
      _isLoadingAcara = false;
      notifyListeners();
    }
  }

  Future<void> fetchFasilitas() async {
    _isLoadingFasilitas = true;
    _errorFasilitas = null;
    notifyListeners();

    try {
      _fasilitasList = await _repository.getFasilitas();
    } catch (e) {
      _errorFasilitas = e.toString();
    } finally {
      _isLoadingFasilitas = false;
      notifyListeners();
    }
  }
  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;

  bool _isAlreadyRegistered = false;
  bool get isAlreadyRegistered => _isAlreadyRegistered;

  String? _errorRegistration;
  String? get errorRegistration => _errorRegistration;

  Future<bool> registerKajian(String acaraId) async {
    _isRegistering = true;
    _isAlreadyRegistered = false;
    _errorRegistration = null;
    notifyListeners();
    bool success = false;
    try {
      success = await _repository.daftarKajian(acaraId);
    } on DioException catch (e) {
      success = false;
      if (e.response != null) {
        if (e.response?.statusCode == 409) {
          _isAlreadyRegistered = true;
        }
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          _errorRegistration = data['message'] as String?;
        }
      }
      _errorRegistration ??= e.message;
    } catch (e) {
      success = false;
      _errorRegistration = e.toString();
    } finally {
      _isRegistering = false;
      notifyListeners();
    }
    return success;
  }

  bool _isBooking = false;
  bool get isBooking => _isBooking;

  String? _errorBooking;
  String? get errorBooking => _errorBooking;

  Future<BookingFasilitas?> bookFasilitas({
    required String id,
    required String namaAcara,
    required String tanggalMulai,
    required String tanggalSelesai,
    required int estimasiPeserta,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    _isBooking = true;
    _errorBooking = null;
    notifyListeners();
    BookingFasilitas? booking;
    try {
      booking = await _repository.bookingFasilitas(
        id: id,
        namaAcara: namaAcara,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        estimasiPeserta: estimasiPeserta,
        fileBytes: fileBytes,
        fileName: fileName,
      );
    } on DioException catch (e) {
      booking = null;
      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          _errorBooking = data['message'] as String?;
        }
      }
      _errorBooking ??= e.message;
    } catch (e) {
      booking = null;
      _errorBooking = e.toString();
    } finally {
      _isBooking = false;
      notifyListeners();
    }
    return booking;
  }

  List<BookingFasilitas> _myBookings = [];
  List<PendaftaranAcara> _myRegistrations = [];
  bool _isLoadingMyBookings = false;
  bool _isLoadingMyRegistrations = false;
  String? _errorMyBookings;
  String? _errorMyRegistrations;

  List<BookingFasilitas> get myBookings => _myBookings;
  List<PendaftaranAcara> get myRegistrations => _myRegistrations;
  bool get isLoadingMyBookings => _isLoadingMyBookings;
  bool get isLoadingMyRegistrations => _isLoadingMyRegistrations;
  String? get errorMyBookings => _errorMyBookings;
  String? get errorMyRegistrations => _errorMyRegistrations;

  Future<void> fetchMyBookings() async {
    _isLoadingMyBookings = true;
    _errorMyBookings = null;
    notifyListeners();

    try {
      _myBookings = await _repository.getMyBookingFasilitas();
    } catch (e) {
      _errorMyBookings = e.toString();
    } finally {
      _isLoadingMyBookings = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyRegistrations() async {
    _isLoadingMyRegistrations = true;
    _errorMyRegistrations = null;
    notifyListeners();

    try {
      _myRegistrations = await _repository.getMyPendaftaranAcara();
    } catch (e) {
      _errorMyRegistrations = e.toString();
    } finally {
      _isLoadingMyRegistrations = false;
      notifyListeners();
    }
  }
}
