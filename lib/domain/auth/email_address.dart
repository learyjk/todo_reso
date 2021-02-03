import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'email_address.freezed.dart';

//https://www.youtube.com/watch?v=fdUwW0GgcS8&list=PLB6lc7nQ1n4iS5p-IezFFgqP6YvAJy84U&index=2
// Make Illegal states unrepresentable

@immutable
class EmailAddress {
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) {
    //assert input is not null
    assert(input != null);

    //use private constructor
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }

  // private constructor which will be used in factory constructor if email is valid.
  const EmailAddress._(this.value);

  @override
  String toString() {
    return 'EmailAddress($value)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is EmailAddress && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

// Use a REGEX expression to valid the email address.
Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    // right side of Either gives String of valid email
    return right(input);
  } else {
    // left side of either gives ValueFailure<String>
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({
    @required String failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.shortPassword({
    @required String failedValue,
  }) = ShortPassword<T>;
}

void showingTheEmailAddressOrFailure() {
  final emailAddress = EmailAddress('fasdf');
  String emailText = emailAddress.value.fold(
    (left) => 'Failure happened, more precisely: $left',
    (right) => right,
  );

  String emailText2 =
      emailAddress.value.getOrElse(() => 'Some Failure happened');
}

// Custom Exception to throw if email validation fails.
// This forces us to wrap validated objects in try/catch block which can be excessive.
// We have to know or lookup what exceptions can be throw then to.
// class InvalidEmailException implements Exception {
//   final String failedValue;
//
//   InvalidEmailException({@required this.failedValue});
// }

// Think of the failures we could have...
// InvalidEmailFailure
// InvalidPasswordFailure

// dartz for Either Type
// freezed for unions
