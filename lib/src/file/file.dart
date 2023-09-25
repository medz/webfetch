import 'blob.dart';

/// Provides information about files and allows JavaScript in a web page
/// to access their content.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/File)
class File extends Blob {
  /// Returns a newly constructed File.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/File/File)
  factory File(
    Iterable<Object> blobParts,
    String fileName, {
    EndingType? endings,
    String? type,
    int? lastModified,
  }) {
    final blob = Blob(blobParts, endings: endings, type: type);
    return File.from(
      blob.stream(),
      size: blob.size,
      type: blob.type,
      lastModified: lastModified ?? DateTime.now().millisecondsSinceEpoch,
      name: fileName,
    );
  }

  File.from(
    super.stream, {
    required super.size,
    required super.type,
    required this.lastModified,
    required this.name,
    this.webkitRelativePath = '',
  }) : super.from();

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
  final String webkitRelativePath;
}
