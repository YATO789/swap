import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// App Store のアプリのページ。id の後ろは App Store Connect の「Apple ID」の数字。
final appStoreUrl = Uri.parse('https://apps.apple.com/app/id6823869046');

/// Google Play のアプリのページ。
final playStoreUrl = Uri.parse(
  'https://play.google.com/store/apps/details?id=com.yato.swap',
);

/// この端末のストアで、このアプリのページを開く。
///
/// 開けたら true、開けなかったら false を返す。
Future<bool> openStorePage() async {
  final url = defaultTargetPlatform == TargetPlatform.iOS
      ? appStoreUrl
      : playStoreUrl;
  try {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  } on Exception {
    return false;
  }
}
