import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart' as p;

import '../../index.dart';

class MoreMenuIconButton extends StatelessWidget {
  MoreMenuIconButton({
    required this.onCopy,
    required this.onReply,
    super.key,
  });

  final VoidCallBack onCopy;
  final VoidCallBack onReply;

  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: _globalKey,
      onPressed: () {
        _showPopupMenu(context);
      },
      icon: Icon(
        Icons.more_horiz,
        color: color.grey1,
      ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    final copy = l10n.copy;
    final reply = l10n.reply;
    final menu = p.PopupMenu(
      context: context,
      config: p.MenuConfig(
        backgroundColor: color.black,
        lineColor: color.white,
        type: p.MenuType.list,
        itemWidth: 150,
      ),
      items: [
        p.MenuItem(
          title: copy,
          image: Icon(
            Icons.copy,
            color: color.white,
          ),
          textStyle: TextStyle(color: color.white, fontSize: 12),
        ),
        p.MenuItem(
          title: reply,
          image: Icon(
            Icons.reply,
            color: color.white,
          ),
          textStyle: TextStyle(color: color.white, fontSize: 12),
        ),
      ],
      onClickMenu: (item) {
        if (item.menuTitle == copy) {
          onCopy();
        } else if (item.menuTitle == reply) {
          onReply();
        }
      },
    );

    menu.show(widgetKey: _globalKey);
  }
}
