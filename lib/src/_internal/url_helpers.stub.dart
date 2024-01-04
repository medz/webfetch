abstract interface class InnerURL {
  static Uri convert(Object url) {
    return switch (url) {
      String url => Uri.parse(url),
      Uri url => url,
      InnerURL url => Uri.parse(url.toString()),
      _ => throw UnsupportedError('Invalid URL'),
    };
  }
}

bool canParse(Object url, [Object? base]) =>
    throw UnsupportedError('Web Fetch `canParse` stub');

Uri parse(Object url, [Object? base]) =>
    throw UnsupportedError('Web Fetch `Factory` stub');
