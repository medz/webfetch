/// The encodeURIComponent() function encodes a Uniform Resource Identifier (URI)
/// component by replacing each instance of certain characters by one, two,
/// three, or four escape sequences representing the UTF-8 encoding of the
/// character (will only be four escape sequences for characters composed of
/// two "surrogate" characters).
///
/// - [uriComponent] - A value representing an encoded URI component.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent)
String encodeURIComponent(String uriComponent) =>
    Uri.encodeComponent(uriComponent);

/// The encodeURI() function encodes a Uniform Resource Identifier (URI)
/// by replacing each instance of certain characters by one, two, three,
/// or four escape sequences representing the UTF-8 encoding of the character
/// (will only be four escape sequences for characters composed of two
/// "surrogate" characters).
///
/// - [uri] - A complete Uniform Resource Identifier.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURI)
String encodeURI(String uri) => Uri.encodeFull(uri);
