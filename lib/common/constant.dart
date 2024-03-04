import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../index.dart';

class Constant {
  const Constant._();
  static const imageHost = 'https://i.pinimg.com';
  static const contactListBg = '$imageHost/564x/fe/71/99/fe719944c92a0d0cb0795dbef8d790db.jpg';

  // Design
  static const designDeviceWidth = 375.0;
  static const designDeviceHeight = 667.0;

  // Paging
  static const initialPage = 1;
  static const itemsPerPage = 30;
  static const invisibleItemsThreshold = 3;

  // Shimmer
  static const shimmerItemCount = 20;

  // Format
  static const fddMMyyyy = 'dd/MM/yyyy';
  static const fHHmm = 'HH:mm';
  static const fddMMyyyyHHmm = 'dd/MM/yyyy HH:mm';
  static const fyyyyMMdd = 'yyyy-MM-dd';
  static const numberFormat1 = '#,###';

  // Duration
  static const listGridTransitionDuration = Duration(milliseconds: 500);
  static const generalDialogTransitionDuration = Duration(milliseconds: 200);
  static const snackBarDuration = Duration(seconds: 3);

  // Url
  static const termUrl = 'https://www.chatwork.com/';
  static const lineApiBaseUrl = 'https://api.line.me/';
  static const twitterApiBaseUrl = 'https://api.twitter.com/';
  static const goongApiBaseUrl = 'https://rsapi.goong.io/';
  static const firebaseStorageBaseUrl = 'https://firebasestorage.googleapis.com/';
  static const randomUserBaseUrl = 'https://randomuser.me/api/';

  // Deep links
  static const resetPasswordLink = 'nals://';

  // Path
  static const remoteConfigPath = '/config/RemoteConfig.json';
  static const settingsPath = '/mypage/settings';

  // Material app
  static const materialAppTitle = 'My App';
  // Can not use AppColor here
// ignore: avoid_hard_coded_colors
  static const taskMenuMaterialAppColor = Colors.green;

  // Orientation
  static const mobileOrientation = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];
  static const tabletOrientation = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  // Can not use AppColor here
  static const systemUiOverlay = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
// ignore: avoid_hard_coded_colors
    statusBarColor: Colors.green,
  );

  // Base API URL
  static String get appApiBaseUrl {
    switch (Env.flavor) {
      case Flavor.develop:
        return 'http://api.dev.nals.vn/api';
      case Flavor.qa:
        return 'http://api.dev.nals.vn/api';
      case Flavor.staging:
        return 'http://api.dev.nals.vn/api';
      case Flavor.production:
        return 'http://api.dev.nals.vn/api';
    }
  }

  // FCM
  static const fcmImage = 'image';
  static const fcmConversationId = 'conversation_id';

  // API config
  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
  static const sendTimeout = Duration(seconds: 30);
  static const maxRetries = 3;
  static const firstRetryInterval = Duration(seconds: 1);
  static const secondRetryInterval = Duration(seconds: 2);
  static const thirdRetryInterval = Duration(seconds: 4);
  static const defaultErrorResponseDecoderType = ErrorResponseDecoderType.jsonObject;
  static const defaultSuccessResponseDecoderType = SuccessResponseDecoderType.dataJsonObject;

  // error field
  static const nickname = 'nickname';
  static const email = 'email';
  static const password = 'password';
  static const passwordConfirmation = 'password_confirmation';

  // error code
  static const invalidRefreshToken = 1300;
  static const invalidResetPasswordToken = 1302;
  static const multipleDeviceLogin = 1602;
  static const accountHasDeleted = 1603;
  static const pageNotFound = 1051;

  // error id
  static const badUserInput = 'BAD_USER_INPUT';
  static const unAuthenticated = 'UNAUTHENTICATED';
  static const forbidden = 'FORBIDDEN';

  // header
  static const basicAuthorization = 'Authorization';
  static const jwtAuthorization = 'JWT-Authorization';
  static const userAgentKey = 'User-Agent';
  static const bearer = 'Bearer';

  // response
  static const en = 'EN';
  static const ja = 'JA';
  static const male = 0;
  static const female = 1;
  static const other = 2;
  static const unknown = -1;
}
