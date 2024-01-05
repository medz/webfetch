extension InternalStorageHelper on Map<Symbol, dynamic> {
  T of<T>(Symbol key, T Function() factory) {
    final existing = this[key];
    if (existing is T) return existing;

    return this[key] = factory();
  }
}
