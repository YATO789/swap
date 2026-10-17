import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  /// 端末の言語に合わせた文言。
  AppLocalizations get l10n => AppLocalizations.of(this);
}
