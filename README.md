## Web Fetch

A Dart implementation of the Web Fetch API that allows you to make requests and process results just like using fetch in a browser.

## Features

- Supports the [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- Supports the [FromData API](https://developer.mozilla.org/en-US/docs/Web/API/FormData)
- Supports the [URL API](https://developer.mozilla.org/en-US/docs/Web/API/URL)
- Supports the [URLSearchParams API](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)
- Supports the [Headers API](https://developer.mozilla.org/en-US/docs/Web/API/Headers)
- Supports the [Response API](https://developer.mozilla.org/en-US/docs/Web/API/Response)
- Supports the [Request API](https://developer.mozilla.org/en-US/docs/Web/API/Request)

## Usage

In your `pubspec.yaml`:

```yaml
dependencies:
  webfetch: latest
```

In your Dart code:

```dart
import 'package:webfetch/webfetch.dart';

void main() async {
  final response = await fetch('https://example.com');
  final text = await response.text();
  print(text);
}
```

## Documentation

The library is designed to be as close as possible to the [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API).

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
