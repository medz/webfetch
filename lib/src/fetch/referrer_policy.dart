/// The Referrer-Policy HTTP header controls how much referrer information (sent with the Referer header) should be included with requests. Aside from the HTTP header, you can set this policy in HTML.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy)
enum ReferrerPolicy {
  // By default ""
  default_(''),

  /// The Referer header will be omitted: sent requests do not include any referrer information.
  noReferrer('no-referrer'),

  /// Send the origin, path, and querystring in Referer when the protocol security level stays the same or improves (HTTP→HTTP, HTTP→HTTPS, HTTPS→HTTPS). Don't send the Referer header for requests to less secure destinations (HTTPS→HTTP, HTTPS→file).
  noReferrerWhenDowngrade('no-referrer-when-downgrade'),

  /// Send only the origin in the Referer header. For example, a document at https://example.com/page.html will send the referrer https://example.com/.
  origin('origin'),

  /// When performing a same-origin request to the same protocol level (HTTP→HTTP, HTTPS→HTTPS), send the origin, path, and query string. Send only the origin for cross origin requests and requests to less secure destinations (HTTPS→HTTP).
  originWhenCrossOrigin('origin-when-cross-origin'),

  /// Send the origin, path, and query string for same-origin requests. Don't send the Referer header for cross-origin requests.
  sameOrigin('same-origin'),

  /// Send only the origin when the protocol security level stays the same (HTTPS→HTTPS). Don't send the Referer header to less secure destinations (HTTPS→HTTP).
  strictOrigin('strict-origin'),

  /// Send the origin, path, and querystring when performing a same-origin request. For cross-origin requests send the origin (only) when the protocol security level stays same (HTTPS→HTTPS). Don't send the Referer header to less secure destinations (HTTPS→HTTP).
  strictOriginWhenCrossOrigin('strict-origin-when-cross-origin'),

  /// Send the origin, path, and query string when performing any request, regardless of security.
  unsafeUrl('unsafe-url');

  final String value;
  const ReferrerPolicy(this.value);
}
