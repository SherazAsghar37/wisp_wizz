import 'package:equatable/equatable.dart';

class CustomExceptions extends Equatable implements Exception {
  final String message;
  final int statusCode;

  const CustomExceptions({required this.message, required this.statusCode});
  @override
  List<Object?> get props => [message, statusCode];
}

class ApiException extends CustomExceptions {
  const ApiException({required super.message, required super.statusCode});
}
