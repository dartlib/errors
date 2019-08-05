# errors 

Errors keeps a registry of all possible exceptions which could be encountered.

Many times several exceptions can occur, some common and some less common.

In order to handle these gracefully we will often want to react differently according to the nature of the error.

e.g. code might fail due to a http error and within the same block a disk could be full or even a legitimate
user error could be thrown.

Quick example:
```dart
  Errors errors;
  SomeExceptionHandler someExceptionHandler = SomeExceptionHandler();
  AnotherExceptionHandler anotherExceptionHandler = AnotherExceptionHandler();
  
  final errors = Errors()
      ..addHandler(someExceptionHandler)
      ..addHandler(anotherExceptionHandler);
  
  // Instead of using try/catch blocks the exceptions are now 
  // automatically catched and the registered exception handlers will
  // handle the exceptions.
  
  errors.handleError(
    () {
      throw SomeException();
    },
  );

  errors.handleError(
    () {
      throw AnotherException();
    },
  );
```

