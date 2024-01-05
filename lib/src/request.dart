import 'dart:convert';
import 'dart:typed_data';

import '_internal/default_base_url.dart';
import '_internal/generate_boundary.dart';
import '_internal/headers_boundary.dart';
import '_internal/stream_helpers.dart';
import '_internal/storage_helpers.dart';
import 'blob.dart';
import 'formdata.dart';
import 'headers.dart';
import 'referrer_policy.dart';
import 'request_cache.dart';
import 'request_credentials.dart';
import 'request_destination.dart';
import 'request_mode.dart';
import 'request_redirect.dart';
import 'types.dart';
import 'url.dart';
import 'url_search_params.dart';

/// This Fetch API interface represents a resource request.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request)
class Request {
  /// Global helper, used [Codec] to encode or decode json.
  static JsonCodec jsonCodec = const JsonCodec();

  /// Internal Storage for the [Request] object.
  final Map<Symbol, dynamic> _storage = {};

  /// Internal constructor for creating a [Request] object.
  Request._();

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/Request)
  factory Request(
    Object input, {
    RequestCache? cache,
    RequestCredentials? credentials,
    RequestDestination? destination,
    String? integrity,
    String? method,
    RequestMode? mode,
    RequestRedirect? redirect,
    String? referrer,
    ReferrerPolicy? referrerPolicy,
    Object? headers,
    Object? body,
  }) {
    final base = switch (input) {
      Request request => request,
      _ => null,
    };
    final request = Request._();

    request._storage[#url] =
        base == null ? URL(input, defaultBaseURL).toString() : base.url;
    request._storage[#headers] =
        (headers == null ? base?.headers : null) ?? Headers(headers);
    request._storage[#cache] = cache ?? base?.cache;
    request._storage[#credentials] = credentials ?? base?.credentials;
    request._storage[#destination] = destination ?? base?.destination;
    request._storage[#integrity] = integrity ?? base?.integrity;
    request._storage[#method] = method ?? base?.method;
    request._storage[#mode] = mode ?? base?.mode;
    request._storage[#redirect] = redirect ?? base?.redirect;
    request._storage[#referrer] = referrer ?? base?.referrer;
    request._storage[#referrerPolicy] = referrerPolicy ?? base?.referrerPolicy;

    request.initBody(body ?? base?.body);

    return request;
  }

  /// A [Stream] of the body content.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/body)
  Stream<Uint8List>? get body {
    throwIfBodyUsed();

    _storage[#bodyUsed] = true;
    return _storage.of(#body, () => null);
  }

  /// Stores true or false to indicate whether or not the body has been used in
  /// a request yet.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/bodyUsed)
  bool get bodyUsed => _storage.of(#bodyUsed, () => false);

  /// Contains the cache mode of the request (e.g., default, reload, no-cache).
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/cache)
  RequestCache get cache => _storage.of(#cache, () => RequestCache.default_);

  /// Contains the credentials of the request (e.g., omit, same-origin, include). The default is same-origin.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/credentials)
  RequestCredentials get credentials =>
      _storage.of(#credentials, () => RequestCredentials.include);

  /// A string describing the type of content being requested.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/destination)
  RequestDestination get destination =>
      _storage.of(#destination, () => RequestDestination.default_);

  /// Contains the associated [Headers] object of the request.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/headers)
  Headers get headers => _storage.of(#headers, Headers.new);

  /// Returns request's subresource integrity metadata, which is a cryptographic hash of the resource being fetched. Its value consists of multiple hashes separated by whitespace. [SRI]
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/integrity)
  String get integrity => _storage.of(#integrity, () => '');

  /// Contains the request's method (GET, POST, etc.)
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/method)
  String get method => _storage.of(#method, () => "GET");

  /// Contains the mode of the request (e.g., cors, no-cors, same-origin, navigate.)
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/mode)
  RequestMode get mode => _storage.of(#mode, () => RequestMode.cors);

  /// Contains the mode for how redirects are handled. It may be one of follow, error, or manual.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/redirect)
  RequestRedirect get redirect =>
      _storage.of(#redirect, () => RequestRedirect.follow);

  /// Contains the referrer of the request (e.g., client).
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/referrer)
  String get referrer => _storage.of(#referrer, () => 'about:client');

  /// Contains the referrer policy of the request (e.g., no-referrer).
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/referrerPolicy)
  ReferrerPolicy get referrerPolicy =>
      _storage.of(#referrerPolicy, () => ReferrerPolicy.default_);

  /// Contains the URL of the request.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/url)
  String get url => _storage.of(#url, () => defaultBaseURL?.toString() ?? '');

  /// Returns a promise that resolves with an ArrayBuffer representation of the
  /// request body.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/arrayBuffer)
  Future<ArrayBuffer> arrayBuffer() =>
      blob().then((blob) => blob.arrayBuffer());

  /// Returns a promise that resolves with a Blob representation of the
  /// request body.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/blob)
  Future<Blob> blob() async {
    final existing = _storage[#blob];
    if (existing is Blob) return existing;

    final chunks = <Uint8List>[];
    await for (final Uint8List chunk in body ?? Stream.empty()) {
      chunks.add(chunk);
    }

    final blob = Blob(chunks,
        type: headers.get('Content-Type') ?? 'application/octet-stream');

    return _storage[#blob] = blob;
  }

  /// Returns a promise that resolves with a FormData representation of the request body.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/formData)
  Future<FormData> formData() async {
    throwIfBodyUsed();

    final FormData? existing = _storage[#fromData];
    if (existing != null) return existing;

    return switch (body) {
      Stream<Uint8List> stream => await FormData.decode(
          stream, _storage[#boundary] ?? headers.multipartBoundary),
      _ => FormData(),
    };
  }

  /// Returns a promise that resolves with the result of parsing the request body as JSON.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/json)
  Future<Object> json() async => jsonCodec.decode(await text());

  /// Returns a promise that resolves with a text representation of the request body.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/text)
  Future<String> text() => blob().then((blob) => blob.text());

  /// Creates a copy of the current Request object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/clone)
  Request clone() {
    Request copy(Stream<Uint8List> stream) {
      final copied = copyTwoStreams(stream);

      _storage[#body] = copied.$1;
      _storage[#bodyUsed] = false;

      return Request(this, body: copied.$2);
    }

    return switch (body) {
      Stream<Uint8List> stream => copy(stream),
      _ => Request(this),
    };
  }
}

extension on Request {
  /// Checks if the [Request] body is used, If it is, throws a [StateError].
  void throwIfBodyUsed() {
    if (bodyUsed) {
      throw StateError('The Request body has already been used.');
    }
  }

  /// Parses the [body] and stores it in the [Request] object.
  void initBody(Object? value) {
    final stream = switch (value) {
      Stream<Uint8List> stream => stream,
      ArrayBuffer buffer => initArrayBuffer(buffer),
      TypedData data => initArrayBuffer(data.buffer),
      Blob blob => initBlob(blob),
      String string => initString(string),
      FormData fromData => initFormData(fromData),
      URLSearchParams params => initSearchParams(params),
      null => null,
      _ => initJson(value),
    };

    _storage[#body] = stream;
    _storage[#bodyUsed] = false;
  }

  /// Initializes the [Request] body with a [URLSearchParams] object, and sets
  /// the [Content-Type] header.
  Stream<Uint8List> initSearchParams(URLSearchParams params) {
    headers.set(
        'Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
    headers.set('Content-Length', params.toString().length.toString());

    return Stream.value(utf8.encode(params.toString()));
  }

  /// Initializes the [Request] body with a [ArrayBuffer] object, and sets the
  /// [Content-Type] header.
  Stream<Uint8List> initArrayBuffer(ArrayBuffer buffer) {
    headers.set('Content-Type', 'application/octet-stream');
    headers.set('Content-Length', buffer.lengthInBytes.toString());

    return Stream.value(buffer.asUint8List());
  }

  /// Initializes the [Request] body with a [Blob] object, and sets the
  /// [Content-Type] header.
  Stream<Uint8List> initBlob(Blob blob) {
    headers.set(
      'Content-Type',
      switch (blob.type) {
        String type when type.isNotEmpty => type,
        _ => 'application/octet-stream',
      },
    );
    headers.set('Content-Length', blob.size.toString());

    return blob.stream();
  }

  /// Initializes the [Request] body with a [Object] object, and sets the
  /// [Content-Type] header.
  Stream<Uint8List> initJson(Object value) {
    final converted = utf8.encode(Request.jsonCodec.encode(value));

    headers.set('Content-Type', 'application/json; charset=UTF-8');
    headers.set('Content-Length', converted.length.toString());

    return Stream.value(converted);
  }

  /// Initializes the [Request] body with a [String] object, and sets the
  /// [Content-Type] header.
  Stream<Uint8List> initString(String string) {
    headers.set('Content-Type', 'text/plain; charset=UTF-8');
    headers.set('Content-Length', string.length.toString());

    return Stream.value(utf8.encode(string));
  }

  /// Initializes the [Request] body with a [FormData] object, and sets the
  /// [Content-Type] header.
  Stream<Uint8List> initFormData(FormData formData) async* {
    headers.set('Content-Type', 'multipart/form-data; boundary=$boundary');

    int length = 0;
    await for (final chunk in FormData.encode(formData, boundary)) {
      length += chunk.lengthInBytes;
      yield chunk;
    }

    headers.set('Content-Length', length.toString());
  }

  /// Reads boundary from the [Content-Type] header or generates a new one.
  String get boundary {
    try {
      return headers.multipartBoundary;
    } catch (_) {
      return _storage[#boundary] ??= generateBoundary();
    }
  }
}
