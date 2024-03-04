import 'package:flutter/material.dart';

import '../../index.dart';

class PrimaryCheckBox extends StatelessWidget {
  const PrimaryCheckBox({
    this.text,
    this.initValue = false,
    this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  final ValueChanged<bool>? onChanged;
  final bool initValue;
  final bool isEnabled;
  final Widget? text;

  @override
  Widget build(BuildContext context) {
    bool _checked = initValue;

    return StatefulBuilder(builder: (_, setState) {
      return CommonInkWell(
        onTap: isEnabled
            ? null
            : () {
                setState(() {
                  _checked = !_checked;
                  onChanged?.call(_checked);
                });
              },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            if (text != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 33.rps),
                  child: text!,
                ),
              ),
            SizedBox(
              width: 36.rps,
              height: 36.rps,
              child: Checkbox(
                checkColor: cl.white,
                activeColor: cl.black,
                value: _checked,
                onChanged: isEnabled
                    ? (value) {
                        onChanged?.call(value ?? false);
                        setState(() {
                          _checked = !_checked;
                        });
                      }
                    : null,
              ),
            ),
          ],
        ),
      );
    });
  }
}
