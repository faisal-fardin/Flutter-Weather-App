
import 'package:intl/intl.dart';

String getFormattedDateTime( num dt, {String patten = 'MMM dd yyyy'}) =>
    DateFormat(patten).format(DateTime.fromMillisecondsSinceEpoch(dt.toInt() * 1000));