import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../index.dart';

class CommonPopup {
  const CommonPopup._({
    required this.builder,
    required this.id,
  });

  final String id;
  final Widget Function(BuildContext, AppNavigator) builder;

  @override
  String toString() {
    return id;
  }

  static CommonPopup errorDialog(
    String message,
  ) {
    return CommonPopup._(
      id: 'errorDialog_$message'.hardcoded,
      builder: (context, navigator) => AlertDialog.adaptive(
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: CommonText(
              l10n.ok,
              style: null,
            ),
          ),
        ],
        content: CommonText(
          message,
          style: null,
        ),
      ),
    );
  }

  static CommonPopup confirmDialog({
    required String message,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? confirmButtonText,
    String? cancelButtonText,
  }) {
    return CommonPopup._(
      id: 'confirmDialog_$message'.hardcoded,
      builder: (context, navigator) => AlertDialog.adaptive(
        title: CommonText(
          message,
          style: style(
            color: color.black,
            fontSize: 14.rps,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              navigator.pop(result: false);
              onCancel?.call();
            },
            child: CommonText(cancelButtonText ?? l10n.cancel, style: null),
          ),
          TextButton(
            onPressed: () {
              navigator.pop(result: true);
              onConfirm?.call();
            },
            child: CommonText(confirmButtonText ?? l10n.ok, style: null),
          ),
        ],
      ),
    );
  }

  static CommonPopup errorWithRetryDialog({
    required String message,
    required VoidCallback onRetryPressed,
  }) {
    return CommonPopup._(
      id: 'errorWithRetryDialog_$message'.hardcoded,
      builder: (context, navigator) => AlertDialog.adaptive(
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: CommonText(
              l10n.cancel,
              style: null,
            ),
          ),
          TextButton(
            onPressed: () {
              navigator.pop();
              onRetryPressed.call();
            },
            child: CommonText(
              l10n.retry,
              style: null,
            ),
          ),
        ],
        content: CommonText(
          message,
          style: null,
        ),
      ),
    );
  }

  static CommonPopup infoDialog(
    String message,
  ) {
    return CommonPopup._(
      id: 'infoDialog_$message'.hardcoded,
      builder: (context, navigator) => AlertDialog.adaptive(
        actions: [
          TextButton(
            onPressed: () {
              navigator.pop();
            },
            child: CommonText(
              l10n.ok,
              style: null,
            ),
          ),
        ],
        content: CommonText(
          message,
          style: null,
        ),
      ),
    );
  }

  static CommonPopup maintenanceModeDialog({
    required String message,
    required String time,
  }) {
    return CommonPopup._(
      id: 'maintenanceModeDialog_$message'.hardcoded,
      // ignore: prefer_common_widgets
      builder: (context, navigator) => Scaffold(
        body: CommonContainer(
          color: color.white,
          padding: EdgeInsets.all(24.rps),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: CommonImage.svg(
                  path: image.appLogo,
                  width: 128.rps,
                  height: 128.rps,
                ),
              ),
              SizedBox(height: 32.rps),
              CommonText(
                l10n.maintenanceTitle,
                style: style(
                  height: 1.18,
                  color: color.black,
                  fontSize: 16.rps,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.rps),
              CommonContainer(
                color: color.white,
                border: SolidBorder.allRadius(radius: 10.rps, borderColor: color.grey1),
                padding: EdgeInsets.all(12.rps),
                child: CommonText(
                  message,
                  style: style(
                    height: 1.5,
                    color: color.black,
                    fontSize: 14.rps,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Visibility(
                visible: time.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16.rps),
                    CommonText(
                      l10n.maintenanceTimeTitle,
                      style: style(
                        height: 1.18,
                        color: color.black,
                        fontSize: 16.rps,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.rps),
                    CommonContainer(
                      color: color.white,
                      border: SolidBorder.allRadius(radius: 10.rps, borderColor: color.grey1),
                      padding: EdgeInsets.all(12.rps),
                      child: CommonText(
                        time,
                        style: style(
                          height: 1.5,
                          color: color.black,
                          fontSize: 14.rps,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static CommonPopup changeImageOptionsBottomSheet() {
    return CommonPopup._(
      id: 'changeImageOptionsBottomSheet'.hardcoded,
      builder: (context, navigator) => CupertinoAlertDialog(
        actions: [
          CupertinoDialogAction(
            onPressed: () => navigator.pop(),
            child: CommonText(
              l10n.ok,
              style: null,
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => navigator.pop(),
            child: CommonText(
              l10n.cancel,
              style: null,
            ),
          ),
        ],
      ),
    );
  }

  static CommonPopup successSnackBar(String message) {
    return CommonPopup._(
      id: 'successSnackBar_$message'.hardcoded,
      builder: (context, navigator) => SnackBar(
        content: CommonText(
          message,
          style: null,
        ),
        duration: Constant.snackBarDuration,
        backgroundColor: color.green1,
      ),
    );
  }

  static CommonPopup errorSnackBar(String message) {
    return CommonPopup._(
      id: 'errorSnackBar_$message'.hardcoded,
      builder: (context, navigator) => SnackBar(
        content: CommonText(
          message,
          style: null,
        ),
        duration: Constant.snackBarDuration,
        backgroundColor: color.red1,
      ),
    );
  }

  static CommonPopup renameConversationDialog({
    required String email,
    required Function(String nameChanged) onSubmit,
  }) {
    return CommonPopup._(
      id: 'renameConversationDialog_$email'.hardcoded,
      builder: (context, navigator) {
        String nickname = '';

        return Dialog(
          child: StatefulBuilder(
            builder: (context, setState) {
              return CommonContainer(
                padding: EdgeInsets.symmetric(horizontal: 16.rps, vertical: 32.rps),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      l10n.rename,
                      style: style(
                        color: color.black,
                        fontSize: 18.rps,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.rps),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          nickname = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: email,
                      ),
                    ),
                    SizedBox(height: 32.rps),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => navigator.pop(),
                            child: CommonText(
                              l10n.cancel,
                              style: null,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.rps),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              navigator.pop();
                              onSubmit(nickname);
                            },
                            child: CommonText(
                              l10n.ok,
                              style: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
