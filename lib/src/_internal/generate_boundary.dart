import 'dart:math';

const boundaryCharacters =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-';

String generateBoundary() {
  final random = Random.secure();
  final characters = List.generate(
      60, (_) => boundaryCharacters[random.nextInt(boundaryCharacters.length)],
      growable: false);

  return '-webfetch-${characters.join()}';
}
