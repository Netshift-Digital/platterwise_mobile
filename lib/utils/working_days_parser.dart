class WorkingDaysParser {
  static final Map<String, int> dayMap = {
    'mon': 1,
    'tue': 2,
    'wed': 3,
    'thu': 4,
    'fri': 5,
    'sat': 6,
    'sun': 7,
  };

  static List<int> getDaysOfWeek(String workingDaysString) {
    final List<String> workingDaysList = workingDaysString.split(' - ');

    final start = dayMap[workingDaysList[0].toLowerCase()];
    final end = dayMap[workingDaysList[1].toLowerCase()];
    List<int> result = [];

    if (start! <= end!) {
      for (int i = start; i <= end; i++) {
        print(i);
        result.add(i);
      }
    }
    print("This is the end");
    return result;
  }
}
