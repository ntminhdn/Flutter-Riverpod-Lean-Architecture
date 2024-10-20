ifeq ($(OS),Windows_NT)
    BUILD_CMD=.\tools\build_and_run_app.bat
    METRICS_CMD=.\tools\dart_code_metrics.bat
    COMMIT_CHECK_CMD=.\tools\check_commit_message.bat
else
    BUILD_CMD=./tools/build_and_run_app.sh
    METRICS_CMD=./tools/dart_code_metrics.sh
    COMMIT_CHECK_CMD=./tools/check_commit_message.sh
endif

TEST_DART_DEFINE_LIGHT_MODE_AND_JA=--dart-define=IS_DARK_MODE=false --dart-define=LOCALE=ja
TEST_DART_DEFINE_DARK_MODE_AND_EN=--dart-define=IS_DARK_MODE=true --dart-define=LOCALE=en

gen_ai:
	dart run flutter_launcher_icons:main -f app_icon/app-icon.yaml

gen_spl:
	dart run flutter_native_splash:create --path=splash/splash.yaml

rm_spl:
	dart run flutter_native_splash:remove --path=splash/splash.yaml

gen_env:
	dart run tools/gen_env.dart

# It is used in CI/CD, so if you rename it, you need to update the CI/CD script
sync:
	make pg
	make ln
	make cc
	make fb

rpg:
	make cl
	make pg

ref:
	make cl
	make sync

ln:
	flutter gen-l10n

# It is used in CI/CD, so if you rename it, you need to update the CI/CD script
te:
	make ut
	make wt

gt:
	flutter test $(TEST_DART_DEFINE_LIGHT_MODE_AND_JA) --tags=golden
	flutter test $(TEST_DART_DEFINE_DARK_MODE_AND_EN) --tags=golden

ug:
	find . -type d -name "goldens" -exec rm -rf {} +
	flutter test $(TEST_DART_DEFINE_LIGHT_MODE_AND_JA) --update-goldens --tags=golden
	flutter test $(TEST_DART_DEFINE_DARK_MODE_AND_EN) --update-goldens --tags=golden

ut:
	flutter test test/unit_test

wt:
	flutter test test/widget_test $(TEST_DART_DEFINE_LIGHT_MODE_AND_JA)
	flutter test test/widget_test $(TEST_DART_DEFINE_DARK_MODE_AND_EN)

cl:
	flutter clean && rm -rf pubspec.lock
	cd super_lint && flutter clean && rm -rf pubspec.lock
	cd super_lint/example && flutter clean && rm -rf pubspec.lock

pg:
	flutter pub get && cd super_lint && flutter pub get && cd example && flutter pub get

# It is used in CI/CD, so if you rename it, you need to update the CI/CD script
fm:
	find . -name "*.dart" ! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "*.gr.dart" ! -name "*.config.dart" ! -name "*.mocks.dart" ! -path '*/generated/*' ! -path '*/.dart_tool/*' | tr '\n' ' ' | xargs dart format --set-exit-if-changed -l 100

sl:
	./tools/super_lint.sh

analyze:
	flutter analyze --no-pub --suppress-analytics

dart_code_metrics:
	$(METRICS_CMD)

# It is used in CI/CD, so if you rename it, you need to update the CI/CD script
lint:
	make sl
	make analyze
	# make dart_code_metrics

custom_lint:
	dart run custom_lint

# It is used in [tools/dart_code_metrics.sh] and [tools/check_commit_message.bat], so if you rename it, you need to update these files
dcm:
	dart run dart_code_metrics:metrics analyze lib --disable-sunset-warning

cov_full:
	flutter test --coverage
	lcov --remove coverage/lcov.info \
	'*/*.g.dart' \
	'**/generated/*' \
	-o coverage/lcov.info &
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

cov_ut:
	flutter test --coverage test/unit_test
	lcov --remove coverage/lcov.info \
	'lib/data_source/api/client/*_client.dart' \
	'lib/data_source/api/*_service.dart' \
	'lib/data_source/api/middleware/custom_log_interceptor.dart' \
	'lib/data_source/api/middleware/base_interceptor.dart' \
	'lib/data_source/firebase' \
	'lib/data_source/preference/app_preferences.dart' \
	'lib/model/api/*_data.dart' \
	'lib/model/firebase' \
	'lib/model/other' \
	'lib/model/mapper/base/base_data_mapper.dart' \
	'lib/exception/app_exception.dart' \
	'lib/exception/exception_mapper/app_exception_mapper.dart' \
	'lib/exception/exception_handler/exception_handler.dart' \
	'lib/common/config.dart' \
	'lib/common/constant.dart' \
	'lib/common/env.dart' \
	'lib/common/helper' \
	'lib/common/type' \
	'lib/common/util/log.dart' \
	'lib/common/util/file_util.dart' \
	'lib/common/util/ref_ext.dart' \
	'lib/common/util/view_util.dart' \
	'lib/main.dart' \
	'lib/ui/my_app.dart' \
	'lib/di.dart' \
	'lib/di.config.dart' \
	'lib/index.dart' \
	'lib/app_initializer.dart' \
	'lib/ui/base' \
	'lib/ui/component' \
	'lib/ui/page/*_page.dart' \
	'lib/ui_kit' \
	'lib/navigation' \
	'lib/resource' \
	'*/*.g.dart' \
	'**/generated/*' \
	-o coverage/lcov.info &
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

cov:
	flutter test --coverage
	lcov --remove coverage/lcov.info \
	'lib/data_source/api/client/*_client.dart' \
	'lib/data_source/api/*_service.dart' \
	'lib/data_source/api/middleware/custom_log_interceptor.dart' \
	'lib/data_source/api/middleware/base_interceptor.dart' \
	'lib/data_source/firebase' \
	'lib/data_source/preference/app_preferences.dart' \
	'lib/model/api/*_data.dart' \
	'lib/model/firebase' \
	'lib/model/other' \
	'lib/model/mapper/base/base_data_mapper.dart' \
	'lib/exception/app_exception.dart' \
	'lib/exception/exception_mapper/app_exception_mapper.dart' \
	'lib/exception/exception_handler/exception_handler.dart' \
	'lib/common/config.dart' \
	'lib/common/constant.dart' \
	'lib/common/env.dart' \
	'lib/common/helper' \
	'lib/common/type' \
	'lib/common/util/log.dart' \
	'lib/common/util/file_util.dart' \
	'lib/common/util/ref_ext.dart' \
	'lib/common/util/view_util.dart' \
	'lib/main.dart' \
	'lib/ui/my_app.dart' \
	'lib/di.dart' \
	'lib/di.config.dart' \
	'lib/index.dart' \
	'lib/app_initializer.dart' \
	'lib/ui/base/app_provider_observer.dart' \
	'lib/ui/base/base_page.dart' \
	'lib/ui/base/base_stateful_page.dart' \
	'lib/ui_kit' \
	'lib/navigation' \
	'lib/resource' \
	'*/*.g.dart' \
	'**/generated/*' \
	-o coverage/lcov.info &
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

br:
	dart run build_runner build --verbose

fb:
	dart run build_runner build --delete-conflicting-outputs --verbose

cc:
	dart run build_runner clean

ccfb:
	make cc
	make fb

wr:
	dart run build_runner watch --verbose

fw:
	dart run build_runner watch --delete-conflicting-outputs --verbose

run_dev:
	$(BUILD_CMD) develop run

run_qa:
	$(BUILD_CMD) qa run

run_stg:
	$(BUILD_CMD) staging run
	
run_prod:
	$(BUILD_CMD) production run

# It is used in CI/CD
build_dev_apk:
	$(BUILD_CMD) develop build apk

# It is used in CI/CD
build_qa_apk:
	$(BUILD_CMD) qa build apk

# It is used in CI/CD
build_stg_apk:
	$(BUILD_CMD) staging build apk

# It is used in CI/CD
build_prod_apk:
	$(BUILD_CMD) production build apk

# It is used in CI/CD
build_dev_aab:
	$(BUILD_CMD) develop build appbundle

# It is used in CI/CD
build_qa_aab:
	$(BUILD_CMD) qa build appbundle

# It is used in CI/CD
build_stg_aab:
	$(BUILD_CMD) staging build appbundle

# It is used in CI/CD
build_prod_aab:
	$(BUILD_CMD) production build appbundle

# It is used in CI/CD
build_dev_ipa:
	$(BUILD_CMD) develop build ipa --export-options-plist=ios/exportOptions.plist

# It is used in CI/CD
build_qa_ipa:
	$(BUILD_CMD) qa build ipa --export-options-plist=ios/exportOptions.plist

# It is used in CI/CD
build_stg_ipa:
	$(BUILD_CMD) staging build ipa --export-options-plist=ios/exportOptions.plist

# It is used in CI/CD
build_prod_ipa:
	$(BUILD_CMD) production build ipa --export-options-plist=ios/exportOptions.plist

# It is used in CI/CD, so if you rename it, you need to update the CI/CD script
check_pubs:
	dart run tools/check_pubspecs.dart

# It is used in CI/CD, so if you rename it, you need to update the CI/CD script
check_commit_message:
	$(COMMIT_CHECK_CMD) "$(shell git log --format=%B -n 1 --no-merges $(BITBUCKET_COMMIT))"

check_unused_files:
	dart run dart_code_metrics:metrics check-unused-files lib

# It is used in [tools/remove_unused_l10n.dart], so if you rename it, you need to update this file
dcm_check_unused_l10n:
	dart run dart_code_metrics:metrics check-unused-l10n lib --disable-sunset-warning -p ^S$

check_unused_text_styles:
	dart run dart_code_metrics:metrics check-unused-l10n lib --disable-sunset-warning -p ^AppTextStyles$

comment_unused_text_styles:
	dart run tools/remove_unused_text_styles.dart comment

remove_unused_text_styles:
	dart run tools/remove_unused_text_styles.dart remove

comment_unused_lib:
	dart run tools/remove_unused_lib.dart comment
	make pg

remove_unused_lib:
	dart run tools/remove_unused_lib.dart remove
	make pg

remove_unused_l10n:
	make ln
	dart run tools/remove_unused_l10n.dart remove
	make ln

check_unused_l10n:
	make ln
	dart run tools/remove_unused_l10n.dart check

comment_unused_l10n:
	make ln
	dart run tools/remove_unused_l10n.dart comment

remove_dup_l10n:
	dart run tools/remove_dup_l10n.dart

pod:
	make cl
	make pg
	cd ios && rm -rf Pods && rm -f Podfile.lock && pod install --repo-update

pu:
	flutter pub upgrade

ci:
	make check_pubs
	make fm
	make te
	make lint

dart_fix:
	dart fix --apply

cd_dev:
	make cd_dev_android
	make cd_dev_ios

cd_qa:
	make cd_qa_android
	make cd_qa_ios

cd_stg:
	make cd_stg_android
	make cd_stg_ios

cd_dev_android:
	cd android && fastlane increase_version_build_and_up_firebase_develop

cd_qa_android:
	cd android && fastlane increase_version_build_and_up_firebase_qa

cd_stg_android:
	cd android && fastlane increase_version_build_and_up_firebase_staging

cd_dev_ios:
	cd ios && fastlane increase_version_build_and_up_testflight_develop

cd_qa_ios:
	cd ios && fastlane increase_version_build_and_up_testflight_qa

cd_stg_ios:
	cd ios && fastlane increase_version_build_and_up_testflight_staging

fastlane_update_plugins:
	cd ios && bundle install && fastlane update_plugins
	cd android && bundle install && fastlane update_plugins

t1_test:
	flutter drive \
	--driver=integration_test/test_driver/integration_driver.dart \
	--target integration_test/t1_login_failed.dart \
	--flavor develop --debug --dart-define-from-file=dart_defines/develop.json
