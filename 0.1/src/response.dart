import 'dart:convert';
import 'dart:typed_data';

import 'blob.dart';
import 'headers.dart';
import 'http_status.dart';
import 'response_type.dart';
import 'types.dart';

/// This Fetch API interface represents the response to a request.
///
/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response)
class Response {
  /// Global helper, used [Codec] to encode or decode json.
  static JsonCodec jsonCodec = const JsonCodec();

  /// Internal storage of the [Response] object.
  final Map<Symbol, dynamic> _storage = {};

  /// Internal constructor.
  Response._(
    Stream<Uint8List> stream, {
    int? status,
    String? statusText,
    Object? headers,
    required this.type,
  }) {
    this.headers = Headers(headers);
    this[#body] = stream;
    this[#status] = status;
    this[#statusText] = statusText;
  }

  /// Creates a new [Response] object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/Response)
  // Response(
  //   Object? body, {
  //   int? status,
  //   String? statusText,
  //   Object? headers,
  // }) {
  //   this.headers = Headers(headers);
  // }

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/error_static)
  // factory Response.error() ;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/json_static)
  // factory Response.json(
  //   Object? data, {
  //   int? status,
  //   String? statusText,
  //   Object? headers,
  // });

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/redirect_static)
  // factory Response.redirect(Object url, [int status]);

  /// A boolean indicating whether the response was successful (status in the range 200 – 299) or not.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/ok)
  bool get ok => status >= 200 && status < 300;

  /// Indicates whether or not the response is the result of a redirect (that is, its URL list has more than one entry).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/redirected)
  bool get redirected => type == ResponseType.opaqueRedirect;

  /// The status code of the response. (This will be 200 for a success).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/status)
  int get status => this[#status];
  set status(int value) => this[#status] = value;

  /// The status message corresponding to the status code. (e.g., OK for 200).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/statusText)
  String get statusText => this[#statusText] ??= status.httpReasonPhrase;

  /// The type of the response (e.g., basic, cors).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/type)
  final ResponseType type;

  /// The URL of the response.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/url)
  String get url => this[#url];
  set url(String value) => this[#url] = value;

  /// A ReadableStream of the body contents.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/body)
  Stream<Uint8List> get body {
    throwIfBodyUsed();
    this[#bodyUsed] = true;

    return this[#body];
  }

  set body(Stream<Uint8List> value) {
    this[#body] = value;
    this[#bodyUsed] = false;
  }

  /// Stores a boolean value that declares whether the body has been used in a response yet.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/bodyUsed)
  bool get bodyUsed => this[#bodyUsed];

  /// The Headers object associated with the response.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/headers)
  late final Headers headers;

  /// Returns a promise that resolves with an ArrayBuffer representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/arrayBuffer)
  Future<ArrayBuffer> arrayBuffer() =>
      blob().then((blob) => blob.arrayBuffer());

  /// Returns a promise that resolves with a Blob representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/blob)
  Future<Blob> blob() async {
    throwIfBodyUsed();

    final Blob? existing = this[#body];
    if (existing != null) return existing;

    final chunks = <Uint8List>[];
    await for (final Uint8List chunk in body) {
      chunks.add(chunk);
    }

    return this[#body] = Blob(
      chunks,
      type: headers.get('Content-Type') ?? 'application/octet-stream',
    );
  }

  /// Returns a promise that resolves with a FormData representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/formData)
  Future<FormData> formData();

  /// Returns a promise that resolves with the result of parsing the response body text as JSON.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/json)
  Future<Object> json() async => jsonCodec.decode(await text());

  /// Returns a promise that resolves with a text representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/text)
  Future<String> text() => blob().then((blob) => blob.text());

  /// Creates a clone of a Response object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/Response/clone)
  Response clone() {
    throwIfBodyUsed();
    final stream = switch (this[#body]) {
      Stream<Uint8List> stream when stream.isBroadcast => stream,
      Stream<Uint8List> stream => stream.asBroadcastStream(),
      _ => Stream<Uint8List>.empty(),
    };

    return Response._(
      stream,
      status: status,
      statusText: statusText,
      headers: headers,
      type: type,
    );
  }
}

extension on Response {
  dynamic operator [](Symbol key) => _storage[key];
  // Sets
  void operator []=(Symbol key, value) => _storage[key] = value;

  /// Throws an error if the response body has already been used.
  void throwIfBodyUsed() {
    if (this[#bodyUsed]) {
      throw StateError('Body already used');
    }
  }
}
