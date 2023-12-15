import 'dart:convert';

import 'url_search_params.dart';
import '_internal/object_url.dart' as _internal;

/// Uniform Resource Locator (URL) is a text string that specifies where a
/// resource (such as a web page, image, or video) can be found on the Internet.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL)
class URL {
  /// Internal, Parses a URL string and returns a `Uri` object.
  static Uri _parse(Object url, String name) => switch (url) {
        URL(href: final url) => Uri.parse(url),
        final String url => Uri.parse(url),
        final Uri uri => uri,
        _ => throw ArgumentError.value(url, name, 'Invalid URL'),
      };

  /// https://developer.mozilla.org/en-US/docs/Web/API/URL/createObjectURL_static
  ///
  /// Creates a DOMString containing a URL representing the object given in the
  /// parameter. The URL lifetime is tied to the document in the window on which
  /// it was created. The new object URL represents the specified File object or
  /// Blob object.
  static String createObjectURL(Object object) =>
      _internal.createObjectURL(object);

  /// https://developer.mozilla.org/en-US/docs/Web/API/URL/revokeObjectURL_static
  ///
  /// Revokes an object URL previously created using URL.createObjectURL().
  static void revokeObjectURL(String url) => _internal.revokeObjectURL(url);

  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/canParse_static)
  ///
  /// Returns a Boolean indicating if the given string is a well-formed URL.
  static bool canParse(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (_) {
      return false;
    }
  }

  Uri _uri;
  URLSearchParams _searchParams;

  /// Internal, creates a new [URL]
  URL._(this._uri) : _searchParams = URLSearchParams(_uri.queryParametersAll);

  /// Creates and returns a URL object referencing the URL specified using an
  /// absolute URL string, or a relative URL string and a base URL string.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/URL)
  factory URL(Object url, [Object? base]) {
    final uri = _parse(url, 'url');
    if (base == null) return URL._(uri);

    final baseUri = _parse(base, 'base');
    if (baseUri.origin.isEmpty) {
      throw ArgumentError.value(base, 'base', 'Invalid URL');
    }

    return URL._(baseUri.resolveUri(uri));
  }

  /// A string containing a '#' followed by the fragment identifier of the URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/hash)
  String get hash => _uri.fragment;
  set hash(String value) => _uri = _uri.replace(fragment: value);

  /// A string containing the domain (that is the hostname) followed by (if a
  /// port was specified) a ':' and the port of the URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/host)
  String get host => _uri.host;
  set host(String value) => _uri = _uri.replace(host: value);

  /// A string containing the domain of the URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/hostname)
  String get hostname => host.split(':').first;
  set hostname(String value) => throw UnimplementedError();

  /// A stringifier that returns a string containing the whole URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/href)
  String get href => _uri.replace(query: search.toString()).toString();
  set href(String value) {
    _uri = Uri.parse(value);
    _searchParams = URLSearchParams(_uri.queryParametersAll);
  }

  /// Returns a string containing the origin of the URL, that is its scheme,
  /// its domain and its port.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/origin)
  String get origin => _uri.origin;

  /// A string containing the password specified before the domain name.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/password)
  String get password => switch (_uri.userInfo.split(':')) {
        Iterable(length: 2, last: final password) => password,
        _ => '',
      };
  set password(String value) {
    if (value.isEmpty) return;
    _uri = _uri.replace(userInfo: '$username:$value');
  }

  /// A string containing an initial '/' followed by the path of the URL, not
  /// including the query string or fragment.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/pathname)
  String get pathname => _uri.path;
  set pathname(String value) => _uri = _uri.replace(path: value);

  /// A string containing the port number of the URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/port)
  String get port => _uri.hasPort ? _uri.port.toString() : '';
  set port(String value) => _uri = _uri.replace(port: int.parse(value));

  /// A string containing the protocol scheme of the URL, including the
  /// final ':'.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/protocol)
  String get protocol => '${_uri.scheme}:';
  set protocol(String value) => _uri = _uri.replace(
      scheme:
          value.endsWith(':') ? value.substring(0, value.length - 1) : value);

  /// A string indicating the URL's parameter string; if any parameters are provided, this string includes all of them, beginning with the leading ? character.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/search)
  String get search {
    final search = searchParams.toString();
    return search.isEmpty ? '' : '?$search';
  }

  /// A `URLSearchParams` object which can be used to access the individual query parameters found in search.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/searchParams)
  URLSearchParams get searchParams => _searchParams;

  /// A string containing the username specified before the domain name.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/username)
  String get username => _uri.userInfo.split(':').first;
  set username(String value) {
    if (value.isEmpty) return;
    if (password.isEmpty) {
      _uri = _uri.replace(userInfo: value);
      return;
    }

    _uri = _uri.replace(userInfo: '$value:$password');
  }

  /// Returns a string containing the whole URL. It is a synonym for URL.href, though it can't be used to modify the value.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/toString)
  @override
  String toString() => href;

  /// Returns a string containing the whole URL. It returns the same string as the href property.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/toJSON)
  String toJSON() => json.encode(href);
}
