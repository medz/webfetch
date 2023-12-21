/// The credentials read-only property of the Request interface indicates
/// whether the user agent should send or receive cookies from the other domain
/// in the case of cross-origin requests.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/credentials)
enum RequestCredentials {
  /// Never send or receive cookies.
  omit('omit'),

  /// Send user credentials (cookies, basic http auth, etc..) if the URL is on the same origin as the calling script.
  ///
  /// **This is the default value.**
  sameOrigin('same-origin'),

  /// Always send user credentials (cookies, basic http auth, etc..), even for
  /// cross-origin calls.
  include('include');

  final String value;
  const RequestCredentials(this.value);
}
