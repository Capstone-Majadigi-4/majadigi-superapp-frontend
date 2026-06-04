import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/rsud_model.dart';
import 'package:majadigi_superapp_frontend/services/api/rsud_repository.dart';

class RsudProvider extends ChangeNotifier {
  final RsudRepository _repository = RsudRepository();

  bool _isLoadingPoli = false;
  bool _isLoadingKamar = false;
  String? _errorPoli;
  String? _errorKamar;

  List<Poliklinik> _poliklinikList = [];
  List<Kamar> _kamarList = [];
  KamarSummary? _kamarSummary;

  bool get isLoadingPoli => _isLoadingPoli;
  bool get isLoadingKamar => _isLoadingKamar;
  String? get errorPoli => _errorPoli;
  String? get errorKamar => _errorKamar;

  List<Poliklinik> get poliklinikList => _poliklinikList;
  List<Kamar> get kamarList => _kamarList;
  KamarSummary? get kamarSummary => _kamarSummary;

  Future<void> fetchPoliklinik() async {
    _isLoadingPoli = true;
    _errorPoli = null;
    notifyListeners();

    try {
      _poliklinikList = await _repository.getPoliklinik();
    } catch (e) {
      _errorPoli = e.toString();
    } finally {
      _isLoadingPoli = false;
      notifyListeners();
    }
  }

  Future<void> fetchKamar() async {
    _isLoadingKamar = true;
    _errorKamar = null;
    notifyListeners();

    try {
      _kamarSummary = await _repository.getKamarSummary();
      _kamarList = _kamarSummary?.ruangan ?? [];
    } catch (e) {
      _errorKamar = e.toString();
    } finally {
      _isLoadingKamar = false;
      notifyListeners();
    }
  }

  bool _isSubmitting = false;
  Antrean? _lastAntrean;

  bool get isSubmitting => _isSubmitting;
  Antrean? get lastAntrean => _lastAntrean;

  Future<Antrean?> submitAntrean(String poliId, String dokterId, String tanggal) async {
    _isSubmitting = true;
    _lastAntrean = null;
    notifyListeners();

    try {
      final request = AntreanRequest(
        poliId: poliId,
        dokterId: dokterId,
        tanggal: tanggal,
      );
      _lastAntrean = await _repository.ambilAntrean(request);
      return _lastAntrean;
    } catch (e) {
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}

