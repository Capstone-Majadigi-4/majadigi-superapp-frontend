import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:majadigi_superapp_frontend/main.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Request permissions on Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      try {
        await androidImplementation.requestNotificationsPermission();
      } catch (e) {
        print('Error requesting notification permission: $e');
      }
    }
  }

  Future<void> showQueueNotification({
    required String queueNumber,
    required String polyclinic,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'queue_channel',
        'Queue Notifications',
        channelDescription: 'Notifications for hospital queue status',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        // This ensures it shows on lockscreen
        visibility: NotificationVisibility.public,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        0,
        'Antrean RSUD Dr Saiful Anwar',
        'Nomor antrean Anda: $queueNumber ($polyclinic). Silakan bersiap!',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Notification error in showQueueNotification: $e');
    }
  }

  Future<void> showPriceAlertNotification({
    required String commodityName,
    required double targetPrice,
    required String type,
  }) async {
    final conditionWord = (type.toLowerCase() == 'above' || type.toLowerCase().contains('naik') || type.toLowerCase().contains('above')) ? 'naik melebihi' : 'turun di bawah';
    
    // In-app SnackBar fallback
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pengingat aktif: Anda akan diberitahu jika harga $commodityName $conditionWord Rp ${targetPrice.toStringAsFixed(0)}',
          ),
          backgroundColor: const Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'bapok_channel',
        'Bapok Price Alerts',
        channelDescription: 'Notifications for commodity price alerts',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        visibility: NotificationVisibility.public,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        1,
        'Price Alert: $commodityName',
        'Pengingat harga aktif. Anda akan diberitahu jika harga $conditionWord Rp ${targetPrice.toStringAsFixed(0)}',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Notification error in showPriceAlertNotification: $e');
    }
  }

  Future<void> showPriceCrossedNotification({
    required String commodityName,
    required double targetPrice,
    required double currentPrice,
    required String conditionWord,
  }) async {
    // In-app SnackBar fallback
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Batas Harga Terlewati: Harga $commodityName saat ini Rp ${currentPrice.toStringAsFixed(0)} telah $conditionWord batas Rp ${targetPrice.toStringAsFixed(0)}!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 6),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'bapok_crossed_channel',
        'Bapok Price Cross Alerts',
        channelDescription: 'Notifications for exceeded commodity price alerts',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        visibility: NotificationVisibility.public,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        4,
        'Price Limit Exceeded: $commodityName 🚨',
        'Harga $commodityName saat ini Rp ${currentPrice.toStringAsFixed(0)} telah $conditionWord batas Rp ${targetPrice.toStringAsFixed(0)} yang Anda atur!',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Notification error in showPriceCrossedNotification: $e');
    }
  }

  Future<void> showTbcMedicineNotification({
    required String time,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'tbc_channel',
        'TBC Medicine Reminders',
        channelDescription: 'Notifications for TBC medicine schedule',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        visibility: NotificationVisibility.public,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        2,
        'Pengingat Minum Obat TBC',
        'Waktunya minum obat TBC Anda (Jadwal: $time). Tetap patuhi jadwal ya!',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Notification error in showTbcMedicineNotification: $e');
    }
  }

  Future<void> showIslamicEventNotification({
    required String eventTitle,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'islamic_channel',
        'Islamic Center Notifications',
        channelDescription: 'Notifications for Islamic Center events and bookings',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        visibility: NotificationVisibility.public,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        3,
        'Pendaftaran Event Berhasil',
        'Anda berhasil terdaftar di event "$eventTitle". E-Ticket digital Anda sudah tersedia.',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Notification error in showIslamicEventNotification: $e');
    }
  }
}
