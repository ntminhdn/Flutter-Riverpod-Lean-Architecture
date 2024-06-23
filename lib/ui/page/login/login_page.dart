import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

@RoutePage()
class LoginPage extends BasePage<LoginState,
    AutoDisposeStateNotifierProvider<LoginViewModel, CommonState<LoginState>>> {
  const LoginPage({super.key});

  @override
  AutoDisposeStateNotifierProvider<LoginViewModel, CommonState<LoginState>> get provider =>
      loginViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      hideKeyboardWhenTouchOutside: true,
      body: SafeArea(
        child: Stack(
          children: [
            Consumer(
              builder: (context, ref, child) => CommonImage.asset(
                path: ref.watch(backgroundProvider),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.rps),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.rps),
                    CommonText(
                      l10n.login,
                      style: ts(
                        fontSize: 30.rps,
                        fontWeight: FontWeight.w700,
                        color: cl.black,
                      ),
                    ),
                    SizedBox(height: 50.rps),
                    PrimaryTextField(
                      title: l10n.email,
                      hintText: l10n.email,
                      onChanged: (email) => ref.read(provider.notifier).setEmail(email),
                      keyboardType: TextInputType.text,
                      suffixIcon: const Icon(Icons.email),
                    ),
                    SizedBox(height: 24.rps),
                    PrimaryTextField(
                      title: l10n.password,
                      hintText: l10n.password,
                      onChanged: (password) => ref.read(provider.notifier).setPassword(password),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final onPageError = ref.watch(provider.select(
                          (value) => value.data.onPageError,
                        ));

                        return Visibility(
                          visible: onPageError.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.rps),
                            child: CommonText(
                              onPageError,
                              style: ts(
                                fontSize: 14.rps,
                                color: cl.red1,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24.rps),
                    Consumer(
                      builder: (context, ref, child) {
                        final isLoginButtonEnabled = ref.watch(provider.select(
                          (value) => value.data.isLoginButtonEnabled,
                        ));

                        return ElevatedButton(
                          onPressed: isLoginButtonEnabled
                              ? () => ref.read(provider.notifier).login()
                              : null,
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(
                              Size(double.infinity, 48.rps),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              cl.black.withOpacity(
                                isLoginButtonEnabled ? 1 : 0.5,
                              ),
                            ),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.rps)),
                              ),
                            ),
                          ),
                          child: CommonText(
                            l10n.login,
                            style: ts(
                              fontSize: 18.rps,
                              fontWeight: FontWeight.bold,
                              color: cl.white,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24.rps),
                    Align(
                      alignment: Alignment.center,
                      child: CommonText(
                        onTap: () => ref.read(appNavigatorProvider).push(const RegisterRoute()),
                        l10n.createAnAccount,
                        style: ts(
                          fontSize: 18.rps,
                          fontWeight: FontWeight.bold,
                          color: cl.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
