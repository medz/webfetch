import 'package:stdweb/url.dart';

void main(List<String> args) {
  final url = URL('?x=1', 'https://example.com/hahah');
  print(url.toString());
}
