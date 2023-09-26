import 'dart:convert';
import 'dart:typed_data';

import '../../file/file.dart';
import '../formdata.dart';

class FormDataEncoder extends Converter<FormData, Future<Uint8List>> {
  const FormDataEncoder(this.boundary)
      : assert(boundary.length <= 70,
            'The boundary length must be less than or equal to 70.');

  final String boundary;

  static const lineBreak = '\r\n';
  static const defaultContentType = 'application/octet-stream';

  @override
  Future<Uint8List> convert(FormData input) async {
    final separator = utf8.encode('--$boundary$lineBreak');
    final chunks = <int>[];

    for (final (name, value) in input.entries()) {
      // Add separator.
      chunks.addAll(separator);

      // Add form field.
      chunks.addAll(
        switch (value) {
          FormDataEntryValueString(value: final text) =>
            convertText(name, text),
          final FormDataEntryValueFile file => await convertFile(name, file),
        },
      );
    }

    // Add end boundary.
    chunks.addAll(utf8.encode('--$boundary--$lineBreak'));

    return Uint8List.fromList(chunks);
  }

  /// Converts a text form field to a list of bytes.
  Iterable<int> convertText(String name, String value) {
    return [
      ...utf8.encode('Content-Disposition: form-data; name="$name"'),
      ...utf8.encode(lineBreak),
      ...utf8.encode(lineBreak),
      ...utf8.encode(value),
      ...utf8.encode(lineBreak),
    ];
  }

  /// Converts a file form field to a list of bytes.
  Future<Iterable<int>> convertFile(String name, File file) async {
    return [
      ...utf8.encode(
        'Content-Disposition: form-data; name="$name"; filename="${file.name}"',
      ),
      ...utf8.encode(lineBreak),
      ...utf8.encode(
        'Content-Type: ${file.type.isNotEmpty ? file.type : defaultContentType}',
      ),
      ...utf8.encode(lineBreak),
      ...utf8.encode(lineBreak),
      ...await file.arrayBuffer(),
      ...utf8.encode(lineBreak),
    ];
  }
}
