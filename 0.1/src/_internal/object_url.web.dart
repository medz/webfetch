import 'dart:js_interop';

import 'package:web/web.dart';

String createObjectURL(Object object) {
  // TODO: implement createObjectURL
  return switch (object) {
    JSObject box => URL.createObjectURL(box),
    _ => URL.createObjectURL(object.toJSBox),
  };
}

void revokeObjectURL(String url) => URL.revokeObjectURL(url);
