import 'dart:async';

(Stream<T>, Stream<T>) copyTwoStreams<T>(Stream<T> stream) {
  final controller1 = StreamController<T>();
  final controller2 = StreamController<T>();

  stream.listen((event) {
    controller1.add(event);
    controller2.add(event);
  }, onError: (error) {
    controller1.addError(error);
    controller2.addError(error);
  }, onDone: () {
    controller1.close();
    controller2.close();
  });

  return (controller1.stream, controller2.stream);
}
