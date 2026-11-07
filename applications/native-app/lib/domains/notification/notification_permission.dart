/// 通知を出してよいかの、今の状態。
enum NotificationPermission {
  /// 許可されている。
  granted,

  /// 許可されていない。もう聞いても何も出ないので、端末の設定で変えてもらう。
  denied,

  /// まだ聞いていない。
  notDetermined,
}
