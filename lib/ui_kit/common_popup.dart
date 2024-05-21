import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../index.dart';

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
      id: 'errorDialog_$message',
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

  // ignore: prefer_named_parameters
  static CommonPopup confirmDialog(
    String title, {
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return CommonPopup._(
      id: 'confirmDialog_$title',
      builder: (context, navigator) => AlertDialog.adaptive(
        title: CommonText(
          title,
          style: ts(
            color: cl.black,
            fontSize: 14.rps,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              navigator.pop(result: false);
              onCancel?.call();
            },
            child: CommonText(l10n.cancel, style: null),
          ),
          TextButton(
            onPressed: () {
              navigator.pop(result: true);
              onConfirm?.call();
            },
            child: CommonText(l10n.ok, style: null),
          ),
        ],
      ),
    );
  }

  static CommonPopup simpleDialog({
    required List<Widget> children,
    String? title,
  }) {
    return CommonPopup._(
      id: 'simpleDialog_$title',
      builder: (context, navigator) => AlertDialog.adaptive(
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(children.length * 2 - 1, (index) {
            return index % 2 == 0 ? children[index ~/ 2] : const CommonDivider();
          }),
        ),
      ),
    );
  }

  static Widget simpleSelection({
    required String title,
    required VoidCallback onTap,
  }) {
    return CommonContainer(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      onTap: onTap,
      child: CommonText(
        title,
        style: ts(
          color: cl.black,
          fontSize: 14.rps,
        ),
      ),
    );
  }

  static CommonPopup errorWithRetryDialog({
    required String message,
    required VoidCallback? onRetryPressed,
  }) {
    return CommonPopup._(
      id: 'errorDialog_$message',
      builder: (context, navigator) => AlertDialog.adaptive(
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: CommonText(
              l10n.cancel,
              style: null,
            ),
          ),
          if (onRetryPressed != null)
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

  static CommonPopup requiredLoginDialog() {
    return CommonPopup._(
      id: 'requiredLoginDialog',
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
            onPressed: () async {
              await navigator.replaceAll([const LoginRoute()]);
            },
            child: CommonText(
              l10n.ok,
              style: null,
            ),
          ),
        ],
        content: CommonText(
          l10n.requiresRecentLogin,
          style: null,
        ),
      ),
    );
  }

  static CommonPopup forceLogout(
    String message,
  ) {
    return CommonPopup._(
      id: 'forceLogout$message',
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

  static CommonPopup changeImageOptionsBottomSheet() {
    return CommonPopup._(
      id: 'changeImageOptionsBottomSheet',
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
      id: 'successSnackBar_$message',
      builder: (context, navigator) => SnackBar(
        content: CommonText(
          message,
          style: null,
        ),
        duration: Constant.snackBarDuration,
        backgroundColor: cl.green1,
      ),
    );
  }

  static CommonPopup errorSnackBar(String message) {
    return CommonPopup._(
      id: 'errorSnackBar_$message',
      builder: (context, navigator) => SnackBar(
        content: CommonText(
          message,
          style: null,
        ),
        duration: Constant.snackBarDuration,
        backgroundColor: cl.red1,
      ),
    );
  }

  static CommonPopup yesNoDialog({
    required String message,
    required VoidCallback? onPressed,
  }) {
    return CommonPopup._(
      id: 'yesNoDialog_$message',
      builder: (context, navigator) => AlertDialog.adaptive(
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: CommonText(
              l10n.no,
              style: null,
            ),
          ),
          if (onPressed != null)
            TextButton(
              onPressed: () {
                navigator.pop();
                onPressed.call();
              },
              child: CommonText(
                l10n.yes,
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

  static CommonPopup renameConversationDialog({
    required String email,
    required Function(String nameChanged) onSubmit,
  }) {
    return CommonPopup._(
      id: 'renameConversationDialog_$email',
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
                      style: ts(
                        color: cl.black,
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
