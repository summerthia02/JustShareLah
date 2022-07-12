import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String timeDisplayed(Timestamp timeListed) {
  DateTime currTime = DateTime.now();
  final diffTime = currTime.difference(timeListed.toDate());
  dynamic listedTimeAgo = currTime.subtract(diffTime);
  String result = timeago.format(listedTimeAgo).toString();
  return result;
}

// convert to readable date and time
String convertedTime(Timestamp timeListed) {
  return DateFormat('MMM d, h:mm a').format(timeListed.toDate());
}
