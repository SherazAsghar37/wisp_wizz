import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R asRight() => (this as Right).value; //
  L asLeft() => (this as Left).value;
}

extension TimeFormatter on DateTime {
  String timeFormat() => "$hour:$minute ${(hour < 12) ? 'AM' : 'PM'}";
}

extension DateFormatter on DateTime {
  String dateFormat() => "$day-$month-$year";
}
