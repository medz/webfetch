import 'error.dart';

/// The URIError object represents an error when a global URI
/// handling function was used in a wrong way.
class URIError extends Error {
  URIError([super.message, super.options]);
}
