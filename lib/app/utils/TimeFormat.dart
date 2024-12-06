import 'package:intl/intl.dart';

String get24HourFormat(time12Hour) {
  // Parse the 12-hour format time into a DateTime object
  DateFormat inputFormat = DateFormat("h:mm a");
  DateTime dateTime = inputFormat.parse(time12Hour);

  // Format the DateTime object into a 24-hour format string
  DateFormat outputFormat = DateFormat("HH:mm");
  String time24Hour = outputFormat.format(dateTime);

  return time24Hour;
}
