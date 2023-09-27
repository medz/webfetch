/// The type read-only property of the Response interface contains the type of the response.
///
/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Response/type)
enum ResponseType {
  /// Normal, same origin response, with all headers exposed except "Set-Cookie".
  basic("basic"),

  /// Response was received from a valid cross-origin request. Certain headers and the body may be accessed.
  cors("cors"),

  /// Network error. No useful information describing the error is available. The Response's status is 0, headers are empty and immutable. This is the type for a Response obtained from Response.error().
  error("error"),

  /// Response for "no-cors" request to cross-origin resource. Severely restricted.
  opaque("opaque"),

  /// The fetch request was made with redirect: "manual". The Response's status is 0, headers are empty, body is null and trailer is empty.
  opaqueRedirect("opaqueredirect");

  final String value;
  const ResponseType(this.value);
}
