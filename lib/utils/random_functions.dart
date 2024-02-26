import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:jiffy/jiffy.dart';
import 'package:platterwave/utils/working_days_parser.dart';

class RandomFunction {
  static toast(String msg, {bool isError = false}) {
    var cancel = BotToast.showSimpleNotification(
      title: msg,
    );
  }

  static String generateRandomStringWithRepetition() {
    const String characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    Random random = Random();
    String result = '';

    for (int i = 0; i < 10; i++) {
      int randomIndex = random.nextInt(characters.length);
      result += characters[randomIndex];
    }

    return result + DateTime.now().millisecondsSinceEpoch.toString();
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

  static Color reserveColor(int e) {
    if (e == 1) {
      return Colors.yellow[700]!;
    } else if (e == 2) {
      return Colors.blue;
    } else if (e == 0) {
      return Colors.red;
    } else if (e == 4) {
      return Colors.green;
    } else if (e == 3) {
      return Colors.orange;
    } else {
      return Colors.orange[900]!;
    }
  }

  static String reserveString(int e) {
    if (e == 1) {
      return 'Reservation pending';
    } else if (e == 2) {
      return "Reservation Accepted";
    } else if (e == 0) {
      return "Reservation Cancelled";
    } else if (e == 4) {
      return "Dining Completed";
    } else if (e == 3) {
      return "Reservation in progress";
    } else {
      return "Bill sent";
    }
  }

  static num getPercentage(num part, num whole) {
    return (part / whole) * 100;
  }

  static num getValueOfPercentage(num whole, num percent) {
    return (whole * percent) / 100;
  }

  static Future<DateTime?> showDateTimePicker(
      {required BuildContext context,
      DateTime? initialDate,
      DateTime? firstDate,
      DateTime? lastDate,
      required String workingDays,
      required String openingTime,
      required String closingTime}) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    print("These are the working days $workingDays");
    final days = WorkingDaysParser.getDaysOfWeek(workingDays);
    if (selectedDate == null ||
        selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      return null;
    }
    if (!days.contains(selectedDate.weekday)) {
      toast("Wrong Working Day selected");
      return null;
    }
    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    var openingHour = convertStringToTimeOfDay(openingTime);
    var closingHour = convertStringToTimeOfDay(closingTime);

    if (selectedTime!.period == DayPeriod.pm) {
      if (selectedTime.hour > closingHour!.hour + 12) {
        toast("Wrong Working Time selected");
        return null;
      }
    } else {
      if (selectedTime.hour < openingHour!.hour) {
        toast("Wrong Working Time selected");
        return null;
      }
    }

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

TimeOfDay? convertStringToTimeOfDay(String timeString) {
  List<String> parts = timeString.split(':');

  // Ensure that the string has three parts (hours, minutes, seconds)
  if (parts.length == 3) {
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    return TimeOfDay(hour: hours, minute: minutes);
  }
  return null;
}
