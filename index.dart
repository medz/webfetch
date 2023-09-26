import 'package:stdweb/stdweb.dart';

void main() async {
  final fromData = FormData();
  fromData.append('name', 'John');
  fromData.append('name', 'Seven');

  final blob = Blob(['Hello World']);
  fromData.append('file', blob, 'hello.txt');

  final request = Request(
    'https://httpbin.org/post',
    method: 'POST',
    body: fromData,
  );

  print(await request.text());
}
