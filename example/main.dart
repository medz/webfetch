import 'package:webfetch/webfetch.dart';

void main() async {
  final formData = FormData();
  formData.append('name', 'John Doe');
  formData.append('age', '42');

  final blob = Blob(['Hello, World!'], type: 'text/plain');
  formData.append('file', blob, 'hello.txt');

  final headers = Headers();
  headers.append('x-multiple', 'Value 1');
  headers.append('x-multiple', 'Value 2');

  final response = await fetch(
    'https://webhook.site/9e179866-34ba-487d-8538-7c69ca963a01',
    method: "POST",
    body: formData,
    keepalive: true,
    headers: headers,
  );

  print(await response.text());
}
