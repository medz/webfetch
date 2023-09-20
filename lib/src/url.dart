part of '../url.dart';

/// Uniform Resource Locator (URL) is a text string that specifies where a
/// resource (such as a web page, image, or video) can be found on the Internet.
abstract interface class URL {
  /// Creates and returns a URL object referencing the URL specified using an
  /// absolute URL string, or a relative URL string and a base URL string.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/URL)
  factory URL(Object url, [Object? base]) = _URLConstructor;

  // TODO: canParse()/createObjectURL()/revokeObjectURL()

  /// A string containing a '#' followed by the fragment identifier of the URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/hash)
  abstract String hash;

  /// A string containing the domain (that is the hostname) followed by (if a port was specified) a ':' and the port of the URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/host)
  abstract String host;

  /// A string containing the domain of the URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/hostname)
  abstract String hostname;

  /// A stringifier that returns a string containing the whole URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/href)
  abstract String href;

  /// Returns a string containing the origin of the URL, that is its scheme, its domain and its port.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/origin)
  String get origin;

  /// A string containing the password specified before the domain name.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/password)
  abstract String password;

  /// A string containing an initial '/' followed by the path of the URL, not including the query string or fragment.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/pathname)
  abstract String pathname;

  /// A string containing the port number of the URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/port)
  abstract String port;

  /// A string containing the protocol scheme of the URL, including the final ':'.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/protocol)
  abstract String protocol;

  /// A string indicating the URL's parameter string; if any parameters are provided, this string includes all of them, beginning with the leading ? character.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/search)
  abstract String search;

  /// A `URLSearchParams` object which can be used to access the individual query parameters found in search.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/searchParams)
  URLSearchParams get searchParams;

  /// A string containing the username specified before the domain name.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/username)
  abstract String username;

  /// Returns a string containing the whole URL. It is a synonym for URL.href, though it can't be used to modify the value.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/toString)
  @override
  String toString();

  /// Returns a string containing the whole URL. It returns the same string as the href property.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/toJSON)
  String toJSON();
}
