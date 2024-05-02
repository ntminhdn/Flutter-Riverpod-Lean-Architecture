import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../index.dart';

class CommonText extends StatelessWidget {
  // ignore: prefer_named_parameters
  const CommonText(
    this.text, {
    required this.style,
    super.key,
    this.onTap,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.enableLinkify = false,
    this.onOpenLink,
  });

  final String? text;
  final VoidCallback? onTap;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool enableLinkify;
  final void Function(String)? onOpenLink;

  @override
  Widget build(BuildContext context) {
    final textWidget = enableLinkify
        ? Linkify(
            text: text ?? (kDebugMode ? 'nil' : ''),
            style: style,
            maxLines: maxLines,
            overflow: overflow ?? TextOverflow.clip,
            textAlign: textAlign ?? TextAlign.start,
            onOpen: (link) => onOpenLink,
            options: const LinkifyOptions(looseUrl: true),
          )
        // ignore: prefer_common_widgets
        : Text(
            text ?? 'nil',
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          );

    return onTap != null
        ? CommonInkWell(
            onTap: onTap,
            child: textWidget,
          )
        : textWidget;
  }
}
