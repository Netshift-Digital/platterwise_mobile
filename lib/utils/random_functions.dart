import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
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
    if (_isTimeInPast(selectedTime!, selectedDate)) {
      toast("Past time selected");
      return null;
    }
    if (openingTime.contains("AM") && closingTime.contains("PM")) {
      if (!_isTimeWithinRange(selectedTime, openingTime, closingTime)) {
        toast("Wrong working time selected");
        return null;
      } else {
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
    } else {
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

  static bool isAfter(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour > time2.hour) {
      return true;
    } else if (time1.hour < time2.hour) {
      return false;
    } else {
      return time1.minute > time2.minute;
    }
  }

  static bool isBefore(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) {
      return true;
    } else if (time1.hour > time2.hour) {
      return false;
    } else {
      return time1.minute < time2.minute;
    }
  }

  static bool _isTimeWithinRange(
      TimeOfDay? time, String openingTime, String closingTime) {
    int pickedHour = time!.hour;
    int pickedMinute = time.minute;
    var openingHour = TimeOfDay(hour: 1, minute: 00);
    var closingHour = TimeOfDay(hour: 24, minute: 00);

    openingHour = convertStringToTimeOfDay(openingTime);
    closingHour = convertStringToTimeOfDay24(closingTime);
    // if (openingTime.contains("PM") && closingTime.contains("AM")) {
    //   openingHour = convertStringToTimeOfDay(openingTime);
    //  closingHour = convertStringToTimeOfDay24(closingTime);
    //}

    final TimeOfDay pickedTime = TimeOfDay(
      hour: pickedHour,
      minute: pickedMinute,
    );

    return isAfter(pickedTime, openingHour) &&
        isBefore(pickedTime, closingHour);
  }

  static TimeOfDay convertStringToTimeOfDay24(String timeString) {
    var res = parseTimeString(timeString);
    List<String> parts = res.replaceAll(":", ' ').split(' ');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    hours += 12;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static TimeOfDay convertStringToTimeOfDay(String timeString) {
    var res = parseTimeString(timeString);
    List<String> parts = res.replaceAll(":", ' ').split(' ');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    return TimeOfDay(hour: hours, minute: minutes);
  }

  static String parseTimeString(String dateTimeString) {
    DateFormat inputFormat = DateFormat("h:mm:ssaZZZ");
    DateTime dateTime = inputFormat.parse(dateTimeString);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  static bool _isTimeInPast(TimeOfDay time, DateTime selectedDate) {
    final DateTime now = DateTime.now();
    final DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      time.hour,
      time.minute,
    );

    return selectedDateTime.isBefore(now);
  }
}
