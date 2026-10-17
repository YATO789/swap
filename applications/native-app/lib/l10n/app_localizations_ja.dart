// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonRetry => 'もう一度試す';

  @override
  String get commonSave => '保存する';

  @override
  String get commonDelete => '削除する';

  @override
  String get commonOpenLinkFailed => 'ページを開けませんでした';

  @override
  String get commonToday => '今日';

  @override
  String get commonYesterday => '昨日';

  @override
  String get commonName => '名前';

  @override
  String get commonEnterName => '名前を入力';

  @override
  String get commonFormerMember => '抜けたメンバー';

  @override
  String get commonNoPostsThisDay => 'この日の記録はありません';

  @override
  String get commonInviteCode => '招待コード';

  @override
  String get commonJoinWithInviteCode => '招待コードで参加';

  @override
  String get commonCreateDiaryBook => '日記帳を作る';

  @override
  String get commonDiaryBookInfo => '日記帳の情報';

  @override
  String get commonDiaryBookNameHint => '日記帳の名前を入力';

  @override
  String get commonDiaryBookUnavailable => 'この日記帳は表示できません';

  @override
  String get commonWriteDiary => '日記を書く';

  @override
  String get commonPost => '記録する';

  @override
  String get commonWhatAreYouDoing => '今なにしてる？';

  @override
  String get commonTermsOfService => '利用規約';

  @override
  String get commonPrivacyPolicy => 'プライバシーポリシー';

  @override
  String commonMemberCount(int count) {
    return '$count人';
  }

  @override
  String commonDiaryOfDate(String date) {
    return '$dateの日記';
  }

  @override
  String commonTodayWithDate(String date) {
    return '今日・$date';
  }

  @override
  String get postHintShare => 'いまをひとことシェア';

  @override
  String get postHintDiary => '日記はここ！';

  @override
  String get confirmSheetIrreversible => 'この操作は取り消せません';

  @override
  String get discardGuardTitle => '入力内容を破棄しますか？';

  @override
  String get discardGuardMessage => '保存していない内容は失われます。';

  @override
  String get discardGuardKeepEditing => '編集を続ける';

  @override
  String get discardGuardDiscard => '破棄する';

  @override
  String inviteSheetMessage(String name, String code) {
    return 'Swap!で「$name」に参加しよう！\nアプリの「招待コードで参加」から、このコードを入力してね。\n招待コード: $code';
  }

  @override
  String get inviteSheetCopied => '招待メッセージをコピーしました';

  @override
  String inviteSheetCreatedTitle(String name) {
    return '「$name」を作りました';
  }

  @override
  String inviteSheetTitle(String name) {
    return '「$name」に招待';
  }

  @override
  String get inviteSheetCreatedDescription =>
      '友達を招待して、記録や日記を共有しましょう。招待コードを送ると、受け取った人がコードを入れて参加できます';

  @override
  String get inviteSheetDescription => '招待コードを送ると、受け取った人がコードを入れて参加できます';

  @override
  String inviteSheetCodeSemantics(String code) {
    return '招待コード $code';
  }

  @override
  String get inviteSheetCopy => '招待メッセージをコピー';

  @override
  String get inviteSheetLater => 'あとで招待する';

  @override
  String get postSheetFailed => '記録できませんでした。もう一度お試しください';

  @override
  String get postSheetPosted => '記録しました';

  @override
  String postSheetPostingTo(String name) {
    return '$nameに記録します';
  }

  @override
  String get postSheetShareTo => '共有する日記帳';

  @override
  String get postButtonWriteToday => '今日の日記を書く';

  @override
  String get postButtonWriteYesterday => '昨日の日記を書く';

  @override
  String get coverColorLabel => '表紙の色';

  @override
  String get homeRefreshFailed => '日記帳を読み込めませんでした。もう一度お試しください';

  @override
  String get homeAddDiaryBook => '日記帳を追加';

  @override
  String get homeProfileAndSettings => 'プロフィールと設定';

  @override
  String get homeLoadFailed => '日記帳を読み込めませんでした';

  @override
  String homeDiaryBookSemantics(String name, String memberCount) {
    return '$name、$memberCount';
  }

  @override
  String get addDiaryBookCreateDescription => '新しい日記帳を作って友達を招待します';

  @override
  String get addDiaryBookJoinDescription => '友達から届いたコードで日記帳に入ります';

  @override
  String get emptyDiaryBooksTitle => '最初の日記帳を\nつくろう';

  @override
  String get emptyDiaryBooksMessage => '1冊のノートを友達とまわして、\n毎日のできごとを交換しよう。';

  @override
  String get joinSheetCheckFailed => '確認できませんでした。もう一度お試しください';

  @override
  String get joinSheetCodeNotFound => '招待コードが見つかりません';

  @override
  String get joinSheetJoinFailed => '参加できませんでした。もう一度お試しください';

  @override
  String joinSheetDescription(int length) {
    return '友達から届いた$length文字のコードを入れてください';
  }

  @override
  String get joinSheetPaste => '貼り付け';

  @override
  String get joinSheetCheck => '確認する';

  @override
  String get joinSheetOpen => '日記帳を開く';

  @override
  String get joinSheetJoin => 'この日記帳に参加する';

  @override
  String get joinSheetAlreadyJoined => 'この日記帳にはもう参加しています';

  @override
  String joinSheetFull(int limit) {
    return 'この日記帳は満員です（$limit人まで）';
  }

  @override
  String joinSheetSpotsLeft(int count) {
    return 'あと$count人まで参加できます';
  }

  @override
  String joinSheetMemberCount(int count) {
    return '$count人のメンバー';
  }

  @override
  String diaryBookNoLongerAvailableTitle(String name) {
    return '「$name」は見られなくなりました';
  }

  @override
  String get diaryBookNoLongerAvailableMessage => 'この日記帳の記録や日記は表示できません。';

  @override
  String get diaryBookBackToHome => 'ホームに戻る';

  @override
  String get diaryBookDeletePostTitle => '記録を削除しますか？';

  @override
  String get diaryBookDeletePostMessage => 'ほかの日記帳に出した分は残ります。';

  @override
  String get diaryBookPostDeleted => '記録を削除しました';

  @override
  String get diaryBookPostDeleteFailed => '記録を削除できませんでした。もう一度お試しください';

  @override
  String get diaryBookPickDate => '日付を選ぶ';

  @override
  String get diaryBookLoadFailed => '日記帳を読み込めませんでした';

  @override
  String get timelineNoPostsYet => 'まだ記録がありません';

  @override
  String get deletePostPickerTitle => '削除する記録を選んでください';

  @override
  String get diarySectionUntitled => 'タイトルなし';

  @override
  String get diarySectionLockedPast => 'この日に日記を書いていないので読めません';

  @override
  String get diarySectionLockedToday => 'この日記帳に今日の日記を書くと読めます';

  @override
  String get diarySectionLockedYesterday => 'この日記帳に昨日の日記を書くと読めます';

  @override
  String diarySectionLockedSemantics(String name, String time, String hint) {
    return '$nameの日記（$time）。まだ読めません。$hint';
  }

  @override
  String get calendarPreviousMonth => '前の月';

  @override
  String get calendarNextMonth => '次の月';

  @override
  String get calendarHasDiary => '日記あり';

  @override
  String get calendarHasPost => '記録あり';

  @override
  String get calendarLabelSeparator => '、';

  @override
  String get diaryDetailFallbackDiaryBookName => '日記帳';

  @override
  String get diaryDetailDeleteTitle => '日記を削除しますか？';

  @override
  String diaryDetailDeleteMessage(String diaryBookName) {
    return '「$diaryBookName」からこの日記を削除します。';
  }

  @override
  String get diaryDetailDeleteFailed => '日記を削除できませんでした。もう一度お試しください';

  @override
  String get diaryDetailDeleted => '日記を削除しました';

  @override
  String get diaryDetailMenu => 'メニュー';

  @override
  String get diaryDetailEdit => '編集';

  @override
  String get diaryDetailDelete => '削除';

  @override
  String get diaryDetailPrevious => '前の日記';

  @override
  String get diaryDetailNext => '次の日記';

  @override
  String get diaryDetailUnavailable => 'この日記は表示できません';

  @override
  String get diaryDetailLoadFailed => '日記を読み込めませんでした';

  @override
  String diaryDetailWrittenAt(String time) {
    return '$timeに書きました';
  }

  @override
  String get diaryDetailPostsOfDay => 'この日の記録';

  @override
  String get infoRenameFailed => '名前を変えられませんでした。もう一度お試しください';

  @override
  String get infoCoverColorFailed => '表紙の色を変えられませんでした。もう一度お試しください';

  @override
  String get infoMemberLimitFailed => '人数の上限を変えられませんでした。もう一度お試しください';

  @override
  String get infoRegenerateInviteCodeTitle => '招待コードを作り直しますか？';

  @override
  String infoRegenerateInviteCodeMessage(String code) {
    return '今のコード（$code）では参加できなくなります。参加しているメンバーはそのままです。';
  }

  @override
  String get infoRegenerateInviteCodeConfirm => '作り直す';

  @override
  String get infoRegenerateInviteCodeFailed => '招待コードを作り直せませんでした。もう一度お試しください';

  @override
  String get infoInviteCodeRegenerated => '招待コードを作り直しました';

  @override
  String infoRemoveMemberTitle(String name) {
    return '$nameさんを外しますか？';
  }

  @override
  String get infoRemoveMemberMessage =>
      'この日記帳の記録や日記が見られなくなります。また参加できないように、招待コードも作り直します。';

  @override
  String get infoRemoveMemberConfirm => '外す';

  @override
  String get infoRemoveMemberFailed => 'メンバーを外せませんでした。もう一度お試しください';

  @override
  String infoMemberRemoved(String name) {
    return '$nameさんを外しました';
  }

  @override
  String infoLeaveTitle(String name) {
    return '「$name」から退出しますか？';
  }

  @override
  String get infoLeaveMessage => 'この日記帳の記録や日記が見られなくなります。招待コードがあればまた参加できます。';

  @override
  String get infoLeaveConfirm => '退出する';

  @override
  String get infoLeaveFailed => '日記帳から退出できませんでした。もう一度お試しください';

  @override
  String infoLeft(String name) {
    return '「$name」から退出しました';
  }

  @override
  String get infoCoverSection => '表紙';

  @override
  String get infoRename => '名前を変える';

  @override
  String get infoMembersSection => 'この日記を書く人';

  @override
  String get infoMemberLimit => '人数の上限';

  @override
  String get infoChangeMemberLimit => '人数の上限を変える';

  @override
  String infoMemberLimitValue(int count) {
    return '$count人まで';
  }

  @override
  String get infoRegenerateInviteCode => '招待コードを作り直す';

  @override
  String get infoLeaveDiaryBook => '日記帳を退出';

  @override
  String infoRenameSemantics(String name) {
    return '$name、名前を変える';
  }

  @override
  String get infoYou => 'あなた';

  @override
  String infoMemberMenu(String name) {
    return '$nameさんのメニュー';
  }

  @override
  String get infoRemoveFromDiaryBook => 'この日記帳から外す';

  @override
  String infoInviteSemantics(String code) {
    return '友達を招待、招待コード $code';
  }

  @override
  String get infoInviteFriends => '友達を招待する';

  @override
  String get infoLoadFailed => '日記帳の情報を読み込めませんでした';

  @override
  String get memberLimitTitle => '人数の上限';

  @override
  String get memberLimitCannotGoBelow => '今の人数より少なくはできません';

  @override
  String memberLimitFull(int count) {
    return '$count人まで・満員';
  }

  @override
  String memberLimitLeft(int count, int left) {
    return '$count人まで・あと$left人';
  }

  @override
  String get renameTitle => '日記帳の名前';

  @override
  String get renameIconHelper => '最初の1文字がアイコンになります';

  @override
  String get createDiaryBookFailed => '日記帳を作れませんでした。もう一度お試しください';

  @override
  String get createDiaryBookCreate => '作成';

  @override
  String get createDiaryBookIconHint => '名前の最初の1文字がアイコンになります';

  @override
  String get editorLoadFailed => '日記を読み込めませんでした';

  @override
  String get editorPickerTitle => '日記を書く日記帳';

  @override
  String editorAllStatus(String day, int total, int written) {
    String _temp0 = intl.Intl.selectLogic(day, {'today': '今日', 'other': '昨日'});
    return '$_temp0の日記: $total冊中$written冊に書いた';
  }

  @override
  String editorStatusWritten(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {'today': '今日', 'other': '昨日'});
    return '$_temp0の日記: 書いた';
  }

  @override
  String editorStatusNotYet(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {'today': '今日', 'other': '昨日'});
    return '$_temp0の日記: まだ';
  }

  @override
  String get editorSaveFailed => '日記を書けませんでした。もう一度お試しください';

  @override
  String get editorPosted => '日記を投稿しました';

  @override
  String get editorUpdated => '日記を更新しました';

  @override
  String get editorPost => '投稿';

  @override
  String get editorUpdate => '更新';

  @override
  String editorDayPosts(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {'today': '今日', 'other': '昨日'});
    return '$_temp0の記録';
  }

  @override
  String get editorTitleHint => 'タイトル';

  @override
  String editorBodyHint(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {'today': '今日', 'other': '昨日'});
    return '$_temp0はどんな一日だった？';
  }

  @override
  String get editorNoDiaryBook => '日記帳を作ると書けます';

  @override
  String editorDiaryBookSemantics(String name) {
    return '日記を書く日記帳: $name';
  }

  @override
  String get editorChangeDiaryBook => '日記帳を選び直す';

  @override
  String get diaryBookPickerAll => 'すべての日記帳';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSignOutConfirmTitle => 'ログアウトしますか？';

  @override
  String get settingsSignOut => 'ログアウト';

  @override
  String get settingsSignOutFailed => 'ログアウトできませんでした。もう一度お試しください';

  @override
  String get settingsDeleteAccountConfirmTitle => 'アカウントを削除しますか？';

  @override
  String get settingsDeleteAccountConfirmMessage =>
      'プロフィール・記録・日記がすべて削除されます。日記帳からも抜け、ほかに誰もいない日記帳は削除されます。';

  @override
  String get settingsDeleteAccountFailed => 'アカウントを削除できませんでした。もう一度お試しください';

  @override
  String get settingsHomeLayoutSection => 'ホームの日記帳の並べ方';

  @override
  String get settingsDisplaySection => '表示';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsPostHint => '書き込みバーの説明';

  @override
  String get settingsPostHintDescription => 'ホームの入力欄とペンに、手書きの説明を添えます';

  @override
  String get settingsDiarySection => '日記';

  @override
  String get settingsDayStart => '日付の切り替わり';

  @override
  String get settingsDayStartDescription => 'これより前に書いた記録や日記は前日の分になります';

  @override
  String settingsDayStartValue(int hour) {
    return '朝$hour:00';
  }

  @override
  String get settingsOtherSection => 'その他';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsAccountSection => 'アカウント';

  @override
  String get settingsDeleteAccount => 'アカウントを削除';

  @override
  String get settingsEditProfile => 'プロフィールを編集';

  @override
  String settingsProfileTileSemantics(String name) {
    return '$name、プロフィールを編集';
  }

  @override
  String get themeModeSystem => '端末に合わせる';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeDark => 'ダーク';

  @override
  String get layoutList => 'リスト';

  @override
  String get layoutCover => '表紙';

  @override
  String get onboardingSaveNameFailed => '名前を保存できませんでした。もう一度お試しください';

  @override
  String get onboardingNameTitle => 'なんて呼べばいい？';

  @override
  String get onboardingNameDescription => '日記帳のメンバーに表示される名前です。あとから変えられます。';

  @override
  String get onboardingAllowNotifications => '通知を許可する';

  @override
  String get onboardingLater => 'あとで';

  @override
  String get onboardingNext => '次へ';

  @override
  String get notificationStepTitle => '通知をオンにしよう';

  @override
  String get notificationStepDescription => '日記帳のメンバーが記録を書くと、お知らせが届きます。';

  @override
  String get notificationStepSample1Name => 'はるか';

  @override
  String get notificationStepSample1Body => '駅前の新しいカフェに来てみた☕';

  @override
  String get notificationStepSample1Time => 'たった今';

  @override
  String get notificationStepSample2Name => 'そうた';

  @override
  String get notificationStepSample2Body => 'やっとレポート終わった！';

  @override
  String get notificationStepSample2Time => '5分前';

  @override
  String get notificationStepFootnote => '通知はあとから端末の設定で変えられます。';

  @override
  String get profileEditTitle => 'プロフィール';

  @override
  String get profileEditSave => '保存';

  @override
  String get profileEditSaveFailed => 'プロフィールを保存できませんでした。もう一度お試しください';

  @override
  String get profileEditSaved => 'プロフィールを保存しました';

  @override
  String get profileEditNameRequired => '名前を入力してください';

  @override
  String get profileEditAvatarColor => 'アイコンの色';

  @override
  String get welcomeSignInFailed => 'サインインできませんでした。もう一度お試しください';

  @override
  String get welcomeTagline => '交換日記みたいに、みんなで\n1日の日記を共有しよう';

  @override
  String get welcomeSigningIn => 'サインイン中…';

  @override
  String get welcomeSignInWithApple => 'Appleでサインイン';

  @override
  String get welcomeTryAnonymously => '匿名で試す（開発用）';

  @override
  String get welcomeAgreementPrefix => '続けると、';

  @override
  String get welcomeAgreementConjunction => 'と';

  @override
  String get welcomeAgreementSuffix => 'に\n同意したことになります';

  @override
  String get splashLoadFailed => '読み込めませんでした';

  @override
  String get updateRequiredTitle => 'アップデートしてください';

  @override
  String get updateRequiredMessage => '新しいバージョンが出ています。\nこのまま使うには、アップデートが必要です。';

  @override
  String get updateOptionalTitle => '新しいバージョンがあります';

  @override
  String get updateOptionalMessage => 'アップデートすると、新しい機能や改善を使えます。';

  @override
  String get updateNow => 'アップデート';

  @override
  String get updateLater => 'あとで';
}
