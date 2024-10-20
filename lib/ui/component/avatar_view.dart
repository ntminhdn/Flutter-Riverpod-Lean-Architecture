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

    return CommonContainer(
      height: height,
      width: width,
      color: backgroundColor ?? color.black,
      border: SolidBorder.allRadius(radius: width / 2),
      child: Stack(
        children: [
          Center(
            child: CommonText(
              text.trim().firstOrNull?.toUpperCase(),
              style: textStyle ??
                  style(
                    fontSize: 24.rps,
                    fontWeight: FontWeight.w700,
                    color: color.white,
                  ),
            ),
          ),
          Visibility(
            visible: isActive,
            child: Align(
              alignment: Alignment.bottomRight,
              child: CommonContainer(
                width: 14.rps,
                height: 14.rps,
                color: color.green1,
                border: SolidBorder.allRadius(radius: 7.rps, borderColor: color.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
