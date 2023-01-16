import 'package:flutter/material.dart';
import 'package:todo_app/state_util.dart';
import 'bottom_modal_container.dart';

bottomSheetShow({required List<Widget> children}) {
  showModalBottomSheet(
    context: Get.currentContext,
    elevation: 5,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) => BottomModalContainer(children: children),
  );
}
