import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/state_util.dart';

class Alert {
  final String message;
  final bool status;
  final context = Get.currentContext as BuildContext;

  Alert({required this.message, required this.status});

  show({void Function()? callback}) {
    Color? failure = Colors.red[500];
    Color? success = Colors.indigo[500];
    Flushbar(
      messageText: Text(
        message.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      icon: Icon(
        status ? Icons.thumb_up : Icons.info_outline,
        size: 28.0,
        color: status ? success : failure,
      ),
      duration: const Duration(milliseconds: 1500),
      onTap: (flushbar) => flushbar.dismiss(),
      leftBarIndicatorColor: status ? success : failure,
    ).show(context).then((_) => callback != null ? callback() : null);
  }
}
