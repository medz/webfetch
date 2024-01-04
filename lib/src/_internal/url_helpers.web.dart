import 'dart:convert';

import 'package:web/web.dart' as web;
import 'url_helpers.stub.dart' show InnerURL;

export 'url_helpers.stub.dart' show InnerURL;

bool canParse(Object url, [Object? base]) {
  try {
    final innerURL = switch (url) {
      web.URL url => json.decode(url.toJSON()).toString(),
      _ => InnerURL.convert(url).toString(),
    };

    if (base != null) {
      final innerBase = switch (base) {
        web.URL url => json.decode(url.toJSON()).toString(),
        _ => InnerURL.convert(base).toString(),
      };

      return web.URL.canParse(innerURL, innerBase);
    }

    return web.URL.canParse(innerURL);
  } catch (_) {
    return false;
  }
}

Uri parse(Object url, [Object? base]) {
  final innerURL = switch (url) {
    web.URL url => Uri.parse(json.decode(url.toJSON())),
    _ => InnerURL.convert(url),
  };

  if (base != null) {
    final innerBase = switch (base) {
      web.URL url => Uri.parse(json.decode(url.toJSON())),
      _ => InnerURL.convert(base),
    };

    return innerBase.resolveUri(innerURL);
  }

  return innerURL;
}
