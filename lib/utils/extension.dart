

extension StringExtension on String {

  String capitalizeFirstChar() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}



