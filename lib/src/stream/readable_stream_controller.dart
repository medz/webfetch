sealed class ReadableStreamController<T> {
  int get desiredSize;
  void close();
  void enqueue(T chunk);
  void error(dynamic error);
}
