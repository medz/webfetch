import 'url_helpers.stub.dart' show InnerURL;

export 'url_helpers.stub.dart' show InnerURL;

bool canParse(Object url, [Object? base]) {
  try {
    parse(url, base);
    return true;
  } catch (_) {
    return false;
  }
}

Uri parse(Object url, [Object? base]) {
  final innerURI = InnerURL.convert(url);
  if (base == null) return innerURI;

  return InnerURL.convert(base).resolveUri(innerURI);
}
