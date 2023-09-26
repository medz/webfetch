import 'dart:typed_data';

import '../file/blob.dart';
import '../url/url.dart';
import '_internal/body.dart';
import 'formdata.dart';
import 'headers.dart';
import 'referrer_policy.dart';
import 'request_cache.dart';
import 'request_credentials.dart';
import 'request_destination.dart';
import 'request_mode.dart';
import 'request_redirect.dart';

part '_internal/request.dart';

/// This Fetch API interface represents a resource request.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request)
abstract interface class Request implements Body {
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
  }) = _RequestImpl;

  /// A [Stream] of the body content.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/body)
  @override
  Stream<Uint8List> get body;

  /// Stores true or false to indicate whether or not the body has been used in
  /// a request yet.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/bodyUsed)
  @override
  bool get bodyUsed;

  /// Contains the cache mode of the request (e.g., default, reload, no-cache).
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/cache)
  RequestCache get cache;

  /// Contains the credentials of the request (e.g., omit, same-origin, include). The default is same-origin.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/credentials)
  RequestCredentials get credentials;

  /// A string describing the type of content being requested.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/destination)
  RequestDestination get destination;

  /// Contains the associated [Headers] object of the request.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/headers)
  @override
  Headers get headers;

  /// Returns request's subresource integrity metadata, which is a cryptographic hash of the resource being fetched. Its value consists of multiple hashes separated by whitespace. [SRI]
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Request/integrity)
  String get integrity;

  /// Contains the request's method (GET, POST, etc.)
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/method)
  String get method;

  /// Contains the mode of the request (e.g., cors, no-cors, same-origin, navigate.)
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/mode)
  RequestMode get mode;

  /// Contains the mode for how redirects are handled. It may be one of follow, error, or manual.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/redirect)
  RequestRedirect get redirect;

  /// Contains the referrer of the request (e.g., client).
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/referrer)
  String get referrer;

  /// Contains the referrer policy of the request (e.g., no-referrer).
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/referrerPolicy)
  ReferrerPolicy get referrerPolicy;

  /// Contains the URL of the request.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/url)
  String get url;

  /// Returns a promise that resolves with an ArrayBuffer representation of the
  /// request body.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/arrayBuffer)
  @override
  Future<Uint8List> arrayBuffer();

  /// Returns a promise that resolves with a Blob representation of the
  /// request body.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/blob)
  @override
  Future<Blob> blob();

  /// Returns a promise that resolves with a FormData representation of the request body.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/formData)
  @override
  Future<FormData> formData();

  /// Returns a promise that resolves with the result of parsing the request body as JSON.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/json)
  @override
  Future<Object> json();

  /// Returns a promise that resolves with a text representation of the request body.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/text)
  @override
  Future<String> text();

  /// Creates a copy of the current Request object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/clone)
  @override
  Request clone();

  /// Returns the [AbortSignal] associated with the request.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/signal)
  // AbortSignal get signal; // TODO: Implement AbortSignal
}
