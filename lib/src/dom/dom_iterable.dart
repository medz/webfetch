abstract mixin class DOMIterable<T extends DOMIterable<T, K, V>, K, V> {
  const DOMIterable();

  Iterable<(K, V)> entries();

  Iterable<K> keys() => entries().map((e) => e.$1);
  Iterable<V> values() => entries().map((e) => e.$2);
  void forEach(void Function(V value, K key, T parent) fn) =>
      entries().forEach((element) => fn(element.$2, element.$1, this as T));
}
