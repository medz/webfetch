import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '_internal/generate_boundary.dart';
import '_internal/headers_boundary.dart';
import '_internal/stream_helpers.dart';
import '_internal/storage_helpers.dart';
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
    Stream<Uint8List>? stream, {
    int? status,
    String? statusText,
    Object? headers,
    ResponseType type = ResponseType.basic,
  }) {
    _storage[#body] = stream;
    _storage[#status] = status;
    _storage[#statusText] = statusText;
    _storage[#type] = type;
    _storage[#headers] = Headers(headers);
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
      null => Response._(null,
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
  bool get redirected =>
      switch (_storage[#redirected]) { bool value => value, _ => false };

  /// The status code of the response. (This will be 200 for a success).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/status)
  int get status => switch (_storage[#status]) {
        int status => status,
        _ => 200,
      };

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

  /// The URL of the response.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/url)
  String get url => switch (_storage[#url]) {
        String url => url,
        _ => '',
      };

  /// A ReadableStream of the body contents.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/body)
  Stream<Uint8List>? get body => _storage.of(#body, () => null);

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
  Headers get headers => switch (_storage[#headers]) {
        Headers headers => headers,
        _ => Headers(),
      };

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

    _storage[#bodyUsed] = true;

    final existing = _storage[#blob];
    if (existing is Blob) return existing;

    final chunks = <Uint8List>[];
    await for (final Uint8List chunk in body ?? Stream.empty()) {
      chunks.add(chunk);
    }

    return _storage[#blob] = Blob(chunks,
        type: headers.get('Content-Type') ?? 'application/octet-stream');
  }

  /// Returns a promise that resolves with a FormData representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/formData)
  Future<FormData> formData() async {
    throwIfBodyUsed();

    _storage[#bodyUsed] = true;

    final existing = _storage[#fromData];
    if (existing is FormData) return existing;

    // If content-type is `application/x-www-form-urlencoded` then parse the
    // body as URLSearchParams.
    if (headers
            .get('content-type')
            ?.startsWith('application/x-www-form-urlencoded') ==
        true) {
      final params = URLSearchParams(await text());
      final formData = FormData();
      for (final (name, value) in params.entries()) {
        formData.append(name, value);
      }

      return _storage[#fromData] = formData;
    }

    return switch (body) {
      Stream<Uint8List> stream => await FormData.decode(
          stream, _storage[#boundary] ?? headers.multipartBoundary),
      _ => FormData(),
    };
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
    Response clone(Stream<Uint8List> stream) {
      final copied = copyTwoStreams(stream);

      _storage[#bodyUsed] = false;
      _storage[#body] = copied.$1;

      return Response._(
        copied.$2,
        status: status,
        statusText: statusText,
        headers: headers,
        type: type,
      );
    }

    return switch (body) {
      Stream<Uint8List> stream => clone(stream),
      _ => Response._(
          null,
          status: status,
          statusText: statusText,
          headers: headers,
          type: type,
        ),
    };
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
