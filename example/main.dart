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
    'https://webhook.site/1d7e5914-6113-4568-a7bc-7d30199cba97',
    method: "POST",
    body: formData,
    keepalive: true,
    headers: headers,
  );

  print(response.body);
  print(response.body);

  print(await response.text());
}
