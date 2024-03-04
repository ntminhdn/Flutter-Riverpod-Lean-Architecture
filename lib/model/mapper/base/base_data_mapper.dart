abstract class BaseDataMapper<R extends Object, L extends Object> {
  const BaseDataMapper();

  L mapToLocal(R? data);

  List<L> mapToLocalList(List<R>? listData) {
    return listData?.map(mapToLocal).toList() ?? List.empty();
  }
}

/// Optional: if need map from local data to remote data
mixin DataMapperMixin<R extends Object, L extends Object> on BaseDataMapper<R, L> {
  R mapToRemote(L data);

  R? mapToNullableRemote(L? data) {
    if (data == null) {
      return null;
    }

    return mapToRemote(data);
  }

  List<R>? mapToNullableRemoteList(List<L>? listData) {
    return listData?.map(mapToRemote).toList();
  }

  List<R> mapToRemoteList(List<L>? listData) {
    return mapToNullableRemoteList(listData) ?? List.empty();
  }
}
