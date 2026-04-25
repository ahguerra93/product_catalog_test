import 'package:flutter/material.dart';

class CustomClickable extends StatelessWidget {
  const CustomClickable({super.key, required this.child, this.onTap});
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(child: InkWell(onTap: onTap)),
      ],
    );
  }
}
