part of '../url_search_params.dart';

class _URLSearchParams extends URLSearchParams {
  _URLSearchParams._([CaseInsensitiveMap<List<String>>? map])
      : super.from(map ?? CaseInsensitiveMap<List<String>>());

  factory _URLSearchParams.fromRecords(Iterable<(String, String)> init) {
    final map = CaseInsensitiveMap<List<String>>();

    for (final record in init) {
      final (key, value) = record;
      map[key] = [...map[key] ?? [], value];
    }

    return _URLSearchParams._(map);
  }

  factory _URLSearchParams.fromParts(Iterable<Iterable<String>> init) {
    final records =
        init.where((e) => e.isNotEmpty).map((e) => (e.first, e.skip(1).join()));

    return _URLSearchParams.fromRecords(records);
  }

  factory _URLSearchParams.fromIterable(Iterable<String> init) {
    final parts = init.map((e) => e.split('='));

    return _URLSearchParams.fromParts(parts);
  }

  factory _URLSearchParams.fromMap(Map<String, String> init) {
    final records = init.entries.map((e) => (e.key, e.value));

    return _URLSearchParams.fromRecords(records);
  }

  factory _URLSearchParams([Object? init]) {
    return switch (init) {
      final URLSearchParams init => _URLSearchParams(init.entries()),
      final Uri init => _URLSearchParams(init.queryParametersAll),
      final String init => _URLSearchParams(Uri.parse(init)),
      final Iterable<(String, String)> init =>
        _URLSearchParams.fromRecords(init),
      final Iterable<Iterable<String>> init => _URLSearchParams.fromParts(init),
      final Iterable<String> init => _URLSearchParams.fromIterable(init),
      final Map<String, String> init => _URLSearchParams.fromMap(init),
      null => _URLSearchParams._(),
      _ => throw ArgumentError.value(init, 'init', 'Invalid init value'),
    };
  }
}
