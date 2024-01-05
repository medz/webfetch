import 'dart:js_interop' as js_interop;
import 'dart:js_util' as js_util;
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import '../_internal/headers_boundary.dart';
import '../blob.dart';
import '../formdata.dart';
import '../headers.dart';
import '../request.dart';
import '../response.dart';
import '../response_type.dart';
import '../types.dart';
import 'client.stub.dart' as stub;

String? _defaultUserAgent;

String get _readUserAgent {
  if (_defaultUserAgent != null) return _defaultUserAgent!;
  if (js_util.hasProperty(js_util.globalThis, 'navigator')) {
    final navigator = js_util.getProperty(js_util.globalThis, 'navigator');
    if (js_util.hasProperty(navigator, 'userAgent')) {
      final userAgent =
          js_util.getProperty<js_interop.JSString>(navigator, 'userAgent');

      return _defaultUserAgent = userAgent.toDart;
    }
  }

  return '';
}

class Client implements stub.Client {
  const Client();

  @override
  Future<Response> send(Request request, {bool keepalive = false}) async {
    // Creates a new web request
    final webRequest = web.Request(
        request.url.toJS,
        web.RequestInit(
          method: request.method,
          body: await request.arrayBuffer().then((value) => value.toJS),
          referrer: request.referrer,
          referrerPolicy: request.referrerPolicy.value,
          mode: request.mode.value,
          credentials: request.credentials.value,
          cache: request.cache.value,
          redirect: request.redirect.name,
          integrity: request.integrity,
          keepalive: keepalive,
        ));

    // Sets headers
    for (final (name, value) in request.headers.entries()) {
      webRequest.headers.append(name, value);
    }

    // Sets `Set-Cookie` header
    for (final cookie in request.headers.getSetCookie()) {
      webRequest.headers.append('Set-Cookie', cookie);
    }

    if (!webRequest.headers.has('user-agent')) {
      webRequest.headers
          .set('user-agent', ['webfetch', _readUserAgent].join('; '));
    }

    final webResponse = (await _fetch(webRequest).toDart) as web.Response;

    return _InnerResponse(webResponse);
  }
}

@js_interop.JS('fetch')
@js_interop.staticInterop
@js_interop.anonymous
external js_interop.JSPromise _fetch(web.Request request);

extension on web.Headers {
  void forEach(void Function(String value, String name) fn) {
    void innerFn(js_interop.JSString value, js_interop.JSString key) =>
        fn(value.toDart, key.toDart);

    final foreach = js_util.getProperty<js_interop.JSFunction>(this, 'forEach');
    foreach.callAsFunction(
        null.jsify(), js_util.allowInterop(innerFn) as dynamic);
  }
}

class _InnerResponse implements Response {
  Headers? _headers;

  final web.Response _webResponse;

  _InnerResponse(this._webResponse);

  @override
  Stream<Uint8List> get body async* {
    if (_webResponse.body == null) {
      return;
    }

    final reader = _webResponse.body!.getReader();
    final read =
        js_util.getProperty<js_interop.JSFunction>(reader as Object, 'read');
    for (;;) {
      final result =
          (await (read.callAsFunction() as js_interop.JSPromise).toDart)!;
      final done = js_util.getProperty<bool>(result, 'done');
      if (done) {
        break;
      }

      final chunk = js_util
          .getProperty<js_interop.JSUint8Array?>(result, 'value')
          ?.toDart;
      if (chunk != null) {
        yield chunk;
      }
    }
  }

  @override
  Headers get headers {
    if (_headers != null) return _headers!;

    _headers = Headers();
    _webResponse.headers
        .forEach((value, name) => _headers!.append(name, value));

    for (final cookie in _webResponse.headers.getSetCookie().toDart) {
      _headers!.append('set-cookie', (cookie as js_interop.JSString).toDart);
    }

    return _headers!;
  }

  @override
  bool get redirected => _webResponse.redirected;

  @override
  int get status => _webResponse.status;

  @override
  ResponseType get type {
    final type = _webResponse.type;
    return ResponseType.values.firstWhere((element) =>
        element.value.toLowerCase().trim() == type.toLowerCase().trim());
  }

  @override
  String get url => _webResponse.url;

  @override
  Future<ArrayBuffer> arrayBuffer() async {
    final buffer = await _webResponse.arrayBuffer().toDart;
    final bytes = (buffer as js_interop.JSUint8Array).toDart;

    return bytes.buffer;
  }

  @override
  Future<Blob> blob() async => Blob([await arrayBuffer()]);

  @override
  bool get bodyUsed => _webResponse.bodyUsed;

  @override
  Response clone() => _InnerResponse(_webResponse.clone());

  @override
  Future<FormData> formData() =>
      FormData.decode(body, headers.multipartBoundary);

  @override
  Future<Object> json() async {
    final value = await _webResponse.json().toDart;
    return (value as js_interop.JSObject).dartify()!;
  }

  @override
  bool get ok => _webResponse.ok;

  @override
  String get statusText => _webResponse.statusText;

  @override
  Future<String> text() async {
    final value = await _webResponse.text().toDart;

    return (value as js_interop.JSString).toDart;
  }
}
