import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  @override
  String toString() => "$statusCode, Error: $message";
  @override
  List<Object?> get props => [message, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});

  ApiFailure.fromException(ApiException failure)
      : super(message: failure.message, statusCode: failure.statusCode);

  @override
  List<Object?> get props => [message, statusCode];
}
