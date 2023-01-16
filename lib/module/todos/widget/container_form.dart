import 'package:flutter/material.dart';
import 'package:todo_app/state_util.dart';

class ContainerForm {
  static text({
    required String hintText,
    required IconData icon,
    TextEditingController? controller,
    Color? color,
    int? maxLines = 1,
    String? label,
  }) {
    return TextFormField(
      controller: controller,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: color),
        hintText: hintText,
        label: label != null
            ? Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  static button({
    required String label,
    required void Function()? onPressed,
    Color backgroundColor = Colors.indigo,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        fixedSize: Size(Get.width / 3, 50),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
