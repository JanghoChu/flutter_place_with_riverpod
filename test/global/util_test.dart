import 'dart:convert';

import 'package:flutter_place_with_riverpod/global/util.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  String dateTime = '2022-12-12 01:11:12';
  String date = '2022-12-12';

  Util util = Util();

  group('util_test', () {
    setUp(() async {});

    test('formatToDate', () async {
      final actual = util.formatToDate(DateTime.parse(date));
      expect(actual, date);
    });

    test('formatToDateTime', () async {
      final actual = util.formatToDateTime(DateTime.parse(dateTime));
      expect(actual, dateTime);
    });

    group('toDouble', () {
      test('when amount is null', () async {
        final actual = util.toDouble(null);

        expect(actual, 0.0);
      });

      test('when amount is int type', () async {
        const int intAmount = 1;

        final actual = util.toDouble(intAmount);

        expect(actual.runtimeType, double);
        expect(actual, intAmount.toDouble());
      });

      test('when amount is NOT null & is NOT int type', () async {
        const double doubleAmount = 1.0;

        final actual = util.toDouble(doubleAmount);

        expect(actual.runtimeType, double);
        expect(actual, doubleAmount);
      });
    });

    group('truncateString', () {
      test('truncate when text is longer than length of front & end', () async {
        const String text = '0xabcdefghijklmnopqrstuvwxyz';
        const int front = 8;
        const int end = 6;

        final actual = util.truncateString(text, front, end);

        expect(actual, '0xabcdef...uvwxyz');
      });

      test('NOT truncate when text is shorter than length of front & end',
          () async {
        const String text = '0xabcdefghijkl';
        const int front = 8;
        const int end = 6;

        final actual = util.truncateString(text, front, end);

        expect(actual, '0xabcdefghijkl');
      });
    });

    group('isValidAddress', () {
      test('is valid as lowercase', () async {
        const String validAddress =
            '0x3bff4704528f437836fe410bc1f5e7092bda3332';

        final actual = util.isValidAddress(validAddress);

        expect(actual, isTrue);
      });

      test('is valid as uppercase', () async {
        const String validAddress =
            '0xaBd24536b4871678519F0Ec6975CB0ED0E41855F';

        final actual = util.isValidAddress(validAddress);

        expect(actual, isTrue);
      });

      test('is invalid', () async {
        const String inValidAddress = 'invalidAddress';

        final actual = util.isValidAddress(inValidAddress);

        expect(actual, isFalse);
      });

      test('is invalid with range', () async {
        const String inValidAddress =
            '0xaGG24536b4871678519F0Ec6975CB0ED0E418551';

        final actual = util.isValidAddress(inValidAddress);

        expect(actual, isFalse);
      });
    });
  });
}
