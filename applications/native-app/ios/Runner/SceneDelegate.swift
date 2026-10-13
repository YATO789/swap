import Flutter
import UIKit
import UserNotifications

class SceneDelegate: FlutterSceneDelegate {
  // アプリを開いたら、通知のバッジを消す。サーバーの未読数は Flutter 側で 0 に戻す。
  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    if #available(iOS 16.0, *) {
      UNUserNotificationCenter.current().setBadgeCount(0)
    } else {
      UIApplication.shared.applicationIconBadgeNumber = 0
    }
  }
}
