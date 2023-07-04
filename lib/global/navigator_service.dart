import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorSerivce {
  static final NavigatorSerivce _instance = NavigatorSerivce._internal();

  late final GlobalKey<NavigatorState> navigatorKey;

  factory NavigatorSerivce() => _instance;

  NavigatorSerivce._internal() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  BuildContext context() {
    if (navigatorKey.currentContext == null) {
      throw ('Null Context Exception');
    }
    return navigatorKey.currentContext!;
  }

  Future<dynamic> push(Widget widget) async =>
      await navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (ctx) => widget),
      );

  showDialog({
    String title = 'Alert',
    String body = 'Proceed with destructive action?',
  }) {
    showCupertinoModalPopup<void>(
      context: context(),
      builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Alert'),
          content: const Text('Proceed with destructive action?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Yes'),
            ),
          ]),
    );
  }
}
