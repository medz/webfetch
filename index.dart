import 'dart:convert';

import 'package:stdweb/stdweb.dart';

void main(List<String> args) async {
  final blob = Blob(['哈哈'], type: 'text/plain');

  print(blob.size);
  print(blob.type);
}
