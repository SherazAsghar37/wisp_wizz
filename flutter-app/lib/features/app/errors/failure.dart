import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({
    required this.message,
  });

  @override
  String toString() => "Error: $message";
  @override
  List<Object?> get props => [
        message,
      ];
}

class ApiFailure extends Failure {
  final int statusCode;
  const ApiFailure({required super.message, required this.statusCode});

  ApiFailure.fromException(ApiException e)
      : this(message: e.message, statusCode: e.statusCode);
  @override
  String toString() => "$statusCode, Error: $message";

  @override
  List<Object?> get props => [message, statusCode];
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });

  @override
  List<Object?> get props => [
        message,
      ];
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });

  CacheFailure.fromException(CacheException e)
      : this(
          message: e.message,
        );

  @override
  List<Object?> get props => [message];
}

class ContactFailure extends Failure {
  const ContactFailure({
    required super.message,
  });

  ContactFailure.fromException(ContactException e)
      : this(
          message: e.message,
        );

  @override
  List<Object?> get props => [message];
}

class WebSocketFailure extends Failure {
  const WebSocketFailure({
    required super.message,
  });

  WebSocketFailure.fromException(WebSocketException e)
      : this(
          message: e.message,
        );

  @override
  List<Object?> get props => [message];
}
