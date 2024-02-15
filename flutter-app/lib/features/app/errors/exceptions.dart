import 'package:equatable/equatable.dart';

class CustomExceptions extends Equatable implements Exception {
  final String message;

  const CustomExceptions({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}

class ApiException extends CustomExceptions {
  final int statusCode;
  const ApiException({required super.message, required this.statusCode});
  @override
  List<Object?> get props => [message, statusCode];
}

class CacheException extends CustomExceptions {
  const CacheException({required super.message});
  @override
  List<Object?> get props => [message];
}

class ContactException extends CustomExceptions {
  const ContactException({required super.message});
  @override
  List<Object?> get props => [message];
}
