part of 'body.dart';

class _Body implements Body, FormDataBoundaryGetter {
  _Body.from(
    this._raw, {
    required this.headers,
    this.formDataBoundary,
  });

  factory _Body(
    Object? body, {
    required Headers headers,
  }) {
    final raw = switch (body) {
      final _Body body => body._unsafeBody,
      final Body body => body.body,
      final String text => text,
      final Blob blob => blob,
      final URLSearchParams urlSearchParams => urlSearchParams,
      final FormData formData => formData,
      final Uint8List bytes => bytes,
      final Stream<Uint8List> stream => stream,
      null => Uint8List(0),
      final Object json => JSON.stringify(json),
    };

    final String? boundary = switch (raw) {
      FormData() => FormDataBoundaryGetter.generateBoundary(),
      _ => FormDataBoundaryGetter.getBoundaryFromContentType(
          headers.get('content-type')),
    };

    return _Body.from(raw, headers: headers, formDataBoundary: boundary);
  }

  bool _used = false;
  final Object _raw;
  Uint8List? _buffer;

  @override
  final Headers headers;

  @override
  bool get bodyUsed => _used;

  @override
  final String? formDataBoundary;

  /// Call body used, if [bodyUsed] is true, throw [StateError].
  /// Set [bodyUsed] to true.
  void _throwIfBodyUsed() {
    if (bodyUsed) {
      throw StateError('Body already used');
    }

    _used = true;
  }

  /// Returns the body buffer without checking [bodyUsed].
  Future<Uint8List> _unsafeArrayBuffer() async {
    return _buffer ??= switch (_raw) {
      final Uint8List bytes => bytes,
      final Blob blob => await blob.arrayBuffer(),
      final String text => Uint8List.fromList(utf8.encode(text)),
      final URLSearchParams urlSearchParams =>
        Uint8List.fromList(utf8.encode(urlSearchParams.toString())),
      final FormData formData =>
        await FormDataEncoder(formDataBoundary!).convert(formData),
      final Stream<Uint8List> stream =>
        await Blob.from(stream, size: 0).arrayBuffer(),
      _ => Uint8List(0),
    };
  }

  @override
  Future<Uint8List> arrayBuffer() {
    _throwIfBodyUsed();

    return _unsafeArrayBuffer();
  }

  @override
  Future<Blob> blob() {
    _throwIfBodyUsed();

    return _unsafeBlob();
  }

  Future<Blob> _unsafeBlob() async {
    if (_raw is Blob) return _raw as Blob;
    return Blob(await arrayBuffer(), type: headers.get('content-type'));
  }

  @override
  Stream<Uint8List> get body {
    _throwIfBodyUsed();

    return _unsafeBody;
  }

  Stream<Uint8List> get _unsafeBody => Stream.fromFuture(_unsafeArrayBuffer());

  @override
  Future<FormData> formData() async {
    _throwIfBodyUsed();

    if (_raw is FormData) return _raw as FormData;
    if (formDataBoundary == null) {
      throw StateError('Cannot get FormData from body');
    }

    return FormDataDecoder(formDataBoundary!).convert(_unsafeBody);
  }

  @override
  Future<String> text() {
    _throwIfBodyUsed();

    return _unsafeText();
  }

  Future<String> _unsafeText() async {
    return switch (_raw) {
      final String text => text,
      final Blob blob => await blob.text(),
      _ => utf8.decode(await _unsafeArrayBuffer(), allowMalformed: true),
    };
  }

  @override
  Future<Object> json() async {
    _throwIfBodyUsed();

    return JSON.parse(await _unsafeText());
  }

  @override
  Body clone() {
    return _Body.from(
      _unsafeBody,
      headers: headers,
      formDataBoundary: formDataBoundary,
    );
  }
}
