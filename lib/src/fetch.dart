import 'client/client.dart';
import 'referrer_policy.dart';
import 'request.dart';
import 'request_cache.dart';
import 'request_credentials.dart';
import 'request_destination.dart';
import 'request_mode.dart';
import 'request_redirect.dart';
import 'response.dart';

final _globalClient = Client();
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
  RequestDestination? destination,
  bool? keepalive,
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
}) {
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

  return _globalClient.send(request, keepalive: keepalive ?? false);
}

extension Fetch$Client on Fetch {
  Fetch use(Client client) => (
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
      }) =>
          client.send(
              keepalive: keepalive ?? false,
              Request(
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
              ));
}
