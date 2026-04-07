import 'package:sqflite/sqflite.dart';

sealed class LocalDatabaseException implements Exception {
  final String message;
  final dynamic originalError;

  const LocalDatabaseException({required this.message, this.originalError});

  factory LocalDatabaseException.fromDatabaseException(DatabaseException e) {
    if (e.isDatabaseClosedError()) {
      return LocalDatabaseClosedException(
        message: e.toString(),
        originalError: e,
      );
    } else if (e.isDuplicateColumnError()) {
      return LocalDatabaseDuplicateColumnException(
        message: e.toString(),
        originalError: e,
      );
    } else if (e.isNoSuchTableError()) {
      return LocalDatabaseNoSuchTableException(
        message: e.toString(),
        originalError: e,
      );
    } else if (e.isNotNullConstraintError()) {
      return LocalDatabaseNotNullConstraintException(
        message: e.toString(),
        originalError: e,
      );
    } else if (e.isOpenFailedError()) {
      return LocalDatabaseOpenFailedException(
        message: e.toString(),
        originalError: e,
      );
    } else if (e.isReadOnlyError()) {
      return LocalDatabaseReadOnlyException(
        message: e.toString(),
        originalError: e,
      );
    } else if (e.isSyntaxError()) {
      return LocalDatabaseSyntaxException(
        message: e.toString(),
        originalError: e,
      );
    } else if (e.isUniqueConstraintError()) {
      return LocalDatabaseUniqueConstraintException(
        message: e.toString(),
        originalError: e,
      );
    } else {
      return LocalDatabaseUnknownException(
        message: e.toString(),
        originalError: e,
      );
    }
  }
}

class LocalDatabaseClosedException extends LocalDatabaseException {
  const LocalDatabaseClosedException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

class LocalDatabaseDuplicateColumnException extends LocalDatabaseException {
  const LocalDatabaseDuplicateColumnException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

class LocalDatabaseNoSuchTableException extends LocalDatabaseException {
  const LocalDatabaseNoSuchTableException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

class LocalDatabaseNotNullConstraintException extends LocalDatabaseException {
  const LocalDatabaseNotNullConstraintException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

class LocalDatabaseOpenFailedException extends LocalDatabaseException {
  const LocalDatabaseOpenFailedException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

class LocalDatabaseReadOnlyException extends LocalDatabaseException {
  const LocalDatabaseReadOnlyException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

class LocalDatabaseSyntaxException extends LocalDatabaseException {
  const LocalDatabaseSyntaxException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

class LocalDatabaseUniqueConstraintException extends LocalDatabaseException {
  const LocalDatabaseUniqueConstraintException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

class LocalDatabaseUnknownException extends LocalDatabaseException {
  const LocalDatabaseUnknownException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}
