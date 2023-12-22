import 'dart:math';

// ignore: implementation_imports
import 'package:http/src/boundary_characters.dart';

String generateBoundary() {
  final random = Random.secure();
  final charCodes = List.generate(
      60, (_) => boundaryCharacters[random.nextInt(boundaryCharacters.length)],
      growable: false);

  return '-webfetch-${String.fromCharCodes(charCodes)}';
}
