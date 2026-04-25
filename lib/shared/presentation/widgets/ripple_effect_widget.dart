import 'package:flutter/material.dart';

class CustomClickable extends StatelessWidget {
  const CustomClickable({super.key, required this.child, this.onTap, this.borderRadius});
  final Widget child;
  final void Function()? onTap;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              radius: borderRadius,
              borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
