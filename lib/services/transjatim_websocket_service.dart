import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class TransjatimWebSocketService {
  WebSocket? _webSocket;
  final StreamController<Map<String, dynamic>> _streamController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnecting = false;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  Timer? _mockTimer;

  // Primary URL for WebSocket Staging
  final String _url = 'ws://157.10.253.219/ws/transjatim/armada';
  final String _fallbackUrl = 'ws://157.10.253.219';

  Stream<Map<String, dynamic>> get armadaStream => _streamController.stream;
  bool get isConnected => _isConnected;

  void connect(String corridorId) {
    if (_isConnected || _isConnecting) return;
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      _startLocalSimulation(corridorId);
      return;
    }
    _isConnecting = true;
    _connectSocket(corridorId, _url);
  }

  Future<void> _connectSocket(String corridorId, String urlStr) async {
    try {
      debugPrint('TRANSJATIM WS: Connecting to $urlStr...');
      _webSocket = await WebSocket.connect(urlStr).timeout(const Duration(seconds: 3));
      _isConnected = true;
      _isConnecting = false;
      debugPrint('TRANSJATIM WS: Connected successfully to $urlStr!');

      _webSocket!.listen(
        (data) {
          try {
            final decoded = jsonDecode(data.toString());
            if (decoded is List) {
              _streamController.add({
                'armada': decoded,
                'isSimulated': false,
              });
            } else if (decoded is Map) {
              _streamController.add(Map<String, dynamic>.from(decoded));
            }
          } catch (e) {
            debugPrint('TRANSJATIM WS: Error parsing data: $e');
          }
        },
        onError: (err) {
          debugPrint('TRANSJATIM WS: Connection error: $err');
          _handleDisconnect(corridorId);
        },
        onDone: () {
          debugPrint('TRANSJATIM WS: Connection closed');
          _handleDisconnect(corridorId);
        },
      );
    } catch (e) {
      debugPrint('TRANSJATIM WS: Connection to $urlStr failed: $e');
      if (urlStr == _url) {
        _connectSocket(corridorId, _fallbackUrl);
      } else {
        _isConnected = false;
        _isConnecting = false;
        debugPrint('TRANSJATIM WS: Fallback to local position simulation.');
        _startLocalSimulation(corridorId);
      }
    }
  }

  void _handleDisconnect(String corridorId) {
    _isConnected = false;
    _webSocket = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () => connect(corridorId));
  }

  void _startLocalSimulation(String corridorId) {
    _mockTimer?.cancel();
    
    double step = 0.0;
    
    // Broadcast updates every 4 seconds to simulate moving buses
    _mockTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      step += 0.0015;
      if (step > 0.05) step = 0.0;
      
      _streamController.add({
        'corridorId': corridorId,
        'step': step,
        'isSimulated': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _mockTimer?.cancel();
    _webSocket?.close();
    _webSocket = null;
    _isConnected = false;
    _isConnecting = false;
  }
}
