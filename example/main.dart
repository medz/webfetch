import 'package:webfetch/webfetch.dart';

void main() async {
  final formData = FormData();
  formData.append('name', 'John Doe');
  formData.append('age', '42');

  final blob = Blob(['Hello, World!'], type: 'text/plain');
  formData.append('file', blob, 'hello.txt');

  final response = await fetch(
    'https://webhook.site/9e179866-34ba-487d-8538-7c69ca963a01',
    method: "POST",
    body: formData,
    keepalive: true,
  );

  print(await response.text());
}
