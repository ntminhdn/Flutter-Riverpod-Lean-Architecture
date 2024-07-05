import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

@RoutePage(name: 'MyPageRoute')
class MyPagePage extends BasePage<MyPageState,
    AutoDisposeStateNotifierProvider<MyPageViewModel, CommonState<MyPageState>>> {
  const MyPagePage({super.key});

  @override
  AutoDisposeStateNotifierProvider<MyPageViewModel, CommonState<MyPageState>> get provider =>
      myPageViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final email = ref.watch(currentUserProvider.select((value) => value.email));

    return CommonScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 16.rps,
                left: 16.rps,
                right: 16.rps,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final isVipMember =
                            ref.watch(currentUserProvider.select((value) => value.isVip));

                        return Row(
                          children: [
                            AvatarView(text: email),
                            SizedBox(width: 16.rps),
                            Flexible(
                              child: CommonText(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20.rps,
                                  fontWeight: FontWeight.w500,
                                  color: color.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.rps),
                            Visibility(
                              visible: isVipMember,
                              child: Icon(
                                Icons.local_police,
                                size: 20.rps,
                                color: color.green1,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: CommonText(
                l10n.home,
                style: TextStyle(
                  color: color.black,
                  fontSize: 14.rps,
                ),
              ),
              onTap: () {
                ref.read(appNavigatorProvider).push(HomeRoute());
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: CommonText(
                l10n.settings,
                style: TextStyle(
                  color: color.black,
                  fontSize: 14.rps,
                ),
              ),
              onTap: () {
                ref.read(appNavigatorProvider).push(const SettingRoute());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: CommonText(
                l10n.logout,
                style: TextStyle(
                  color: color.black,
                  fontSize: 14.rps,
                ),
              ),
              onTap: () {
                ref.read(appNavigatorProvider).showDialog(CommonPopup.yesNoDialog(
                      message: l10n.logoutConfirm,
                      onPressed: () => ref.read(provider.notifier).logout(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: CommonText(
                l10n.deleteAccount,
                style: TextStyle(
                  color: color.black,
                  fontSize: 14.rps,
                ),
              ),
              onTap: () {
                ref.read(appNavigatorProvider).showDialog(CommonPopup.yesNoDialog(
                      message: l10n.deleteAccountConfirm,
                      onPressed: () {
                        ref.read(provider.notifier).deleteAccount();
                      },
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
