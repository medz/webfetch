import 'package:webfetch/webfetch.dart';

void main() async {
  final formData = FormData();
  formData.append('name', 'John Doe');
  formData.append('age', '42');

  final blob = Blob(['Hello, World!'], type: 'text/plain');
  formData.append('file', blob, 'hello.txt');

  final response = await fetch(
    'https://webhook.site/34d4401b-3c1e-4941-be2c-9a9c17cf9afe?',
    method: "POST",
    body: formData,
    keepalive: true,
  );

  print(await response.text());
}
