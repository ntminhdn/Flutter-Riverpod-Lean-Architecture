import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../index.dart';

class PrimaryTextField extends HookWidget {
  const PrimaryTextField({
    required this.title,
    required this.hintText,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  final String title;
  final String hintText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final _obscureText = useState(true);
    final isPassword = keyboardType == TextInputType.visiblePassword;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CommonText(
            title,
            style: ts(
              fontSize: 14.rps,
              color: color.black,
            ),
          ),
        ),
        TextField(
          onChanged: onChanged,
          controller: controller,
          style: ts(
            fontSize: 14.rps,
            color: color.black,
          ),
          decoration: InputDecoration(
            hintStyle: ts(
              fontSize: 14.rps,
              color: color.grey1,
            ),
            hintText: hintText,
            suffixIcon: isPassword
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _obscureText.value = !_obscureText.value,
                    child: _obscureText.value
                        ? CommonImage.iconData(iconData: Icons.visibility_off)
                        : CommonImage.iconData(iconData: Icons.visibility),
                  )
                : suffixIcon,
          ),
          keyboardType: keyboardType,
          obscureText: isPassword ? _obscureText.value : false,
        ),
      ],
    );
  }
}
