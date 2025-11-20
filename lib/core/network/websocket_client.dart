import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketClientImpl {
  final String userId;
  final String url;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  bool _manuallyClosed = false;

  // Callbacks for different message types
  Function(Map<String, dynamic>)? onMessageDelivered;
  Function(Map<String, dynamic>)? onNewMessage;
  Function(Map<String, dynamic>)? onReadReceipt;
  Function(Map<String, dynamic>)? onMessageDeleted;

  // Singleton instance
  static WebSocketClientImpl? _instance;

  WebSocketClientImpl._internal({required this.userId, required this.url});

  factory WebSocketClientImpl({required String userId, required String url}) {
    _instance ??= WebSocketClientImpl._internal(userId: userId, url: url);
    return _instance!;
  }

  static WebSocketClientImpl? get instance => _instance;

  // =============================
  // CONNECT
  // =============================
  void connect() async {
    print("🔌 Connecting WS...");
    _manuallyClosed = false;

    // example: ws://10.0.2.2:5000/ws?userId=123
    final fullUrl = "$url?userId=$userId";
    _channel = WebSocketChannel.connect(Uri.parse(fullUrl));

    // Listen message
    _subscription = _channel!.stream.listen(
      _onMessage,
      onDone: _onDisconnected,
      onError: _onError,
      cancelOnError: true,
    );
  }

  // =============================
  // HANDLE MESSAGE
  // =============================
  void _onMessage(dynamic event) {
    print("📥 WS Received: $event");

    try {
      final Map<String, dynamic> jsonData = jsonDecode(event);

      // 🔄 RESPOND TO HEARTBEAT
      if (jsonData["type"] == "ping") {
        sendHeartbeat();
        return;
      }

      // =============================
      // TYPE = MESSAGE / delivered / read / deleted
      // =============================
      switch (jsonData["type"]) {
        case "newMessage":
          print("🟢 New message received");
          if (onNewMessage != null) {
            onNewMessage!(jsonData);
          }
          break;

        case "delivered":
          print("📨 Message delivered");
          if (onMessageDelivered != null) {
            onMessageDelivered!(jsonData);
          }
          break;

        case "readReceipt":
          print("👁 Message read");
          if (onReadReceipt != null) {
            onReadReceipt!(jsonData);
          }
          break;

        case "messageDeleted":
          print("❌ Message deleted");
          if (onMessageDeleted != null) {
            onMessageDeleted!(jsonData);
          }
          break;

        default:
          print("⚠ Unknown WS message type: ${jsonData['type']}");
      }
    } catch (e) {
      print("⚠ Non JSON Message: $e");
    }
  }

  // =============================
  // SEND CHAT MESSAGE
  // =============================
  void sendChat({
    required String from,
    required String to,
    required String message,
  }) {
    if (_channel == null) return;

    final payload = {
      "addId": from,
      "idUser": to,
      "messages": message,
      "addTime": DateTime.now().toIso8601String(),
    };

    _channel!.sink.add(jsonEncode(payload));
    print("📤 Sent chat: $payload");
  }

  // =============================
  // SEND HEARTBEAT
  // =============================
  void sendHeartbeat() {
    final payload = {"type": "pong"};
    _channel!.sink.add(jsonEncode(payload));
    print("🏓 Sent PONG to server");
  }

  // =============================
  // DISCONNECTED
  // =============================
  void _onDisconnected() {
    print("🔴 WS closed");

    if (!_manuallyClosed) {
      reconnect();
    }
  }

  // =============================
  // ON ERROR
  // =============================
  void _onError(error) {
    print("⚠ WS Error: $error");

    if (!_manuallyClosed) {
      reconnect();
    }
  }

  // =============================
  // RECONNECT AUTOMATICALLY
  // =============================
  void reconnect() {
    if (_reconnectTimer != null) return;

    print("🔁 WS Reconnecting in 3s...");
    _reconnectTimer = Timer(Duration(seconds: 3), () {
      connect();
      _reconnectTimer = null;
    });
  }

  // =============================
  // CLOSE CONNECTION
  // =============================
  Future<void> disconnect() async {
    _manuallyClosed = true;

    // Clear callbacks
    onMessageDelivered = null;
    onNewMessage = null;
    onReadReceipt = null;
    onMessageDeleted = null;

    await _subscription?.cancel();
    await _channel?.sink.close(status.normalClosure);

    _instance = null;
  }
}
