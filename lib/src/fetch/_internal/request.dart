part of '../request.dart';

final class _RequestImpl implements Request, FormDataBoundaryGetter {
  final Body _body;
  final String _method;

  @override
  String? get formDataBoundary => switch (_body) {
        FormDataBoundaryGetter(formDataBoundary: final boundary) => boundary,
        _ => FormDataBoundaryGetter.getBoundaryFromContentType(
            headers.get('content-type')),
      };

  const _RequestImpl._(
    this.url, {
    required Body body,
    required this.cache,
    required this.credentials,
    required this.destination,
    required this.integrity,
    required String method,
    required this.mode,
    required this.redirect,
    required this.referrer,
    required this.referrerPolicy,
  })  : _body = body,
        _method = method;

  /// [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/Request)
  factory _RequestImpl(
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
    if (input is Request) {
      return _RequestImpl._(
        input.url,
        body: Body(
          body ?? input.body,
          headers: headers != null ? Headers(headers) : input.headers,
        ),
        cache: cache ?? input.cache,
        credentials: credentials ?? input.credentials,
        destination: destination ?? input.destination,
        integrity: integrity ?? input.integrity,
        method: method ?? input.method,
        mode: mode ?? input.mode,
        redirect: redirect ?? input.redirect,
        referrer: referrer ?? input.referrer,
        referrerPolicy: referrerPolicy ?? input.referrerPolicy,
      );
    }

    return _RequestImpl._(
      // TODO: If browser, use URL(input, window.location.href).toString()
      URL(input).toString(),
      body: Body(body, headers: Headers(headers)),
      cache: cache ?? RequestCache.default_,
      credentials: credentials ?? RequestCredentials.sameOrigin,
      destination: destination ?? RequestDestination.default_,
      integrity: integrity ?? '',
      method: method ?? 'GET',
      mode: mode ?? RequestMode.noCors,
      redirect: redirect ?? RequestRedirect.follow,
      referrer: referrer ?? 'about:client',
      referrerPolicy: referrerPolicy ?? ReferrerPolicy.default_,
    );
  }

  @override
  final RequestCache cache;

  @override
  final RequestCredentials credentials;

  @override
  final RequestDestination destination;

  @override
  final String integrity;

  @override
  String get method => _method.toUpperCase();

  @override
  final RequestMode mode;

  @override
  final RequestRedirect redirect;

  @override
  final String referrer;

  @override
  final ReferrerPolicy referrerPolicy;

  @override
  final String url;

  @override
  Stream<Uint8List> get body => _body.body;

  @override
  bool get bodyUsed => _body.bodyUsed;

  @override
  Headers get headers => _body.headers;

  @override
  Future<Uint8List> arrayBuffer() => _body.arrayBuffer();

  @override
  Future<Blob> blob() => _body.blob();

  @override
  Future<FormData> formData() => _body.formData();

  @override
  Future<Object> json() => _body.json();

  @override
  Future<String> text() => _body.text();

  @override
  Request clone() {
    return _RequestImpl._(
      url,
      body: _body.clone(),
      cache: cache,
      credentials: credentials,
      destination: destination,
      integrity: integrity,
      method: method,
      mode: mode,
      redirect: redirect,
      referrer: referrer,
      referrerPolicy: referrerPolicy,
    );
  }
}
