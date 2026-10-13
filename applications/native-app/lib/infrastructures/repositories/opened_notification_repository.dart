import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/firebase/opened_notification_datasource.dart';

part '_generated/opened_notification_repository.g.dart';

@Riverpod(keepAlive: true)
OpenedNotificationRepository openedNotificationRepository(Ref ref) {
  return OpenedNotificationRepository(
    ref.read(openedNotificationDatasourceProvider),
  );
}

/// タップされたプッシュ通知から、開く画面を決める。
class OpenedNotificationRepository {
  const OpenedNotificationRepository(this._datasource);

  final OpenedNotificationDatasource _datasource;

  /// タップされた通知の記録が出ている日記帳の id を流す。
  ///
  /// 通知のタップでアプリが起動していれば、最初にその日記帳を流す。
  /// 起動したときの通知は一度しか受け取れないので、聞き直しても流れない。
  Stream<String> openedDiaryBookIds() async* {
    final initial = await _datasource.fetchInitialMessage();
    final initialId = initial == null ? null : _diaryBookIdOf(initial);
    if (initialId != null) yield initialId;

    await for (final message in _datasource.onOpened) {
      final id = _diaryBookIdOf(message);
      if (id != null) yield id;
    }
  }

  /// 記録の通知（Edge Function の notify-post）に入れている日記帳の id。
  String? _diaryBookIdOf(RemoteMessage message) =>
      message.data['diary_book_id'] as String?;
}
