import 'dart:typed_data';

import 'package:mime/mime.dart';

import '../../file/blob.dart';
import '../formdata.dart';
import '../headers.dart';

class FormDataDecoder extends MimeMultipartTransformer {
  FormDataDecoder(super.boundary);

  Future<FormData> convert(Stream<Uint8List> input) async {
    final formData = FormData();
    final stream = bind(input);

    await for (final part in stream) {
      final headers = Headers(part.headers);
      final contentType = headers.get('content-type');

      final contentDisposition = headers.get('content-disposition');
      // If the part headers doesn't have a Content-Disposition header, skip it.
      if (contentDisposition == null) continue;

      final name = _parseParameter('name', contentDisposition);
      // If the Content-Disposition doesn't have a name, skip it.
      if (name == null) continue;

      // Read the part filename, if not it will be null.
      final filename = _parseParameter('filename', contentDisposition);

      // Read the part content.
      final buffer = <int>[];
      await part.forEach(buffer.addAll);

      // Create the part to blob.
      final blob = Blob(buffer, type: contentType);

      // Add the part to the form data.
      formData.append(name, blob, filename);
    }

    return formData;
  }

  /// Returns the [parameter] of content-disposition header.
  String? _parseParameter(String parameter, String contentDisposition) {
    final parts = contentDisposition.split(';').map((e) => e.trim());
    final part = parts.firstWhere(
      (e) => e.toLowerCase().startsWith('${parameter.toLowerCase()}='),
      orElse: () => '',
    );

    String? value = switch (part.split('=')) {
      List(length: 2, last: final value) => value.trim(),
      List(length: > 2, skip: final skip) => skip(1).join('=').trim(),
      _ => null,
    };

    if (value == null) return null;
    if (value.startsWith('"')) value = value.substring(1);
    if (value.endsWith('"')) {
      value = value.substring(0, value.length - 1);
    }

    return value;
  }
}
