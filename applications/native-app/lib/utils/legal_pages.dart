import 'package:url_launcher/url_launcher.dart';

/// 利用規約のページ。portfolio（yato789.com）に置いている。
final termsOfServiceUrl = Uri.parse('https://yato789.com/apps/swap/terms');

/// プライバシーポリシーのページ。portfolio（yato789.com）に置いている。
final privacyPolicyUrl = Uri.parse('https://yato789.com/apps/swap/privacy');

/// 規約などのページを、アプリの上に重ねたブラウザで開く。
///
/// 開けたら true、開けなかったら false を返す。
Future<bool> openLegalPage(Uri url) async {
  try {
    return await launchUrl(url, mode: LaunchMode.inAppBrowserView);
  } on Exception {
    return false;
  }
}
