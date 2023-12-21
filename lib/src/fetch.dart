import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'blob.dart';
import 'formdata.dart';
import 'headers.dart';
import 'referrer_policy.dart';
import 'request.dart';
import 'request_cache.dart';
import 'request_credentials.dart';
import 'request_destination.dart';
import 'request_mode.dart';
import 'request_redirect.dart';
import 'response.dart';
import 'response_type.dart';
import 'types.dart';

typedef Fetch = Future<Response> Function(
  Object resource, {
  String? method,
  Object? headers,
  Object? body,
  RequestMode? mode,
  RequestCredentials? credentials,
  RequestCache? cache,
  RequestRedirect? redirect,
  String? referrer,
  ReferrerPolicy? referrerPolicy,
  String? integrity,
  bool? keepalive,
  RequestDestination? destination,
});

/// The fetch() method starts the process of fetching a resource from the
/// network, returning a promise which is fulfilled once the response is
/// available.
///
/// [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/fetch)
Future<Response> fetch(
  Object resource, {
  String? method,
  Object? headers,
  Object? body,
  RequestMode? mode,
  RequestCredentials? credentials,
  RequestCache? cache,
  RequestRedirect? redirect,
  String? referrer,
  ReferrerPolicy? referrerPolicy,
  String? integrity,
  bool? keepalive,
  RequestDestination? destination,
}) async {
  final request = Request(
    resource,
    method: method,
    headers: headers,
    body: body,
    mode: mode,
    credentials: credentials,
    cache: cache,
    redirect: redirect,
    referrer: referrer,
    referrerPolicy: referrerPolicy,
    integrity: integrity,
    destination: destination,
  );

  final streamedRequest =
      http.StreamedRequest(request.method, Uri.parse(request.url));
  streamedRequest.persistentConnection = keepalive ?? true;

  await streamedRequest.applyBody(await request.blob());
  streamedRequest.applyHeaders(request.headers);
  streamedRequest.applySecOrOtherHeaders(request);

  if (request.redirect == RequestRedirect.error ||
      request.redirect == RequestRedirect.manual) {
    streamedRequest.followRedirects = false;
  }

  final streamedResponse = await streamedRequest.send();
  if (streamedResponse.isRedirect) {
    if (request.redirect == RequestRedirect.error) {
      throw StateError('Redirect mode is set to error');
    }
  }

  final response = Response(
    streamedResponse.stream.map((event) => Uint8List.fromList(event)),
    status: streamedResponse.statusCode,
    statusText: streamedResponse.reasonPhrase,
    headers: Headers(streamedResponse.headers),
  );
  response.url = streamedResponse.request?.url.toString() ?? request.url;

  return _OnlyReadResponse(response, redirected: streamedResponse.isRedirect);
}

extension on http.StreamedRequest {
  /// Apply headers to the request
  void applyHeaders(Headers headers) {
    if (!headers.has('user-agent')) {
      headers.set('user-agent', 'dart/webfetch');
    }

    headers.forEach((value, name, parent) {
      this.headers[name] = value;
    });
  }

  /// Apply body to the request
  Future<void> applyBody(Blob blob) async {
    await for (final event in blob.stream()) {
      sink.add(event);
    }

    unawaited(sink.close());
  }

  /// Apply security or other headers to the request
  /// https://fetch.spec.whatwg.org/#forbidden-header-name
  void applySecOrOtherHeaders(Request request) {
    // Set-cookie TODO: Multiple cookies https://github.com/dart-lang/http/issues/24
    for (final cookie in request.headers.getSetCookie()) {
      headers['set-cookie'] = cookie;
    }

    if (request.destination != RequestDestination.default_) {
      headers['sec-fetch-dest'] = request.destination.value;
    }

    headers['sec-fetch-mode'] = request.mode.value;
    headers['sec-fetch-site'] = 'same-origin';
    headers['sec-fetch-user'] = '?0';

    // Referer
    if (!request.headers.has('referer')) {
      headers['referer'] = request.referrer;
    }
  }
}

class _OnlyReadResponse implements Response {
  const _OnlyReadResponse(this.response, {this.redirected = false});

  final Response response;

  @override
  Stream<Uint8List> get body => response.body;

  @override
  Headers get headers => response.headers;

  @override
  final bool redirected;

  @override
  int get status => response.status;

  @override
  ResponseType get type => response.type;

  @override
  String get url => response.url;

  @override
  Future<ArrayBuffer> arrayBuffer() => response.arrayBuffer();

  @override
  Future<Blob> blob() => response.blob();

  @override
  bool get bodyUsed => response.bodyUsed;

  @override
  Response clone() => response.clone();

  @override
  Future<FormData> formData() => response.formData();

  @override
  Future<Object> json() => response.json();

  @override
  bool get ok => response.ok;

  @override
  String get statusText => response.statusText;

  @override
  Future<String> text() => response.text();

  @override
  set body(Stream<Uint8List> value) {
    throw UnsupportedError('body is read-only');
  }

  @override
  set headers(Headers value) {
    throw UnsupportedError('headers is read-only');
  }

  @override
  set redirected(bool value) {
    throw UnsupportedError('redirected is read-only');
  }

  @override
  set status(int value) {
    throw UnsupportedError('status is read-only');
  }

  @override
  set type(ResponseType value) {
    throw UnsupportedError('type is read-only');
  }

  @override
  set url(String value) {
    throw UnsupportedError('url is read-only');
  }
}
