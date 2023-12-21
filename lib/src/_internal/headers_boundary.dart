import '../headers.dart';
import 'iterable_first_where_or_null.dart';

extension HeadersBoundary on Headers {
  String get multipartBoundary {
    final contentType = get('Content-Type');
    if (contentType == null) {
      throw StateError('Content-Type header is not set');
    }

    final parts = contentType.split(';').map((e) => e.trim());
    final boundaryPart = parts.firstWhereOrNull(
      (e) => e.toLowerCase().startsWith('boundary='),
    );
    if (boundaryPart == null) {
      throw StateError('Content-Type header does not contain boundary');
    }

    String boundary = boundaryPart.substring('boundary='.length).trim();
    boundary = boundary.startsWith('"') ? boundary.substring(1) : boundary;
    boundary = boundary.endsWith('"')
        ? boundary.substring(0, boundary.length - 1)
        : boundary;
    boundary = boundary.startsWith("'") ? boundary.substring(1) : boundary;
    boundary = boundary.endsWith("'")
        ? boundary.substring(0, boundary.length - 1)
        : boundary;
    if (boundary.isEmpty) {
      throw StateError('Boundary is empty');
    }

    return boundary;
  }
}
