import 'package:flutter/material.dart';

class BottomModalContainer extends StatelessWidget {
  final List<Widget> children;
  const BottomModalContainer({Key? key, required this.children}) : super(key: key);

  Widget get devider => Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.indigo,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
        left: 25,
        right: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(child: devider),
          ...children,
        ],
      ),
    );
  }
}
