import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

extension EitherX<L, R> on Either<L, R> {
  R asRight() => (this as Right).value; //
  L asLeft() => (this as Left).value;
}

extension TimeFormatter on DateTime {
  String timeFormat() {
    String hours = "";
    switch (hour) {
      case 0:
        hours = "12";
        break;
      case 12:
        hours = "12";
        break;
      case int n when n < 10:
        hours = "0$hour";
        break;
      case int n when n > 12:
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
  String dateFormat() =>
      "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year";

  String toSqfliteFormat() {
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(this);
  }

  static DateTime fromSqfliteFormat(String dateTime) {
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.parse(dateTime);
  }
}
