export 'line_terminator.shared.dart'
    if (dart.library.html) 'line_terminator.web.dart'
    if (dart.library.io) 'line_terminator.native.dart';

const cr = '\r';
const lf = '\n';
