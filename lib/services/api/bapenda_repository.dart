import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/bapenda_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

class BapendaRepository {
  final Dio _dio = DioClient.instance;

  // Storing payment state locally for fallback simulation
  static final Map<String, String> _paymentStatusOverride = {};

  Future<List<BapendaVehicle>> getVehicles() async {
    final defaultVehicle = BapendaVehicle(
      platNomor: 'L 1234 AB',
      merk: 'HONDA',
      tipe: 'VARIO 150',
      tanggalJatuhTempo: '15 Mei 2026',
      isWarning: true,
      statusText: 'Jatuh tempo H-8',
      pemilik: 'Budi Sintara',
      noRangka: 'MH1JM3118KK123456',
      noMesin: 'JM31E1234567',
      tahun: 2021,
    );

    List<BapendaVehicle> vehiclesList = [];
    try {
      final response = await _dio.get('/bapenda/kendaraan');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        vehiclesList = list.map((item) => BapendaVehicle.fromJson(item as Map<String, dynamic>)).toList();
        
        // Ensure default vehicle is always in the list
        final hasDefault = vehiclesList.any((v) => v.platNomor.replaceAll(' ', '').toLowerCase() == 'l1234ab');
        if (!hasDefault) {
          vehiclesList.insert(0, defaultVehicle);
        }
      } else {
        throw Exception('Gagal mengambil data kendaraan');
      }
    } catch (e) {
      print('API ERROR getVehicles: $e');
      // Mock Fallback
      vehiclesList = [
        defaultVehicle,
        BapendaVehicle(
          platNomor: 'W 5678 CD',
          merk: 'TOYOTA',
          tipe: 'AVANZA 1.5 G',
          tanggalJatuhTempo: '20 November 2026',
          isWarning: false,
          statusText: 'Aktif',
          pemilik: 'Budi Sintara',
          noRangka: 'MHF11BK3MJK123456',
          noMesin: '2NR1234567',
          tahun: 2020,
        ),
      ];
    }

    // Apply payment overrides dynamically
    for (var i = 0; i < vehiclesList.length; i++) {
      final plat = vehiclesList[i].platNomor;
      if (_paymentStatusOverride[plat] == 'Lunas') {
        vehiclesList[i] = BapendaVehicle(
          platNomor: vehiclesList[i].platNomor,
          merk: vehiclesList[i].merk,
          tipe: vehiclesList[i].tipe,
          tanggalJatuhTempo: vehiclesList[i].tanggalJatuhTempo,
          isWarning: false,
          statusText: 'Aktif',
          pemilik: vehiclesList[i].pemilik,
          noRangka: vehiclesList[i].noRangka,
          noMesin: vehiclesList[i].noMesin,
          tahun: vehiclesList[i].tahun,
        );
      }
    }

    return vehiclesList;
  }

  Future<BapendaBillDetail> getBillDetail(String platNomor) async {
    try {
      // Encode plate number because it contains spaces
      final encodedPlat = Uri.encodeComponent(platNomor);
      final response = await _dio.get('/bapenda/tagihan/$encodedPlat');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>;
        
        // Apply local payment override if paid
        final bill = BapendaBillDetail.fromJson(data);
        if (_paymentStatusOverride[platNomor] != null) {
          return BapendaBillDetail(
            platNomor: bill.platNomor,
            merk: bill.merk,
            tipe: bill.tipe,
            jatuhTempo: bill.jatuhTempo,
            pkbPokok: bill.pkbPokok,
            swdkljj: bill.swdkljj,
            biayaAdmin: bill.biayaAdmin,
            denda: bill.denda,
            totalTagihan: bill.totalTagihan,
            statusBayar: _paymentStatusOverride[platNomor]!,
          );
        }
        return bill;
      } else {
        throw Exception('Gagal mengambil data tagihan');
      }
    } catch (e) {
      print('API ERROR getBillDetail: $e');
      // Mock Fallback
      final isMotor = platNomor.toUpperCase().contains('L 1234 AB');
      final status = _paymentStatusOverride[platNomor] ?? 'Belum Bayar';
      
      return BapendaBillDetail(
        platNomor: platNomor,
        merk: isMotor ? 'HONDA' : 'TOYOTA',
        tipe: isMotor ? 'VARIO 150' : 'AVANZA 1.5 G',
        jatuhTempo: isMotor ? '2026-05-15' : '2026-11-20',
        pkbPokok: isMotor ? 150000 : 250000,
        swdkljj: 35000,
        biayaAdmin: 5000,
        denda: 0,
        totalTagihan: isMotor ? 190000 : 290000, // PKB + SWDKLLJ + Admin
        statusBayar: status,
      );
    }
  }

  Future<BapendaBillDetail> payBill(String platNomor) async {
    try {
      final encodedPlat = Uri.encodeComponent(platNomor);
      final response = await _dio.post('/bapenda/tagihan/$encodedPlat/bayar');
      if (response.statusCode == 200 || response.statusCode == 201) {
        _paymentStatusOverride[platNomor] = 'Lunas';
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>;
        return BapendaBillDetail.fromJson(data);
      } else {
        throw Exception('Gagal memproses pembayaran');
      }
    } catch (e) {
      print('API ERROR payBill: $e');
      // Local Simulation
      _paymentStatusOverride[platNomor] = 'Lunas';
      return getBillDetail(platNomor);
    }
  }

  Future<List<BapendaPaymentHistory>> getPaymentHistory() async {
    try {
      final response = await _dio.get('/bapenda/pembayaran');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => BapendaPaymentHistory.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal mengambil riwayat pembayaran');
      }
    } catch (e) {
      print('API ERROR getPaymentHistory: $e');
      // Return a generated log based on local paid items
      final list = <BapendaPaymentHistory>[];
      _paymentStatusOverride.forEach((plat, status) {
        if (status == 'Lunas') {
          list.add(BapendaPaymentHistory(
            id: 'VA-${plat.replaceAll(' ', '')}-${DateTime.now().millisecondsSinceEpoch}',
            platNomor: plat,
            tanggalBayar: DateTime.now().toIso8601String().split('T')[0],
            jumlah: plat.contains('L 1234') ? 190000 : 290000,
            status: 'success',
            kodeBayar: 'VA-${plat.replaceAll(' ', '')}',
          ));
        }
      });
      
      // Seed initial history
      if (list.isEmpty) {
        list.add(BapendaPaymentHistory(
          id: 'VA-1779381167807',
          platNomor: 'L 1234 AB',
          tanggalBayar: '2025-05-15',
          jumlah: 190000,
          status: 'success',
          kodeBayar: 'VA-1779381167807',
        ));
      }
      return list;
    }
  }

  Future<BapendaEtbpkb> getEtbpkb(String id) async {
    try {
      final response = await _dio.get('/bapenda/etbpkb/$id');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>;
        return BapendaEtbpkb.fromJson(data);
      } else {
        throw Exception('Gagal mengambil data E-TBPKB');
      }
    } catch (e) {
      print('API ERROR getEtbpkb: $e');
      final isMotor = id.contains('1234');
      return BapendaEtbpkb(
        id: id,
        nopol: isMotor ? 'L 1234 AB' : 'W 5678 CD',
        pemilik: 'Budi Sintara',
        merkTipe: isMotor ? 'HONDA / VARIO 150' : 'TOYOTA / AVANZA 1.5 G',
        tahun: isMotor ? 2021 : 2020,
        tanggalBayar: DateTime.now().toIso8601String().split('T')[0],
        jumlah: isMotor ? 190000 : 290000,
        status: 'Lunas',
        qrCodeData: 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=$id',
      );
    }
  }
}
