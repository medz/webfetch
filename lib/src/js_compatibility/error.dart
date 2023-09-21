import 'dart:core' as core;

class ErrorOptions<T> {
  final T? cause;
  const ErrorOptions({this.cause});
}

/// Runtime errors result in new Error objects being created and thrown.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error)
class Error<T extends core.Object?> extends core.Error {
  /// Creates a new Error object.
  Error([this.message = "", ErrorOptions<T>? options]) : cause = options?.cause;

  /// Error message. For user-created Error objects, this is the string
  /// provided as the constructor's first argument.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/message)
  final core.String message;

  /// Providing structured data as the error cause.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/cause)
  final T? cause;

  /// A non-standard property for a stack trace.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/stack)
  core.String get stack => stackTrace?.toString() ?? "";

  /// Represents the name for the type of error.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/name)
  core.String get name => _name ??= runtimeType.toString();

  /// Sets the error name.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/name)
  set name(core.String value) => _name = value;

  /// Internal error name.
  core.String? _name;

  /// Returns a string representing the specified Error object.
  /// Overrides the Object.prototype.toString() method.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/toString)
  @core.override
  core.String toString() => message;
}
