import '../json.dart';
import 'url_search_params.dart';

/// Uniform Resource Locator (URL) is a text string that specifies where a
/// resource (such as a web page, image, or video) can be found on the Internet.
abstract interface class URL {
  /// Creates and returns a URL object referencing the URL specified using an
  /// absolute URL string, or a relative URL string and a base URL string.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URL/URL)
  factory URL(Object url, [Object? base]) = _URL;

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

class _URL implements URL {
  /// Internal, Parses a URL string and returns a `Uri` object.
  static Uri _parse(Object url) => switch (url) {
        _URL(uri: final uri) => uri,
        final String url => Uri.parse(url),
        final URL url => Uri.parse(url.toString()),
        final Uri uri => uri,
        _ => throw ArgumentError.value(url, 'url', 'Invalid URL'),
      };

  factory _URL(Object url, [Object? base]) {
    final uri = _parse(url);
    if (base == null) return _URL._(uri);

    final baseUri = _parse(base);
    if (baseUri.origin.isEmpty) {
      throw ArgumentError.value(base, 'base', 'Invalid URL');
    }

    final value = baseUri.resolveUri(uri);
    return _URL._(value);
  }

  _URL._(this.uri) {
    for (final MapEntry(key: name, value: values)
        in uri.queryParametersAll.entries) {
      for (final value in values) {
        searchParams.append(name, value);
      }
    }
  }

  Uri uri;

  @override
  String get hash => uri.fragment;

  @override
  set hash(String value) {
    uri = uri.replace(fragment: value);
  }

  @override
  String get host => uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;

  @override
  set host(String value) {
    final pair =
        value.split(':').where((element) => element.isNotEmpty).toList();
    if (pair.isEmpty) return;
    hostname = pair[0];

    if (pair.length == 2) {
      port = pair[1];
    }
  }

  @override
  String get hostname => uri.host;

  @override
  set hostname(String value) {
    uri = uri.replace(host: value);
  }

  @override
  String get href => uri.fragment;

  @override
  set href(String value) {
    uri = uri.replace(fragment: value);
  }

  @override
  String get origin => uri.origin;

  @override
  String get username => uri.userInfo.split(':').firstOrNull ?? '';

  @override
  set username(String value) {
    if (value.isEmpty) return;

    final password = this.password;
    if (password.isEmpty) {
      uri = uri.replace(userInfo: value);
      return;
    }

    uri = uri.replace(userInfo: '$value:$password');
  }

  @override
  String get password => switch (uri.userInfo.split(':')) {
        Iterable(length: 2, last: final password) => password,
        _ => '',
      };

  @override
  set password(String value) {
    if (value.isEmpty) return;

    uri = uri.replace(userInfo: '$username:$value');
  }

  @override
  String get pathname => uri.path;

  @override
  set pathname(String value) {
    uri = uri.replace(path: value);
  }

  @override
  String get port => uri.hasPort ? uri.port.toString() : '';

  @override
  set port(String value) {
    final port = int.tryParse(value);
    if (port != null) {
      uri = uri.replace(port: port);
    }
  }

  @override
  String get protocol => '${uri.scheme}:';

  @override
  set protocol(String value) {
    final schema =
        value.endsWith(':') ? value.substring(0, value.length - 1) : value;
    if (schema.isEmpty) return;

    uri = uri.replace(scheme: schema);
  }

  @override
  String get search {
    final search = searchParams.toString();
    return search.isEmpty ? '' : '?$search';
  }

  @override
  set search(String value) {
    uri = uri.replace(query: value);
    for (final key in searchParams.keys()) {
      searchParams.delete(key);
    }

    for (final name in uri.queryParametersAll.keys) {
      for (final value in uri.queryParametersAll[name] ?? const <String>[]) {
        searchParams.append(name, value);
      }
    }
  }

  @override
  URLSearchParams get searchParams => _searchParams;
  final _searchParams = URLSearchParams();

  @override
  String toJSON() => JSON.stringify(toString());

  @override
  String toString() {
    if (searchParams.size == 0) return uri.toString();

    return uri.replace(query: searchParams.toString()).toString();
  }
}
