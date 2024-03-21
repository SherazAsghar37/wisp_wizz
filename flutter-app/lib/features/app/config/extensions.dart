import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R asRight() => (this as Right).value; //
  L asLeft() => (this as Left).value;
}

extension TimeFormatter on DateTime {
  String timeFormat() {
    String hours = "";
    switch (hour) {
      case == 0:
        hours = "12";
        break;
      case < 10:
        hours = "0$hour";
        break;
      case > 12:
        hours = (hour % 12).toString();
        break;
      default:
        hours = hour.toString();
    }
    final String minutes = minute < 10 ? "0$minute" : minute.toString();
    return "$hours:$minutes ${(hour < 12) ? 'AM' : 'PM'}";
  }
}

extension DateFormatter on DateTime {
  String dateFormat() => "$day-$month-$year";
}
