import 'dart:convert';

import 'package:stdweb/stdweb.dart';

void main(List<String> args) async {
  final a = Blob(['你好']);
  final b = Blob(utf8.encoder.convert('世界'));
  final c = Blob([a, b]);

  print(c.size);
  print(await c.text());
  print(await c.text());
  print(await c.slice(-3, null).text());
}
