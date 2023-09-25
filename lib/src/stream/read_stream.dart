import 'dart:async';

import 'queuing_strategy.dart';
import 'readable_stream_reader.dart';
import 'underlying_source.dart';

/// Represents a readable stream of data.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream)
abstract interface class ReadableStream<T> {
  /// Creates and returns a readable stream object from the given handlers.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream)
  ReadableStream(UnderlyingSource<T> underlyingSource,
      [QueuingStrategy? strategy]);

  /// Returns whether or not the readable stream is locked to a reader.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream/locked)
  bool get locked;

  /// Returns a Promise that resolves when the stream is canceled. Calling this method signals a loss of interest in the stream by a consumer. The supplied reason argument will be given to the underlying source, which may or may not use it.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream/cancel)
  Future<void> cancel([dynamic reason]);

  /// Creates a reader and locks the stream to it. While the stream is locked, no other reader can be acquired until this one is released.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream/getReader)
  ReadableStreamDefaultReader<T> getReader({ReadableStreamReaderMode? mode});
}

class _ReadableStream<T> implements ReadableStream<T> {
  final UnderlyingSource<T> underlyingSource;
  final QueuingStrategy<T>? strategy;
  final StreamController<T> controller;

  _ReadableStream(this.underlyingSource, [this.strategy])
      : controller = StreamController<T>();

  @override
  bool get locked => controller.isClosed;

  @override
  Future<void> cancel([dynamic reason]) async {
    await underlyingSource.cancel?.call();
    if (reason != null) {
      controller.addError(reason);
    }

    await controller.close();
  }

  @override
  ReadableStreamDefaultReader<T> getReader({ReadableStreamReaderMode? mode}) {
    return _ReadableStreamDefaultReader<T>(this);
  }
}

class _ReadableStreamDefaultReader<T>
    implements ReadableStreamDefaultReader<T> {
  final _ReadableStream<T> stream;
  const _ReadableStreamDefaultReader(this.stream);

  @override
  Future<void> get closed => stream.controller.done;

  @override
  Future<ReadableStreamReadResult<T>> read() async {
    final value = await stream.controller.stream.first;
    return ReadableStreamReadResult<T>(value, false);
  }

  @override
  void releaseLock() {}
}
