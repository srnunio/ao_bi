import 'package:flutter/material.dart';

class SheetContainer extends StatelessWidget {
  const SheetContainer(
      {Key? key,
      required this.child,
      this.width,
      this.height = 240,
      this.duration,
      this.borderRadius = 8.0,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      this.backgroundColor = Colors.white})
      : super(key: key);

  final Widget child;
  final double? width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Duration? duration;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            )),
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        duration: duration ?? const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: child,
      );
}
