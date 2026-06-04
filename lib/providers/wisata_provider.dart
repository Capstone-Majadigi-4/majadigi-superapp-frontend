import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/wisata_model.dart';
import 'package:majadigi_superapp_frontend/services/api/wisata_repository.dart';

class WisataProvider with ChangeNotifier {
  final WisataRepository _repository = WisataRepository();

  List<Destination> _destinations = [];
  List<TourismTicket> _tickets = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Destination> get destinations => _destinations;
  List<TourismTicket> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDestinations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _destinations = await _repository.getDestinations();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTickets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tickets = await _repository.getTickets();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> buyTicket(String destinationId, int quantity, String date, String time) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.buyTicket(destinationId, quantity, date, time);
      if (success) {
        await fetchTickets(); // Refresh tickets list
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
