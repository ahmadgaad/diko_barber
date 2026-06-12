/// A sealed class representing the result of an operation that can either
/// succeed with a value of type [T] or fail with an error of type [E].
///
/// This provides compile-time safety by forcing explicit handling of both
/// success and failure cases.
sealed class Result<E, T> {
  const Result();

  /// Returns `true` if this is a [Success] result.
  bool get isSuccess => this is Success<E, T>;

  /// Returns `true` if this is a [Failure] result.
  bool get isFailure => this is Failure<E, T>;

  /// Returns the success value or `null` if this is a failure.
  T? getOrNull() {
    return switch (this) {
      Success(:final data) => data,
      Failure() => null,
    };
  }

  /// Returns the success value or [defaultValue] if this is a failure.
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(:final data) => data,
      Failure() => defaultValue,
    };
  }

  /// Returns the error or `null` if this is a success.
  E? errorOrNull() {
    return switch (this) {
      Success() => null,
      Failure(:final error) => error,
    };
  }

  /// Transforms the success value using [transform] function.
  /// If this is a failure, returns the failure unchanged.
  Result<E, R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Success(transform(data)),
      Failure(:final error) => Failure(error),
    };
  }

  /// Transforms the error using [transform] function.
  /// If this is a success, returns the success unchanged.
  Result<R, T> mapError<R>(R Function(E error) transform) {
    return switch (this) {
      Success(:final data) => Success(data),
      Failure(:final error) => Failure(transform(error)),
    };
  }

  /// Handles both success and failure cases with the provided callbacks.
  R when<R>({
    required R Function(E error) failure,
    required R Function(T data) success,
  }) {
    return switch (this) {
      Failure(:final error) => failure(error),
      Success(:final data) => success(data),
    };
  }

  /// Chains another operation that returns a Result.
  /// If this is a failure, returns the failure unchanged.
  Result<E, R> flatMap<R>(Result<E, R> Function(T data) transform) {
    return switch (this) {
      Success(:final data) => transform(data),
      Failure(:final error) => Failure(error),
    };
  }
}

/// Represents a successful result containing [data].
final class Success<E, T> extends Result<E, T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<E, T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed result containing [error].
final class Failure<E, T> extends Result<E, T> {
  final E error;

  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<E, T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}
