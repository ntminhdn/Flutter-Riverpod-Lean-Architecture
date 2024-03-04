import 'package:flutter/material.dart';

import '../../index.dart';

class AvatarView extends StatelessWidget {
  const AvatarView({
    required this.text,
    this.textStyle,
    this.isActive = false,
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
  });

  final String text;
  final double? width;
  final double? height;
  final bool isActive;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final width = this.width ?? 60.rps;
    final height = this.height ?? 60.rps;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? cl.black,
        borderRadius: BorderRadius.circular(width / 2),
      ),
      child: Stack(
        children: [
          Center(
            child: CommonText(
              text.trim().firstOrNull?.toUpperCase(),
              style: textStyle ??
                  ts(
                    fontSize: 24.rps,
                    fontWeight: FontWeight.w700,
                    color: cl.white,
                  ),
            ),
          ),
          Visibility(
            visible: isActive,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 14.rps,
                height: 14.rps,
                decoration: BoxDecoration(
                  color: cl.green1,
                  borderRadius: BorderRadius.circular(7.rps),
                  border: Border.all(color: cl.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
