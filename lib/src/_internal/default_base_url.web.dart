import 'dart:js_util' as js_util;
import 'package:web/web.dart' as web;

/// window.location.href
String? get defaultBaseURL {
  if (js_util.hasProperty(js_util.globalThis, 'location')) {
    return js_util
        .getProperty<web.Location>(js_util.globalThis, 'location')
        .href;
  }

  return null;
}
