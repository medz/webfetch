import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '_internal/generate_boundary.dart';
import '_internal/headers_boundary.dart';
import '_internal/stream_helpers.dart';
import 'blob.dart';
import 'formdata.dart';
import 'headers.dart';
import 'http_status.dart';
import 'response_type.dart';
import 'types.dart';
import 'url_search_params.dart';

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
    ResponseType type = ResponseType.basic,
  }) {
    this.headers = Headers(headers);
    _storage[#body] = stream;
    _storage[#status] = status;
    _storage[#statusText] = statusText;
    _storage[#type] = type;
  }

  /// Creates a new [Response] object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/Response)
  factory Response(
    Object? body, {
    int? status,
    String? statusText,
    Object? headers,
  }) {
    return switch (body) {
      Response res => Response._(res.body,
          type: res.type,
          headers: headers ?? res.headers,
          status: status ?? res.status,
          statusText: statusText),
      Stream<Uint8List> stream => Response._(stream,
          headers: headers,
          status: status,
          statusText: statusText,
          type: ResponseType.basic),
      ArrayBuffer buffer => Response._(Stream.value(buffer.asUint8List()),
          headers: headers,
          status: status,
          statusText: statusText,
          type: ResponseType.basic),
      TypedData data => Response._(Stream.value(data.buffer.asUint8List()),
          headers: headers,
          status: status,
          statusText: statusText,
          type: ResponseType.basic),
      Blob blob => blob.createResponse(
          headers: headers,
          status: status,
          statusText: statusText,
          type: ResponseType.basic),
      FormData fromData => fromData.createResponse(
          headers: headers,
          status: status,
          statusText: statusText,
          type: ResponseType.basic),
      URLSearchParams params => params.createResponse(
          headers: headers,
          status: status,
          statusText: statusText,
          type: ResponseType.basic),
      String value => Response._(Stream<Uint8List>.value(utf8.encode(value)),
          headers: headers,
          status: status,
          statusText: statusText,
          type: ResponseType.basic),
      null => Response._(Stream<Uint8List>.empty(),
          headers: headers,
          status: status,
          statusText: statusText,
          type: ResponseType.basic),
      // Other types, returns json response
      _ => Response.json(body,
          headers: headers, status: status, statusText: statusText),
    };
  }

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/error_static)
  factory Response.error() {
    return Response._(Stream<Uint8List>.empty(),
        status: 0, statusText: '', type: ResponseType.error);
  }

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/json_static)
  factory Response.json(
    Object? data, {
    int? status,
    String? statusText,
    Object? headers,
  }) {
    final body = utf8.encode(jsonCodec.encode(data));
    final response = Response._(
      Stream<Uint8List>.value(body),
      headers: headers,
      status: status,
      statusText: statusText,
      type: ResponseType.basic,
    );

    // Set headers
    response.headers.set('Content-Type', 'application/json; charset=utf-8');
    response.headers.set('Content-Length', body.length.toString());

    return response;
  }

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/redirect_static)
  factory Response.redirect(String url, [int status = 307]) {
    assert(
      status == 301 ||
          status == 302 ||
          status == 303 ||
          status == 307 ||
          status == 308,
      'Invalid redirect status code, must be 301, 302, 303, 307 or 308',
    );

    return Response._(
      Stream.empty(),
      status: status,
      statusText: status.httpReasonPhrase,
      headers: {'Location': url},
    );
  }

  /// A boolean indicating whether the response was successful (status in the range 200 – 299) or not.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/ok)
  bool get ok => status >= 200 && status < 300;

  /// Indicates whether or not the response is the result of a redirect (that is, its URL list has more than one entry).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/redirected)
  bool get redirected => switch (_storage[#redirected]) {
        true => true,
        _ => false,
      };
  set redirected(bool value) => _storage[#redirected] = value;

  /// The status code of the response. (This will be 200 for a success).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/status)
  int get status => switch (_storage[#status]) {
        int status => status,
        _ => 200,
      };
  set status(int value) => _storage[#status] = value;

  /// The status message corresponding to the status code. (e.g., OK for 200).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/statusText)
  String get statusText => switch (_storage[#statusText]) {
        String statusText => statusText,
        _ => status.httpReasonPhrase,
      };

  /// The type of the response (e.g., basic, cors).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/type)
  ResponseType get type => switch (_storage[#type]) {
        ResponseType type => type,
        _ => ResponseType.basic,
      };
  set type(ResponseType value) => _storage[#type] = value;

  /// The URL of the response.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/url)
  String get url => switch (_storage[#url]) {
        String url => url,
        _ => '',
      };
  set url(String value) => _storage[#url] = value;

  /// A ReadableStream of the body contents.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/body)
  Stream<Uint8List> get body {
    throwIfBodyUsed();
    _storage[#bodyUsed] = true;

    return _storage[#body];
  }

  set body(Stream<Uint8List> value) {
    _storage[#body] = value;
    _storage[#bodyUsed] = false;
  }

  /// Stores a boolean value that declares whether the body has been used in a response yet.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/bodyUsed)
  bool get bodyUsed => switch (_storage[#bodyUsed]) {
        true => true,
        _ => false,
      };

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

    final existing = _storage[#blob];
    if (existing is Blob) return existing;

    return _storage[#blob] = Blob(
      await body.toList(),
      type: headers.get('Content-Type') ?? 'application/octet-stream',
    );
  }

  /// Returns a promise that resolves with a FormData representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/formData)
  Future<FormData> formData() async {
    throwIfBodyUsed();

    final existing = _storage[#fromData];
    if (existing is FormData) return existing;

    final boundary = _storage[#boundary] ?? headers.multipartBoundary;

    return _storage[#fromData] = await FormData.decode(body, boundary);
  }

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
    final copied = copyTwoStreams(body);
    body = copied.$1;

    return Response._(
      copied.$2,
      status: status,
      statusText: statusText,
      headers: headers,
      type: type,
    );
  }
}

extension on Response {
  /// Throws an error if the response body has already been used.
  void throwIfBodyUsed() {
    if (bodyUsed) {
      throw StateError('Body already used');
    }
  }
}

extension on FormData {
  /// Creates a new [Response] object.
  Response createResponse({
    int? status,
    String? statusText,
    Object? headers,
    ResponseType type = ResponseType.basic,
  }) {
    final boundary = generateBoundary();
    final stream = FormData.encode(this, boundary);
    final response = Response._(
      stream,
      status: status,
      statusText: statusText,
      headers: headers,
      type: type,
    );

    // Set headers
    response.headers.set('Content-Type',
        'multipart/form-data; boundary=$boundary; charset=utf-8');

    return response;
  }
}

extension on Blob {
  /// Creates a new [Response] object.
  Response createResponse({
    int? status,
    String? statusText,
    Object? headers,
    ResponseType type = ResponseType.basic,
  }) {
    final response = Response._(
      stream(),
      status: status,
      statusText: statusText,
      headers: headers,
      type: type,
    );

    // Set headers
    if (response.headers.has('Content-Type')) {
      response.headers.set('Content-Type', this.type);
    }
    response.headers.set('Content-Length', size.toString());

    return response;
  }
}

extension on URLSearchParams {
  /// Creates a new [Response] object.
  Response createResponse({
    int? status,
    String? statusText,
    Object? headers,
    ResponseType type = ResponseType.basic,
  }) {
    final value = utf8.encode(toString());
    final response = Response._(
      Stream<Uint8List>.value(value),
      status: status,
      statusText: statusText,
      headers: headers,
      type: type,
    );

    // Set headers
    response.headers.set(
        'Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
    response.headers.set('Content-Length', value.lengthInBytes.toString());

    return response;
  }
}
