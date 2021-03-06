import 'dart:io';

// An exception class for exceptions that are intended to be seen by the user.
//
// These exceptions won't have any debugging information printed when they're
// thrown.
class TaskException implements Exception {
  final String message;

  TaskException(this.message);

  @override
  String toString() => message;
}

class UnsupportedPlatformException extends TaskException {
  UnsupportedPlatformException()
      : super('${Platform.operatingSystem} is not supported');
}
