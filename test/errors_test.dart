import 'package:errors/errors.dart';
import 'package:test/test.dart';

class SomeException implements Exception {
  const SomeException();
  String toString() => 'SomeException';
}

class AnotherException implements Exception {
  const AnotherException();
  String toString() => 'AnotherException';
}

class SomeExceptionHandler extends ErrorHandler<SomeException> {
  bool check;
  SomeExceptionHandler();
  handle(SomeException exception, StackTrace stackTrace) {
    this.check = true;
  }
}

class AnotherExceptionHandler extends ErrorHandler<AnotherException> {
  bool check;
  handle(AnotherException exception, StackTrace stackTrace) {
    this.check = true;
  }
}

// Also need to normalize the exception.

void main() {
  Errors errors;
  SomeExceptionHandler someExceptionHandler = SomeExceptionHandler();
  AnotherExceptionHandler anotherExceptionHandler = AnotherExceptionHandler();
  setUpAll(() {
    errors = Errors()
      ..addHandler(someExceptionHandler)
      ..addHandler(anotherExceptionHandler);
  });
  test('Handle some exception', () {
    errors.handleError(
      () {
        throw SomeException();
      },
    );

    expect(someExceptionHandler.check, true);
  });

  test('Handles another exception', () {
    errors.handleError(
      () {
        throw AnotherException();
      },
    );

    expect(someExceptionHandler.check, true);
  });

  test('Throws ErrorHandlerNotFoundException if no exception handler found',
      () {
    expect(
      () => errors.handleError(
        () {
          throw Exception();
        },
      ),
      throwsA(
        TypeMatcher<ErrorHandlerNotFoundException>(),
      ),
    );
  });
}
