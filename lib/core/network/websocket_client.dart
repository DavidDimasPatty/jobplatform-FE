import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WebSocketClient {
  Stream<dynamic> get stream;
  void send(String data);
  Future<void> connect(String url);
  Future<void> disconnect();
  bool get isConnected;
}

class WebSocketClientImpl implements WebSocketClient {
  WebSocketChannel? _channel;
  StreamController<dynamic>? _controller;
  bool _isConnected = false;

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<dynamic> get stream => _controller!.stream;

  @override
  Future<void> connect(String url) async {
    try {
      _controller = StreamController.broadcast();
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen(
        (data) {
          _controller!.add(data);
          _isConnected = true;
        },
        onError: (error) {
          _isConnected = false;
          _controller!.addError(error);
        },
        onDone: () {
          _isConnected = false;
        },
      );
    } catch (e) {
      _isConnected = false;
      throw Exception('Failed to connect: $e');
    }
  }

  @override
  void send(String data) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(data);
    }
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    await _controller?.close();
    _isConnected = false;
  }
}
