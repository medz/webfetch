import 'dart:convert';
import 'uri_error.dart';

/// Gets the unencoded version of an encoded component of a Uniform
/// Resource Identifier (URI).
///
/// - [encodedURIComponent] - A value representing an encoded URI component.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURIComponent)
decodeURIComponent(String encodedURIComponent) {
  final iterator = utf8.encoder.convert(encodedURIComponent).iterator;
  final codeUnits = <int>[];
  while (iterator.moveNext()) {
    final codeUnit = iterator.current;
    if (codeUnit == 37) {
      try {
        final hex1 = iterator.moveNext() ? iterator.current : null;
        final hex2 = iterator.moveNext() ? iterator.current : null;
        if (hex1 == null || hex2 == null) throw Error();

        final hex = String.fromCharCodes([hex1, hex2]);
        codeUnits.add(int.parse(hex, radix: 16));
      } catch (e) {
        throw URIError("URI malformed");
      }
    } else {
      codeUnits.add(codeUnit);
    }
  }

  return utf8.decoder.convert(codeUnits);
}

/// The decodeURI() function decodes a Uniform Resource Identifier (URI)
/// previously created by encodeURI() or a similar routine.
///
/// - [encodedURI] - A complete, encoded Uniform Resource Identifier.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURI)
String decodeURI(String encodedURI) => decodeURIComponent(encodedURI);
