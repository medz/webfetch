import 'dart:typed_data';

import '../file/blob.dart';
import '../js_compatibility/json.dart';
import '../url/url.dart';
import '_internal/body.dart';
import '_internal/formdata_boundary_getter.dart';
import 'formdata.dart';
import 'headers.dart';
import 'response_type.dart';

part '_internal/response.dart';

/// This Fetch API interface represents the response to a request.
///
/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response)
abstract interface class Response implements Body {
  /// Creates a new [Response] object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/Response)
  factory Response(
    Object? body, {
    int? status,
    String? statusText,
    Object? headers,
  }) = _Response;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/error_static)
  factory Response.error() = _Response.error;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/json_static)
  factory Response.json(
    Object? data, {
    int? status,
    String? statusText,
    Object? headers,
  }) = _Response.json;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/redirect_static)
  factory Response.redirect(Object url, [int status]) = _Response.redirect;

  /// A boolean indicating whether the response was successful (status in the range 200 – 299) or not.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/ok)
  bool get ok;

  /// Indicates whether or not the response is the result of a redirect (that is, its URL list has more than one entry).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/redirected)
  bool get redirected;

  /// The status code of the response. (This will be 200 for a success).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/status)
  int get status;

  /// The status message corresponding to the status code. (e.g., OK for 200).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/statusText)
  String get statusText;

  /// The type of the response (e.g., basic, cors).
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/type)
  ResponseType get type;

  /// The URL of the response.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/url)
  String get url;

  /// A ReadableStream of the body contents.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/body)
  @override
  Stream<Uint8List> get body;

  /// Stores a boolean value that declares whether the body has been used in a response yet.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/bodyUsed)
  @override
  bool get bodyUsed;

  /// The Headers object associated with the response.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/headers)
  @override
  Headers get headers;

  /// Returns a promise that resolves with an ArrayBuffer representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/arrayBuffer)
  @override
  Future<Uint8List> arrayBuffer();

  /// Returns a promise that resolves with a Blob representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/blob)
  @override
  Future<Blob> blob();

  /// Returns a promise that resolves with a FormData representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/formData)
  @override
  Future<FormData> formData();

  /// Returns a promise that resolves with the result of parsing the response body text as JSON.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/json)
  @override
  Future<Object> json();

  /// Returns a promise that resolves with a text representation of the response body.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/text)
  @override
  Future<String> text();

  /// Creates a clone of a Response object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/Response/clone)
  @override
  Response clone();
}
