export 'object_url.shared.dart'
    if (dart.library.html) 'object_url.web.dart'
    if (dart.library.io) 'object_url.native.dart';
