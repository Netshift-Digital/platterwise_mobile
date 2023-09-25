import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:jiffy/jiffy.dart';

class RandomFunction {
  static toast(String msg, {bool isError = false}) {
    var cancel = BotToast.showSimpleNotification(
      title: msg,
    );
  }

  static String greetingMessage() {
    var timeNow = DateTime.now().hour;
    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  static Jiffy date(String date) {
    var d = DateTime.tryParse(date) ?? DateTime.now();
    return Jiffy({
      "year": d.year,
      "month": d.month,
      "day": d.day,
      "hour": d.hour,
      "minute": d.minute
    });
  }

  static sheet(BuildContext context, Widget body, {double? height}) {
    var size = MediaQuery.of(context).size;
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: height ?? size.height - 120,
            width: size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: body,
          );
        });
  }

  static String timeAgo(String date) {
    var d = DateTime.parse(date);
    var result = GetTimeAgo.parse(d);
    return result;
  }

  static Color reserveColor(String e) {
    if (e.contains('pend')) {
      return Colors.yellow[700]!;
    } else if (e.contains('accep')) {
      return Colors.blue;
    } else if (e.contains('can')) {
      return Colors.red;
    } else if (e.contains('com')) {
      return Colors.green;
    } else if (e.contains('split')) {
      return Colors.orange[900]!;
    } else {
      return Colors.orange;
    }
  }

  static String reserveString(String e) {
    if (e.contains('pend')) {
      return 'Reservation pending';
    } else if (e.contains('accep')) {
      return "Reservation Accepted";
    } else if (e.contains('can')) {
      return "Reservation Cancelled";
    } else if (e.contains('com')) {
      return "Dining Completed";
    } else if (e.contains('split')) {
      return "Bill splitted";
    } else {
      return "Reservation in progress";
    }
  }

  static num getPercentage(num part, num whole) {
    return (part / whole) * 100;
  }

  static num getValueOfPercentage(num whole, num percent) {
    return (whole * percent) / 100;
  }

  static Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null || selectedDate.isBefore(DateTime.now())) {
      return null;
    }
    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
