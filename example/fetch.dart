import 'package:stdweb/stdweb.dart';

void main() async {
  final formData = FormData();
  formData.append('name', 'John Doe');
  formData.append('age', '42');

  final blob = Blob(['Hello, World!'], type: 'text/plain');
  formData.append('file', blob, 'hello.txt');

  final response = await fetch(
    'https://webhook.site/5d37e618-9650-4a6d-bc96-612b4b7d583b',
    method: "POST",
    body: formData,
  );

  print(await response.text());
}
