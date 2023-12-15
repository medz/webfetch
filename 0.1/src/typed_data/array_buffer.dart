// typedef ArrayBuffer = ByteBuffer;

// extension ArrayBufferExtension on ArrayBuffer {}

extension type const E(String message) {
  factory E.two(String message) => message as E;

  void echo() => print(message);
}

echo(E e) => e.echo();

void main(List<String> args) {
  const demo = E('1');
  echo('hello' as E);
}
