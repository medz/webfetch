import '../request.dart';
import '../response.dart';

abstract interface class Client {
  factory Client() {
    throw UnsupportedError(
        'Cannot create a client without dart:html or dart:io');
  }

  Future<Response> send(Request request, {bool keepalive = false});
}
