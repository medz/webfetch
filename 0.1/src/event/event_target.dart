/// [MDN Event](https://developer.mozilla.org/en-US/docs/Web/API/Event)
class Event<T extends EventTarget> {
  /// A string with the name of the event.
  final String type;

  /// whether the event bubbles.
  ///
  /// [MDN Event.bubbles](https://developer.mozilla.org/en-US/docs/Web/API/Event/bubbles)
  final bool bubbles;

  /// whether the event is cancelable.
  ///
  /// [MDN Event.cancelable](https://developer.mozilla.org/en-US/docs/Web/API/Event/cancelable)
  final bool cancelable;

  /// whether the event can bubble across the boundary between the shadow DOM and the regular DOM.
  /// [MDN Event.composed](https://developer.mozilla.org/en-US/docs/Web/API/Event/composed)
  final bool composed;

  late final int timeStamp;
  late final T target;

  Event(
    this.type, {
    this.bubbles = false,
    this.cancelable = false,
    this.composed = false,
  });
}

class EventTarget {
  final List<Event> _eventListeners = [];

  /// Dispatches an [Event] at the specified [EventTarget], (synchronously) invoking the affected [EventListeners] in the appropriate order.
  ///
  /// [MDN EventTarget.dispatchEvent](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/dispatchEvent)
  void dispatchEvent(Event event) {
    event.target = this;
    event.timeStamp = DateTime.now().millisecondsSinceEpoch;
    _eventListeners.forEach((listener) {
      if (listener.type == event.type) {
        listener.handleEvent(event);
      }
    });
  }

  /// Registers an event handler of a specific event type on the [EventTarget].
  ///
  /// [MDN EventTarget.addEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener)
  void addEventListener(String type, void Function(Event) listener) {
    _eventListeners.add(_EventListener(type, listener));
  }

  /// Removes an event listener from the [EventTarget].
  ///
  /// [MDN EventTarget.removeEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/removeEventListener)
  void removeEventListener(String type, void Function(Event) listener) {
    _eventListeners.remove(_EventListener(type, listener));
  }
}
