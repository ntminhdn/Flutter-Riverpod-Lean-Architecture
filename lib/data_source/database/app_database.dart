import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../index.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) => getIt.get<AppDatabase>());

Future<Isar> openIsar() async {
  final directory = await getApplicationDocumentsDirectory();

  return Isar.open(
    [
      LocalMessageDataSchema,
    ],
    directory: directory.path,
    inspector: Env.flavor != Flavor.production,
  );
}

@LazySingleton()
class AppDatabase {
  AppDatabase(this.isar, this.appPreferences);

  final AppPreferences appPreferences;
  final Isar isar;

  String get userId => appPreferences.userId;

  Future<int> removeMessagesByConversationId(String id) {
    return isar.writeTxn(() {
      return isar.localMessageDatas
          .filter()
          .conversationIdEqualTo(id)
          .userIdEqualTo(userId)
          .deleteAll();
    });
  }

  List<LocalMessageData> getLatestMessages(String conversationId) {
    return isar.localMessageDatas
        .filter()
        .conversationIdEqualTo(conversationId)
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .limit(Constant.itemsPerPage)
        .build()
        .findAllSync();
  }

  Stream<List<LocalMessageData>> getMessagesStream(
    String conversationId,
  ) {
    return isar.localMessageDatas
        .filter()
        .conversationIdEqualTo(conversationId)
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .build()
        .watch(fireImmediately: true);
  }

  Future<void> putMessages(List<LocalMessageData> messages) async {
    await isar.writeTxn(() async {
      await isar.localMessageDatas.putAll(messages);
    });
  }

  Future<void> putMessage(LocalMessageData message) async {
    await isar.writeTxn(() async {
      await isar.localMessageDatas.put(message);
    });
  }
}
