import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'initial_resource.freezed.dart';

@freezed
class InitialResource with _$InitialResource {
  const InitialResource._();

  const factory InitialResource({
    @Default(InitialResource.defaultInitialRoutes) List<InitialAppRoute> initialRoutes,
  }) = _InitialResource;

  static const defaultInitialRoutes = [InitialAppRoute.main];
}
