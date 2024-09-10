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
    'https://webhook.site/8bde8e5b-3c69-4c4f-80ee-1d086f4270e9',
    method: "POST",
    body: formData,
    keepalive: true,
    headers: headers,
  );

  print(response.body);
  print(response.body);

  print(await response.text());
}
