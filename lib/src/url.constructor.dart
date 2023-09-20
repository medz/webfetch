part of '../url.dart';

class _URLConstructor implements URL {
  factory _URLConstructor(Object url, [Object? base]) {
    final uri = _parse(url);
    if (base == null) return _URLConstructor._(uri);

    final baseUri = _parse(base);
    if (baseUri.origin.isEmpty) {
      throw ArgumentError.value(base, 'base', 'Invalid URL');
    }

    final value = baseUri.resolveUri(uri);
    return _URLConstructor._(value);
  }

  /// Internal, Parses a URL string and returns a `Uri` object.
  static Uri _parse(Object url) => switch (url) {
        _URLConstructor(uri: final uri) => uri,
        final String url => Uri.parse(url),
        final URL url => Uri.parse(url.toString()),
        final Uri uri => uri,
        _ => throw ArgumentError.value(url, 'url', 'Invalid URL'),
      };

  _URLConstructor._(this.uri) {
    for (final name in uri.queryParametersAll.keys) {
      for (final value in uri.queryParametersAll[name] ?? const <String>[]) {
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
  String toJSON() {
    // TODO: implement toJSON
    throw UnimplementedError();
  }

  @override
  String toString() {
    if (searchParams.size == 0) return uri.toString();

    return uri.replace(query: searchParams.toString()).toString();
  }
}
