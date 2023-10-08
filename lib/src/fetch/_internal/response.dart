part of '../response.dart';

final class _Response implements Response, FormDataBoundaryGetter {
  final Body _body;

  const _Response.raw(
    Body body, {
    required this.status,
    required this.statusText,
    this.type = ResponseType.basic,
    this.redirected = false,
    this.url = '',
  }) : _body = body;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/Response)
  factory _Response(
    Object? body, {
    int? status,
    String? statusText,
    Object? headers,
  }) =>
      _Response.raw(Body(body, headers: Headers(headers)),
          status: status ?? 200, statusText: statusText ?? 'OK');

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/error)
  factory _Response.error() => _Response.raw(
        Body(null, headers: Headers()),
        type: ResponseType.error,
        status: 0,
        statusText: '',
      );

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/json)
  factory _Response.json(
    Object? data, {
    int? status,
    String? statusText,
    Object? headers,
  }) {
    return _Response.raw(
      Body(
        JSON.stringify(data),
        headers: Headers(headers)..set('content-type', 'application/json'),
      ),
      status: status ?? 200,
      statusText: statusText ?? 'OK',
    );
  }

  // [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/redirect)
  factory _Response.redirect(Object url, [int status = 302]) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _url = URL(url).toString();
    if (!redirectMap.containsKey(status)) {
      throw ArgumentError.value(
        status,
        'status',
        'Invalid redirect status code',
      );
    }

    return _Response.raw(
      Body(null, headers: Headers({'location': _url})),
      status: status,
      statusText: redirectMap[status]!,
      redirected: true,
      url: _url,
      type: ResponseType.opaque,
    );
  }

  static const redirectMap = <int, String>{
    301: 'Moved Permanently',
    302: 'Found',
    303: 'See Other',
    307: 'Temporary Redirect',
    308: 'Permanent Redirect',
  };

  @override
  final bool redirected;

  @override
  final int status;

  @override
  final String statusText;

  @override
  final ResponseType type;

  @override
  final String url;

  @override
  String? get formDataBoundary => switch (_body) {
        FormDataBoundaryGetter(formDataBoundary: final boundary) => boundary,
        _ => FormDataBoundaryGetter.getBoundaryFromContentType(
            headers.get('content-type')),
      };

  @override
  bool get ok => status >= 200 && status < 300;

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
  Response clone() {
    return _Response.raw(
      _body.clone(),
      redirected: redirected,
      status: status,
      statusText: statusText,
      type: type,
      url: url,
    );
  }
}
