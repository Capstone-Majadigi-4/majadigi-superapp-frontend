import 'package:majadigi_superapp_frontend/models/bapok_ticker_model.dart';

class CartItem {
  final Komoditas komoditas;
  int quantity;

  CartItem({
    required this.komoditas,
    this.quantity = 1,
  });

  double get totalPrice => komoditas.hargaRataRata * quantity;
}
