import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/transjatim_model.dart';
import 'package:majadigi_superapp_frontend/services/api/transjatim_repository.dart';

class TransJatimProvider extends ChangeNotifier {
  final TransJatimRepository _repository = TransJatimRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<Koridor> _koridorList = [];

  bool _isTicketLoading = false;
  List<Ticket> _ticketList = [];

  bool _isLoadingArmada = false;
  List<Armada> _armadaList = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Koridor> get koridorList => _koridorList;

  bool get isTicketLoading => _isTicketLoading;
  List<Ticket> get ticketList => _ticketList;

  bool get isLoadingArmada => _isLoadingArmada;
  List<Armada> get armadaList => _armadaList;

  Future<void> fetchKoridor() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _koridorList = await _repository.getKoridor();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTickets() async {
    _isTicketLoading = true;
    notifyListeners();

    try {
      _ticketList = await _repository.getTickets();
    } catch (e) {
      print('Provider Error fetchTickets: $e');
    } finally {
      _isTicketLoading = false;
      notifyListeners();
    }
  }

  Future<TicketPurchaseResponse?> purchaseTicket(String koridorId, int jumlah) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.buyTicket(koridorId, jumlah);
      // Success, reload tickets
      await fetchTickets();
      return response;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchArmada(String koridorId) async {
    _isLoadingArmada = true;
    notifyListeners();

    try {
      _armadaList = await _repository.getArmada(koridorId);
    } catch (e) {
      print('Provider Error fetchArmada: $e');
    } finally {
      _isLoadingArmada = false;
      notifyListeners();
    }
  }

  void updateArmadaList(List<Armada> armadas) {
    _armadaList = armadas;
    notifyListeners();
  }
}

