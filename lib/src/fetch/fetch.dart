import 'dart:async';

import 'package:http/http.dart' as http;

import '../file/blob.dart';
import '../url/url_search_params.dart';
import '_internal/body.dart';
import '_internal/formdata_boundary_getter.dart';
import 'headers.dart';
import 'referrer_policy.dart';
import 'request.dart';
import 'request_cache.dart';
import 'request_credentials.dart';
import 'request_mode.dart';
import 'request_redirect.dart';
import 'response.dart';
import 'response_type.dart';

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
});

/// The fetch() method starts the process of fetching a resource from the network, returning a promise which is fulfilled once the response is available.
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
  );

  final httpStreamedRequest =
      http.StreamedRequest(request.method, Uri.parse(request.url));

  // Apply headers
  request.headers.forEach((value, key, _) {
    httpStreamedRequest.headers[key] = value;
  });
  if (!request.headers.has('user-agent')) {
    httpStreamedRequest.headers['user-agent'] = 'stdweb/fetch';
  }

  if (!request.headers.has('content-type')) {
    httpStreamedRequest.headers['content-type'] = switch (body) {
      Blob(type: final type) => type,
      URLSearchParams() => 'application/x-www-form-urlencoded;charset=utf-8',
      Object() => 'application/json;charset=utf-8',
      _ => 'application/octet-stream',
    };
  }

  if (request is FormDataBoundaryGetter) {
    final boundary = (request as FormDataBoundaryGetter).formDataBoundary;
    if (boundary != null) {
      httpStreamedRequest.headers['content-type'] =
          'multipart/form-data; boundary=$boundary';
    }
  }

  if (!request.headers.has('accept')) {
    httpStreamedRequest.headers['accept'] = '*/*';
  }

  final blob = await request.blob();
  if (blob.size > 0) {
    httpStreamedRequest.contentLength = blob.size;
    httpStreamedRequest.sink.add(await blob.arrayBuffer());
  }

  unawaited(httpStreamedRequest.sink.close());

  httpStreamedRequest.followRedirects =
      request.redirect == RequestRedirect.follow;
  httpStreamedRequest.persistentConnection = keepalive ?? true;

  // Cache
  if (!request.headers.has('cache-control') &&
      request.cache != RequestCache.default_) {
    httpStreamedRequest.headers['cache-control'] = request.cache.value;
  }

  // Referrer
  if (!request.headers.has('referrer') &&
      request.referrer.isNotEmpty &&
      request.referrerPolicy != ReferrerPolicy.noReferrer) {
    httpStreamedRequest.headers['referrer'] = request.referrer;
  }

  final httpStreamedResponse = await httpStreamedRequest.send();
  if (httpStreamedResponse.isRedirect &&
      request.redirect == RequestRedirect.error) {
    throw Exception('Redirect mode is set to error: $httpStreamedResponse');
  }

  return Response.raw(
    Body(httpStreamedResponse.stream,
        headers: Headers(httpStreamedResponse.headers)),
    status: httpStreamedResponse.statusCode,
    statusText: httpStreamedResponse.reasonPhrase ?? '',
    type: switch (request) {
      Request(redirect: RequestRedirect.manual) => ResponseType.opaqueRedirect,
      _ => ResponseType.basic,
    },
    redirected: httpStreamedResponse.isRedirect,
    url: httpStreamedResponse.request?.url.toString() ?? request.url,
  );
}
