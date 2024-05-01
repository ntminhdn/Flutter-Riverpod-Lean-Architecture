# Introduction

A VSCode extension used for this code base.

## Table of Contents

- [Installation guide](#installation-guide)
- [1. Settings](#1-settings)
    - [1.1. appName](#11-appname)
    - [1.2. uiFolderPath](#12-uifolderpath)
    - [1.3. dataModelPath](#13-datamodelpath)
    - [1.4. autoExportBarrier](#14-autoexportbarrier)
    - [1.5. autoExportOnSave](#15-autoexportonsave)
    - [1.6. excludeFilesWhenAutoExport](#16-excludefileswhenautoexport)
- [2. Commands](#2-commands)
    - [2.1. nals:Create new Page](#21-nalscreate-new-page)
    - [2.2. nals:Auto export](#22-nalsauto-export)
    - [2.3. nals:[API] Clipboard to Data Model](#23-nalsapi-clipboard-to-data-model)
    - [2.4. nals:[API] Json to Data Model](#24-nalsapi-json-to-data-model)
    - [2.5. nals:[API] Json to Params](#25-nalsapi-json-to-params)
    - [2.6. nals:Create test file](#26-nalscreate-test-file)

- [3. Snippets](#3-snippets)
    - [3.1. Data model](#31-data-model)
    - [3.2. Mapper](#32-mapper)
    - [3.3. UI](#33-ui)
    - [3.4. ViewModel](#34-viewmodel)
    - [3.5. Shared Preferences](#35-shared-preferences)
    - [3.6. Testing](#36-testing)
    - [3.7. Others](#37-others)

## Installation guide
[Installation guide](https://www.alphr.com/vs-code-how-to-install-extensions/#:~:text=Open%20the%20%E2%80%9CExtensions%E2%80%9D%20sidebar%20(you%20can%20use%20%E2%80%9CCtrl%2BShift%2BX%E2%80%9D))

## 1. Settings

Add this to file `.vscode/settings.json`
```
{
    "nalsMobileBrain.appName": "nalsflutter",
    "nalsMobileBrain.uiFolderPath": "lib/ui/page",
    "nalsMobileBrain.dataModelPath": "lib/model/api",
    "nalsMobileBrain.autoExportBarrier": "",
    "nalsMobileBrain.autoExportOnSave": false,
    "nalsMobileBrain.excludeFilesWhenAutoExport": [
        "g.dart",
        "config.dart",
        "freezed.dart",
        "mapper.dart"
    ],
}
```

### 1.1. appName

It is `name` declared in the `pubspec.yaml` file.

* pubspec.yaml
```
name: nalsflutter
...
```

* settings.json
```
{
    "nalsMobileBrain.appName": "nalsflutter"
}
```

* Default value: `"nalsflutter"`

### 1.2. uiFolderPath

Path to the Folder that contains the generated files from the command [nals:Create new Page](#21-nalscreate-new-page)

* Default value: `"lib/ui/page"`

### 1.3. dataModelPath

Path to the Folder that contains the generated files from the command [nals:[API] Clipboard to Data Model](#23-nalsapi-clipboard-to-data-model)

* Default value: `"lib/model/api"`

### 1.4 autoExportBarrier

It is used for the [nals:Auto export](#22-nalsauto-export) command. It is a String placed in the [index.dart](../../lib/index.dart) file. All code above this string will not be replaced by the tool. For example:

```
library app;

export 'package:dartx/dartx.dart';

// GENERATED
export 'app.dart';
export 'src/app/my_app.dart';
export 'src/app/view_model/app_state.dart';
...
```

When setting `"nalsMobileBrain.autoExportBarrier": "// GENERATED"`, all code above the string `// GENERATED` will not be replaced but all code below the string `// GENERATED` will be replaced. If this setting is empty or omitted, then all code in the file will be replaced.

* Default value: `""`

### 1.5. autoExportOnSave

If this setting is `true`, the tool will automatically call the [nals:Auto export](#22-nalsauto-export) command when saving the file. Be careful when using it because it can cause your computer to lag due to too many commands being called.

* Default value: `false`

### 1.6. excludeFilesWhenAutoExport

File extensions that the [nals:Auto export](#22-nalsauto-export) command will ignore.

* Default value: `[
        "g.dart",
        "config.dart",
        "freezed.dart",
        "mapper.dart"
    ]`

## 2. Commands

### 2.1. nals:Create new Page

Generate 3 classes in the `[nalsMobileBrain.uiFolderPath]` folder: 
- 1 class extends `BasePage`
- 1 class extends `BaseState`
- 1 class extends `BaseViewModel`

### 2.2. nals:Auto export

Export all files in lib folder to the [index.dart](../../lib/index.dart) file

### 2.3. nals:[API] Clipboard to Data Model

Copy a Json and run this command, it will generate all data model files in the `[nalsMobileBrain.dataModelPath]` folder.

### 2.4. nals:[API] Json to Data Model

It is useful when you implement the GET method APIs.

Input:
```
"id": 13,
"email": "minhnt3@nal.vn",
"created_at": "2021-12-06T03:55:22.000000Z",
"average_mark": 6.5,
"roles": ["admin", "user"],
"isVIP": false,
"marks": [1.5,2.0,3],
"friend_ids": [1,2,3],
"name": null,
"classifies":"[{\"id\":1,\"name\":\"M\n h\c\"}]",
```
Output:
```
@Default(Readme.defaultId)  @JsonKey(name: 'id') int id,
@Default(Readme.defaultEmail)  @JsonKey(name: 'email') String email,
@Default(Readme.defaultCreatedAt)  @JsonKey(name: 'created_at') String createdAt,
@Default(Readme.defaultAverageMark)  @JsonKey(name: 'average_mark') double averageMark,
@Default(Readme.defaultRoles)  @JsonKey(name: 'roles') List<String> roles,
@Default(Readme.defaultIsVip)  @JsonKey(name: 'isVIP') bool isVip,
@Default(Readme.defaultMarks)  @JsonKey(name: 'marks') List<double> marks,
@Default(Readme.defaultFriendIds)  @JsonKey(name: 'friend_ids') List<int> friendIds,
@Default(Readme.defaultName)  @JsonKey(name: 'name') dynamic name,
@Default(Readme.defaultClassifies)  @JsonKey(name: 'classifies') String classifies,

static const int defaultId = 0;
static const String defaultEmail = '';
static const String defaultCreatedAt = '';
static const double defaultAverageMark = 0.0;
static const List<String> defaultRoles = <String>[];
static const bool defaultIsVip = false;
static const List<double> defaultMarks = <double>[];
static const List<int> defaultFriendIds = <int>[];
static const dynamic defaultName = null;
static const String defaultClassifies = '';
```

### 2.5. nals:[API] Json to Params

It is useful when you implement the POST method APIs.

Input:
```
"id": 13,
"email": "minhnt3@nal.vn",
"created_at": "2021-12-06T03:55:22.000000Z",
"average_mark": 6.5,
"roles": ["admin", "user"],
"isVIP": false,
"marks": [1.5,2.0,3],
"friend_ids": [1,2,3],
"name": null,
"classifies":"[{\"id\":1,\"name\":\"M\n h\c\"}]",
```
Output:
```
required int id,
required String email,
required String createdAt,
required double averageMark,
required List<String> roles,
required bool isVip,
required List<double> marks,
required List<int> friendIds,
required dynamic name,
required String classifies,

'id': id,
'email': email,
'created_at': createdAt,
'average_mark': averageMark,
'roles': roles,
'isVIP': isVip,
'marks': marks,
'friend_ids': friendIds,
'name': name,
'classifies': classifies,
```

### 2.6. nals:Create test file

It's used to generate a test file for the `.dart` file currently displayed in the active Text Editor. If the test file was generated, it will open the test file in the active Text Editor. The test file path will mirror the code file path in the lib folder. For example, if the code file is `lib/ui/page/login/view_model/login_view_model.dart`, the test file will be `test/unit_test/ui/page/login/view_model/login_view_model_test.dart`.

## 3. Snippets

## 3.1. Data model

* `fr` - Freezed model class
* `am` - API data model class
* `fm` - Firebase data model class
* `im` - Isar data model class
* `om` - ObjectBox data model class

## 3.2. Mapper

* `mp` - API data to Local data mapper class

## 3.3. UI

* `pa`: `EdgeInsets.all(xx.rps)`
* `pv`: `EdgeInsets.symmetric(vertical: xx.rps,)`
* `ph`: `EdgeInsets.symmetric(horizontal: xx.rps,)`
* `po`: `EdgeInsets.only(xx: yy.rps)`
* `di`: `xx.rps`
* `cl`: `cl.xx`
* `ts`: `ts(fontSize: xx.rps, color: cl.yy,)`
* `ln`: `l10n.xx`
* `ue`: `useEffect(() {Future.microtask(() {})...`

## 3.4. ViewModel

- `rc` - `await runCatching(action: () async {});` in ViewModel classes

## 3.5. Shared Preferences

- `spb` - setter and getter for `bool` value in Shared Preferences
- `spi` - setter and getter for `int` value in Shared Preferences
- `spd` - setter and getter for `double` value in Shared Preferences
- `sps` - setter and getter for `String` value in Shared Preferences

## 3.6. Testing

- `nt` - `stateNotifierTest(...)`
- `gt` - `testGoldens(...)` used for Pages using non-family Providers (`StateNotifierProvider.autoDispose`)
- `gtf` - `testGoldens(...)` used for Pages using family Providers (`StateNotifierProvider.autoDispose
    .family`)

## 3.7. Others

- `dl` - `Future<dynamic>.delayed(const Duration(milliseconds: xx))`
- `pr` - Riverpod provider `Provider.autoDispose<...>((ref) => ...)`
