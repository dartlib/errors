library errors;

typedef void VoidFunc();

/// Abstract class each error handles has to extend.
///
/// The generic type T must be the type of exception which will be handled.
///
abstract class ErrorHandler<T> {
  handle(T exception, StackTrace stackTrace);

  /// Returns the type of error this handler handles.
  ///
  Type getType() {
    return T;
  }
}

/// This exception is thrown in case Errors is unable to find a handler for the exception.
///
class Errors {
  final _handlers = Map<String, ErrorHandler<dynamic>>();

  /// [handler] Error Handler
  addHandler(ErrorHandler handler) {
    final type = handler.getType().toString();
    assert(!_handlers.containsKey(type),
        'ErrorHandler for Type ${type} is already registered.');

    _handlers[type] = handler;
  }

  /// [func] Function containing the guarded code to be executed.
  handleError(VoidFunc func) {
    try {
      func();
    } catch (error, stackTrace) {
      if (!onError(error, stackTrace)) {
        rethrow;
      }
    }
  }

  onError(Object error, StackTrace stackTrace) {
    final handler = _handlers[error.runtimeType.toString()];

    if (handler != null) {
      handler.handle(error, stackTrace);

      return true;
    }

    return false;
  }
}
