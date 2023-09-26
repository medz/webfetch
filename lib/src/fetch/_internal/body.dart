import 'dart:convert';
import 'dart:typed_data';

import '../../file/blob.dart';
import '../../js_compatibility/json.dart';
import '../../url/url_search_params.dart';
import '../formdata.dart';
import '../headers.dart';
import 'formdata_boundary_getter.dart';
import 'formdata_decoder.dart';
import 'formdata_encoder.dart';

part 'body_impl.dart';

/// Request/Response body.
///
/// [MDN reference(Request)](https://developer.mozilla.org/en-US/docs/Web/API/Request)
/// [MDN reference(Response)](https://developer.mozilla.org/en-US/docs/Web/API/Response)
abstract interface class Body {
  factory Body(
    Object? body, {
    required Headers headers,
  }) = _Body;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/body)
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/body)
  Stream<Uint8List> get body;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/bodyUsed)
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/bodyUsed)
  bool get bodyUsed;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/headers)
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/headers)
  Headers get headers;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/arrayBuffer)
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/arrayBuffer)
  Future<Uint8List> arrayBuffer();

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/blob)
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/blob)
  Future<Blob> blob();

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/formData)
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/formData)
  Future<FormData> formData();

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/json)
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/json)
  Future<Object> json();

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/text)
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/text)
  Future<String> text();

  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/clone)
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Response/clone)
  Body clone();
}
