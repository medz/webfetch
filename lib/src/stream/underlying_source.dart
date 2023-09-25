import 'dart:async';

import 'readable_stream_controller.dart';

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
