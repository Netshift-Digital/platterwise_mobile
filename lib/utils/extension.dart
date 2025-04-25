import 'package:currency_formatter/currency_formatter.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalizeFirstChar() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  // String toCurrency({String sign = "₦"}) {
  //   CurrencyFormatter cf = CurrencyFormatter();
  //   CurrencyFormatterSettings nairaSettings = CurrencyFormatterSettings(
  //     symbol: "N",
  //     symbolSide: SymbolSide.left,
  //     thousandSeparator: ',',
  //     decimalSeparator: '.',
  //   );
  //   String formatted = cf.format(double.parse(this), nairaSettings);
  //   return formatted;
  // }

  String toCurrency({String sign = "₦"}) {
    final format = NumberFormat.currency(
      symbol: sign,
      decimalDigits: 2,
      locale: 'en_NG', // Nigerian locale
    );
    return format.format(double.parse(this));
  }

  String replaceMoney() {
    return replaceAll(",", "")
        .replaceAll("NGN", "")
        .replaceAll("N", "")
        .replaceAll("\$", "")
        .replaceAll("₦", "");
  }
}
