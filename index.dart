import 'package:stdweb/stdweb.dart';

void main() async {
  final fromData = FormData();
  fromData.append('name', 'John');
  fromData.append('name', 'Seven');

  final blob = Blob(['Hello World']);
  fromData.append('file', blob, 'hello.txt');

  print(fromData.get('file')); // John
}
