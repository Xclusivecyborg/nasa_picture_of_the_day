import 'package:intl/intl.dart';

extension DateExtension on String {
  String get toNiceDate {
    final date = DateFormat('dd MMM yy').format(toDateTime);
    return date;
  }

  String get toNiceFullDate {
    final date = DateFormat('dd MMMM yyyy').format(toDateTime);
    return date;
  }

  DateTime get toDateTime => DateTime.parse(this).toUtc().toLocal();

  String get getYMD {
    return split('T').first;
  }
}
