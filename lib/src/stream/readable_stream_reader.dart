enum ReadableStreamReaderMode { byob }

class ReadableStreamReadResult<T> {
  final T value;
  final bool done;

  ReadableStreamReadResult(this.value, this.done);
}

abstract interface class ReadableStreamDefaultReader<T> {
  /// Returns a promise that will be fulfilled when the stream becomes closed, or rejected if the stream ever errors or the reader's lock is released before the stream finishes closing.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultReader/closed)
  Future<void> get closed;

  /// Returns a promise that allows access to the next chunk from the stream's internal queue, if available. If the chunk is available, the promise is fulfilled with an object of the form { value: ... } where value is the next chunk. If there will be no more chunks in the stream, the promise is fulfilled with an object of the form { done: true }. If an error occurs, the promise is rejected with that error.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultReader/read)
  Future<ReadableStreamReadResult<T>> read();

  /// Releases the reader's lock on the corresponding stream. After the lock is released, the reader is no longer active. If the associated stream is errored when the lock is released, the reader will appear errored in the same way from now on; otherwise, the reader will appear closed.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultReader/releaseLock)
  void releaseLock();
}
