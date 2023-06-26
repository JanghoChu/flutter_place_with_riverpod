import 'dart:math';

class Util {
  static const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static Random rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => chars.codeUnitAt(
            rnd.nextInt(chars.length),
          ),
        ),
      );

  double toDouble(dynamic amount) {
    double tmpAmount = 0.0;
    if (amount == null) {
      return tmpAmount;
    } else if (amount is int) {
      tmpAmount = (amount).toDouble();
    } else {
      tmpAmount = amount;
    }
    return tmpAmount;
  }

  String formatToDateTime(DateTime dateTime) =>
      dateTime.toString().split('.')[0];

  String formatToDate(DateTime dateTime) => dateTime.toString().split(' ')[0];

  String truncateString(String text, int front, int end) {
    final int size = front + end;

    if (text.length > size) {
      return '${text.substring(0, front)}...${text.substring(text.length - end)}';
    }

    return text;
  }

  bool isValidAddress(String address) {
    final regex = RegExp(r'^0x[0-9a-fA-F]{40}$');

    return address.contains(regex);
  }
}
