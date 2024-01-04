export 'client.stub.dart'
    if (dart.library.html) 'client.web.dart'
    if (dart.library.io) 'client.io.dart';
