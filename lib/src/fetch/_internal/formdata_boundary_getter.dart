import 'dart:math';

// ignore: implementation_imports
import 'package:http/src/boundary_characters.dart';

const _max = 70; // 70 characters is the max length according to RFC 2046
const _prefix = 'dart-stdweb-boundary-';

abstract interface class FormDataBoundaryGetter {
  /// Get the form data boundary.
  String? get formDataBoundary;

  /// Generate a new form data boundary string.
  static String generateBoundary() {
    final random = Random();
    final length = _max - _prefix.length;
    final charCodes = List.generate(
      length,
      (_) => boundaryCharacters[random.nextInt(boundaryCharacters.length)],
      growable: false,
    );

    return _prefix + String.fromCharCodes(charCodes);
  }

  /// Returns the form data boundary string from the given [contentType].
  static String? getBoundaryFromContentType(String? contentType) {
    final parts = contentType?.split(';').map((e) => e.trim());
    if (parts == null || parts.isEmpty) {
      return null;
    }

    final boundaryPart = parts.firstWhere(
      (e) => e.toLowerCase().startsWith('boundary='),
      orElse: () => '',
    );
    if (boundaryPart.isEmpty) {
      return null;
    }

    String boundary = boundaryPart.substring('boundary='.length).trim();
    if (boundary.startsWith('"')) {
      boundary = boundary.substring(1);
    }
    if (boundary.endsWith('"')) {
      boundary = boundary.substring(0, boundary.length - 1);
    }

    return boundary;
  }
}
