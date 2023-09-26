/// The destination read-only property of the Request interface returns a
/// string describing the type of content being requested.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/Request/destination)
enum RequestDestination {
  /// The default value of destination is used for destinations that do not
  /// have their own value.
  default_(''),

  /// The target is audio data.
  audio('audio'),

  /// The target is data being fetched for use by an audio worklet.
  audioWorklet('audioworklet'),

  /// The target is a document (HTML or XML).
  document('document'),

  /// The target is embedded content.
  embed('embed'),

  /// The target is a font.
  font('font'),

  /// The target is an image.
  image('image'),

  /// The target is a manifest.
  manifest('manifest'),

  /// The target is an object.
  object('object'),

  /// The target is a paint worklet.
  paintWorklet('paintworklet'),

  /// The target is a report.
  report('report'),

  /// The target is a script.
  script('script'),

  /// The target is a service worker.
  serviceWorker('serviceworker'),

  /// The target is a shared worker.
  sharedWorker('sharedworker'),

  /// The target is a style.
  style('style'),

  /// The target is an HTML <track>.
  track('track'),

  /// The target is video data.
  video('video'),

  /// The target is a worker.
  worker('worker'),

  /// The target is an XSLT transform.
  xslt('xslt');

  final String value;
  const RequestDestination(this.value);
}
