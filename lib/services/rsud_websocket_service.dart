import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class RsudWebSocketService {
  WebSocket? _webSocket;
  final StreamController<Map<String, dynamic>> _streamController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnecting = false;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  Timer? _mockTimer;

  // Primary URL for WebSocket Staging
  final String _url = 'ws://157.10.253.219/ws/rsud/antrean'; 
  final String _fallbackUrl = 'ws://157.10.253.219';

  Stream<Map<String, dynamic>> get queueStream => _streamController.stream;
  bool get isConnected => _isConnected;

  void connect(String poliId) {
    if (_isConnected || _isConnecting) return;
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      _startLocalSimulation(poliId);
      return;
    }
    _isConnecting = true;
    _connectSocket(poliId, _url);
  }

  Future<void> _connectSocket(String poliId, String urlStr) async {
    try {
      debugPrint('RSUD WS: Connecting to $urlStr...');
      _webSocket = await WebSocket.connect(urlStr).timeout(const Duration(seconds: 3));
      _isConnected = true;
      _isConnecting = false;
      debugPrint('RSUD WS: Connected successfully to $urlStr!');

      _webSocket!.listen(
        (data) {
          try {
            final decoded = jsonDecode(data.toString());
            if (decoded is List) {
              _streamController.add({
                'queue': decoded,
                'isSimulated': false,
              });
            } else if (decoded is Map) {
              _streamController.add(Map<String, dynamic>.from(decoded));
            }
          } catch (e) {
            debugPrint('RSUD WS: Error parsing data: $e');
          }
        },
        onError: (err) {
          debugPrint('RSUD WS: Connection error: $err');
          _handleDisconnect(poliId);
        },
        onDone: () {
          debugPrint('RSUD WS: Connection closed');
          _handleDisconnect(poliId);
        },
      );
    } catch (e) {
      debugPrint('RSUD WS: Connection to $urlStr failed: $e');
      if (urlStr == _url) {
        // Try fallback to base IP
        _connectSocket(poliId, _fallbackUrl);
      } else {
        _isConnected = false;
        _isConnecting = false;
        debugPrint('RSUD WS: All connections failed. Falling back to local simulation.');
        _startLocalSimulation(poliId);
      }
    }
  }

  void _handleDisconnect(String poliId) {
    _isConnected = false;
    _webSocket = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () => connect(poliId));
  }

  void _startLocalSimulation(String poliId) {
    _mockTimer?.cancel();
    
    int currentServing = 5;
    final prefix = _getPrefixForPoli(poliId);
    
    // Initial emission
    _streamController.add({
      'poliId': poliId,
      'currentServing': '$prefix-${currentServing.toString().padLeft(3, '0')}',
      'waitingCount': 8,
      'calledNumbers': List.generate(4, (i) => '$prefix-${(currentServing - 1 - i).clamp(1, 999).toString().padLeft(3, '0')}'),
      'isSimulated': true,
    });

    // Advance queue every 8 seconds
    _mockTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      currentServing++;
      _streamController.add({
        'poliId': poliId,
        'currentServing': '$prefix-${currentServing.toString().padLeft(3, '0')}',
        'waitingCount': (12 - currentServing % 5).clamp(1, 20),
        'calledNumbers': List.generate(4, (i) => '$prefix-${(currentServing - 1 - i).clamp(1, 999).toString().padLeft(3, '0')}'),
        'isSimulated': true,
      });
    });
  }

  String _getPrefixForPoli(String poliId) {
    final lowerId = poliId.toLowerCase();
    if (lowerId.contains('umum') || lowerId.contains('3bb1b554')) return 'U';
    if (lowerId.contains('dalam')) return 'C';
    if (lowerId.contains('anak') || lowerId.contains('6cab51a0')) return 'A';
    if (lowerId.contains('bedah')) return 'B';
    if (lowerId.contains('jantung')) return 'H';
    if (lowerId.contains('saraf')) return 'S';
    return 'Q';
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
