import 'dart:async';

typedef QueuingStrategySize<T> = int Function(T chunk);

class QueuingStrategy<T> {
  const QueuingStrategy({this.highWaterMark, this.size});

  final int? highWaterMark;
  final QueuingStrategySize<T>? size;
}

sealed class ReadableStreamController<T> {
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/ReadableByteStreamController/desiredSize)
  int? get desiredSize;

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/ReadableByteStreamController/close)
  void close();

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/ReadableByteStreamController/enqueue)
  void enqueue(T chunk);

  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/ReadableByteStreamController/error)
  void error(dynamic error);
}

abstract class ReadableStreamDefaultController<T>
    implements ReadableStreamController<T> {}

/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/ReadableByteStreamController)
abstract class ReadableByteStreamController
    implements ReadableStreamController<List<int>> {
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/ReadableByteStreamController/byobRequest)
  ReadableStreamBYOBRequest get byobRequest;
}

enum ReadableStreamType { bytes }

typedef UnderlyingSourceCancelCallback = FutureOr<void> Function();
typedef UnderlyingSourcePullCallback<T> = FutureOr<void> Function(
    ReadableStreamController<T> controller);
typedef UnderlyingSourceStartCallback<T> = dynamic Function(
    ReadableStreamController<T> controller);

abstract class UnderlyingSource<T> {
  abstract final ReadableStreamType type;
  abstract final bool autoAllocateChunkSize;
  abstract final UnderlyingSourceCancelCallback? cancel;
  abstract final UnderlyingSourcePullCallback<T>? pull;
  abstract final UnderlyingSourceStartCallback<T>? start;
}
