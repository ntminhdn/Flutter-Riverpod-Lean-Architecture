# YOUR_PROJECT_NAME

The simple Flutter project

## Test Coverage

Including Unit Tests, Widget Tests, Golden Tests, and Integration Tests

<img width="1311" alt="coverage" src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/74bcd31a-20fd-4727-bf35-c1e699394bff">


## Screenshots

### Chat Page

|           Light           |           Dark            |
| :------------------------: | :------------------------: |
| <img src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/f02803ad-497b-4331-90ae-c4df7b52e7d5" /> | <img src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/782531ca-bb39-4f7f-a106-ac59cb4ad8a2" /> |

### Contact List Page

|           Light           |           Dark            |
| :------------------------: | :------------------------: |
| <img src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/85a857b9-d6b4-4129-8408-50cfbfd0c437" /> | <img src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/30bb26db-9e83-422c-ad6c-98e92199834c" /> |

### Register Page

|           Light           |           Dark            |
| :------------------------: | :------------------------: |
| <img src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/726e29a2-b055-4827-83b5-aab21c7eba7b" /> | <img src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/f1bcab26-d734-4601-a3a9-cbdca46a597d" /> |

### My Page

|           Light           |           Dark            |
| :------------------------: | :------------------------: |
| <img src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/b409e4ab-6fb6-4c85-a136-16989689995a" /> | <img src="https://github.com/ntminhdn/Flutter-Riverpod-Lean-Architecture/assets/93504649/d1f37287-121d-447d-af87-2093e3056655" /> |


## Getting Started

### Requirements

- Dart: 3.5.3
- Flutter SDK: 3.24.3
- CocoaPods: 1.15.0

### How to run app

- cd to root folder of project
- Run `make gen_env`
- Run `make sync`
- Run app via VSCode or using command `make run_dev`
- Enjoy!

## Starting new project

### 1. Config multi-flavors and Firebase

- Change flavor settings:
    - Replace all `jp.flutter.app` by your project bundle id (application id)
    - Config flavors for Android at [build.gradle](android/build.gradle)
        - Application name: find and change values of: `manifestPlaceholders["applicationName"]`
        - Version name: find and change values of: `versionName`
        - Version code: find and change values of: `versionCode`
    - Config flavors for iOS at: 
        - [Develop.xcconfig](ios/Flutter/Develop.xcconfig)
        - [Qa.xcconfig](ios/Flutter/Qa.xcconfig)
        - [Staging.xcconfig](ios/Flutter/Staging.xcconfig)
        - [Production.xcconfig](ios/Flutter/Production.xcconfig) 

- Config Firebase
    - Android: Paste your google services files to:
        - [Develop](android/app/src/develop)
        - [Qa](android/app/src/qa)
        - [Staging](android/app/src/staging)
        - [Production](android/app/src/production)
    - iOS: Paste your google services files to:
        - [Develop](ios/config/develop)
        - [Qa](ios/config/qa)
        - [Staging](ios/config/staging)
        - [Production](ios/config/production)

### 2. Secrets configuration

- Define secret constants in [env.dart](lib/common/env.dart) and JSON files in folder [dart_defines](dart_defines) including:
    - dart_defines/develop.json
    - dart_defines/qa.json
    - dart_defines/staging.json
    - dart_defines/production.json

For example:
```
{
  "FLAVOR": "develop",
  "APP_BASIC_AUTH_NAME": "admin",
  "APP_BASIC_AUTH_PASSWORD": "admin"
}
```

### 3. Other configs

- `designDeviceWidth`, `designDeviceHeight`, `materialAppTitle`, `taskMenuMaterialAppColor`, `systemUiOverlay`, `mobileOrientation`, `tabletOrientation` in [constant.dart](lib/common/constant.dart)

### 4. Update README.md

- [YOUR_PROJECT_NAME](#YOUR_PROJECT_NAME) and the project description
- [Upgrade Flutter](#upgrade-flutter) if needed

### 5. Setup Fastlane (optional)

- Create files `.env.default` in [ios/fastlane](ios/fastlane) and [android/fastlane](android/fastlane)
- Paste this into files `.env.default`
```
SLACK_URL = "https://hooks.slack.com/services/xxx"
APP_CENTER_TOKEN = "xxx"
APPLE_TOKEN = "xxx"
FIREBASE_TOKEN = "1//xxx"
```
- Update config values in [ios/Fastfile](ios/fastlane/Fastfile) and [android/Fastfile](android/fastlane/Fastfile)

### 6. Setup Jenkins (optional)

- Update `tokenCredentialId`, `channel` in [Jenkinsfile](Jenkinsfile)

### 7. Setup Lefthook (optional)

- Replace all text: `NFT` by `YOUR_PROJECT_CODE` in:
    - Commit message rule: [commit-msg.sh](.lefthook/commit-msg/commit-msg.sh) and [check_commit_message.sh](tools/check_commit_message.sh)
    - Branch name rule: [pre-commit.sh](.lefthook/pre-commit/pre-commit.sh) and [bitbucket-pipelines/pull-requests](bitbucket-pipelines.yml)
- Run `lefthook install`

## Note

### 1. Upgrading Flutter
- Please update these files when upgrading Flutter version:
    - [README.md](#requirements)
    - [bitbucket-pipelines.yml](bitbucket-pipelines.yml)
    - [Jenkinsfile](Jenkinsfile)
    - [codemagic.yaml](codemagic.yaml)
    - [ci.yaml](.github/workflows/ci.yaml)
    - [cd_develop.yaml](.github/workflows/cd_develop.yaml)
    - [cd_qa.yaml](.github/workflows/cd_qa.yaml)
    - [cd_staging.yaml](.github/workflows/cd_staging.yaml)
    - [cd_production.yaml](.github/workflows/cd_production.yaml)
