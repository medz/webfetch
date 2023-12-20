import 'dart:typed_data';

import 'blob.dart';
import 'types.dart';

/// Provides information about files and allows JavaScript in a web page
/// to access their content.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/File)
class File implements Blob {
  @override
  Future<ArrayBuffer> arrayBuffer() => _blob.arrayBuffer();

  @override
  int get size => _blob.size;

  @override
  Blob slice([int? start, int? end, String? contentType]) =>
      _blob.slice(start, end, contentType);

  @override
  Stream<Uint8List> stream() => _blob.stream();

  @override
  Future<String> text() => _blob.text();

  @override
  // TODO: implement type
  String get type => throw UnimplementedError();

  /// Returns the last modified time of the file, in millisecond since the
  /// UNIX epoch (January 1st, 1970 at Midnight).
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/File/lastModified)
  final int lastModified;

  /// Returns the name of the file referenced by the File object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/File/name)
  final String name;

  /// Returns the path the URL of the File is relative to.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/File/webkitRelativePath)
  @Deprecated('Non-implemented feature')
  String get webkitRelativePath => '';

  late final Blob _blob;

  /// Returns a newly constructed File.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/File/File)
  File(
    Iterable<Object> blobParts,
    String fileName, {
    EndingType endings = EndingType.transparent,
    String type = '',
    int? lastModified,
  })  : name = fileName,
        lastModified = lastModified ?? 0 {
    _blob = Blob(blobParts, endings: endings, type: type);
  }
}
