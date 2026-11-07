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
  String get commonSaySomething => 'ひとこと';

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
  String inviteSheetMessage(String name, String url, String code) {
    return 'Swap!で「$name」に参加しよう！\n\nアプリはこちら\n$url\n\nアプリの「招待コードで参加」から、このコードを入力してね\n\n【招待コード】\n$code';
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
  String get inviteSheetDecorate => '表紙をデコる';

  @override
  String get inviteSheetDecorateMessage => '絵文字や文字、らくがきで、表紙を自分たちらしくデコれます';

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
  String get homeMenuInfo => '日記帳の情報';

  @override
  String get homeMenuInvite => '友達を招待する';

  @override
  String get homeMenuDecorate => '表紙をデコる';

  @override
  String get homeDiaryBookLongPressHint => 'メニューを開く';

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
  String get emptyDiaryBooksTitle => '最初の日記帳をつくろう';

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
  String get diaryBookReactionFailed => 'リアクションを保存できませんでした。もう一度お試しください';

  @override
  String get reactionAdd => 'リアクションを付ける';

  @override
  String reactionChange(String emoji) {
    return 'リアクションを変える。今は$emoji';
  }

  @override
  String reactionUndo(String emoji) {
    return '$emoji を取り消す';
  }

  @override
  String get reactionMoreEmojis => 'ほかの絵文字';

  @override
  String get reactionYou => 'あなた';

  @override
  String get reactionNameSeparator => '、';

  @override
  String reactionChipLabel(String names, String emoji) {
    return '$namesが$emoji';
  }

  @override
  String timelineNowHour(String time) {
    return '$time ・ いま';
  }

  @override
  String timelinePendingOne(String name) {
    return '$nameはまだ';
  }

  @override
  String timelinePendingTwo(String first, String second) {
    return '$first・$secondはまだ';
  }

  @override
  String timelinePendingMany(String first, String second, int rest) {
    return '$first・$second ほか$rest人はまだ';
  }

  @override
  String get timelineBlankTitle => '今日のページはまだ白紙です';

  @override
  String get timelineBlankMessage => '最初に書いた人の一言から、今日が始まります';

  @override
  String get diarySectionUntitled => 'タイトルなし';

  @override
  String get diarySectionLockedPast => 'この日に日記を書いていないので読めません';

  @override
  String get diarySectionLockedToday => '今日の日記を書くと読めます';

  @override
  String get diarySectionLockedYesterday => '昨日の日記を書くと読めます';

  @override
  String diarySectionLockedSemantics(
    String name,
    String time,
    String title,
    String hint,
  ) {
    return '$nameの日記（$time）。$title。本文はまだ読めません。$hint';
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
  String get diaryDetailReactionFailed => 'リアクションを保存できませんでした。もう一度お試しください';

  @override
  String get diaryDetailDeleted => '日記を削除しました';

  @override
  String get diaryDetailMenu => 'メニュー';

  @override
  String get diaryDetailEdit => '編集';

  @override
  String get diaryDetailDelete => '削除';

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
  String get infoNameHint => '日記帳の名前';

  @override
  String get infoRenameFailed => '名前を変えられませんでした。もう一度お試しください';

  @override
  String get infoRenamed => '名前を保存しました';

  @override
  String get infoNameSave => '保存';

  @override
  String get infoNameSaveHelper => '「保存」か「完了」を押すと保存します';

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
  String infoEditCoverSemantics(String name) {
    return '$nameの表紙、表紙を編集';
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
  String get createDiaryBookFailed => '日記帳を作れませんでした。もう一度お試しください';

  @override
  String get createDiaryBookCreate => '作成';

  @override
  String get createDiaryBookIconHint => '名前の最初の1文字がアイコンになります';

  @override
  String get editorLoadFailed => '日記を読み込めませんでした';

  @override
  String get editorPickerTitle => 'どの日記帳に投稿しますか？';

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
  String get editorOverwriteTitle => '上書きしますか？';

  @override
  String editorOverwriteMessage(String names, String day) {
    String _temp0 = intl.Intl.selectLogic(day, {'today': '今日', 'other': '昨日'});
    return '$namesの$_temp0の日記は、この内容で上書きされます。';
  }

  @override
  String get editorOverwriteConfirm => '上書きする';

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
  String get settingsFeedback => 'フィードバックを送る';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsAccountSection => 'アカウント';

  @override
  String get settingsDeleteAccount => 'アカウントを削除';

  @override
  String get themeModeSystem => '端末に合わせる';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeDark => 'ダーク';

  @override
  String get layoutGrid => '並べる';

  @override
  String get layoutPaged => '1冊ずつ';

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
  String get notificationStepDescription => '日記帳のメンバーが記録や日記を書くと、お知らせが届きます。';

  @override
  String get notificationStepSample1Name => 'はるか';

  @override
  String get notificationStepSample1Body => '新しい記録を書いたよ';

  @override
  String get notificationStepSample1Time => 'たった今';

  @override
  String get notificationStepSample2Name => 'そうた';

  @override
  String get notificationStepSample2Body => '日記を書いたよ';

  @override
  String get notificationStepSample2Time => '5分前';

  @override
  String get notificationStepFootnote => '通知はあとから端末の設定で変えられます。';

  @override
  String get feedbackTitle => 'フィードバック';

  @override
  String get feedbackSend => '送信';

  @override
  String get feedbackDescription =>
      '使ってみた感想や、困ったこと、ほしい機能を教えてください。いただいた内容はアプリの改善に使います。返信はできません。';

  @override
  String get feedbackHint => 'ご意見・ご要望を入力';

  @override
  String get feedbackSendFailed => '送信できませんでした。もう一度お試しください';

  @override
  String get feedbackSent => 'フィードバックを送りました。ありがとうございます';

  @override
  String get profileEditSaveFailed => 'プロフィールを保存できませんでした。もう一度お試しください';

  @override
  String get profileEditSaved => 'プロフィールを保存しました';

  @override
  String get profileEditNameRequired => '名前を入力してください';

  @override
  String get profileEditChangeAvatar => 'アイコンを変える';

  @override
  String get profileEditPickAvatar => '写真を選ぶ';

  @override
  String get profileEditRemoveAvatar => '写真を外す';

  @override
  String get profileEditPickAvatarFailed => '写真を読み込めませんでした';

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

  @override
  String get coverEditTitle => '表紙を編集';

  @override
  String get coverEditUndo => '元に戻す';

  @override
  String get coverEditRedo => 'やり直す';

  @override
  String get coverEditEmoji => '絵文字';

  @override
  String get coverEditText => '文字';

  @override
  String get coverEditDoodle => 'らくがき';

  @override
  String get coverEditColor => '色';

  @override
  String get coverEditDone => '閉じる';

  @override
  String get coverEditBringForward => '前へ';

  @override
  String get coverEditSendBackward => 'うしろへ';

  @override
  String get coverEditFrame => '白いふち';

  @override
  String get coverEditRemove => '消す';

  @override
  String get coverEditHint =>
      '貼ったものはドラッグで動かし、右下のつまみか2本指で回転と拡大縮小。文字は選んでもう一度押すと書き換えられます。';

  @override
  String coverEditStickerLimit(int count) {
    return '貼れるのは$count個までです';
  }

  @override
  String coverEditTextLimit(int count) {
    return '文字は$count個まで置けます';
  }

  @override
  String get coverEditRewrite => '書き換える';

  @override
  String get coverEditTextColorAuto => '自動';

  @override
  String get coverEditTextColorAutoName => '表紙に合わせる';

  @override
  String coverEditTextColorSemantics(String color) {
    return '文字の色 $color';
  }

  @override
  String get colorPaletteOpen => 'ほかの色を選ぶ';

  @override
  String colorPaletteSemantics(String color) {
    return '色 $color';
  }

  @override
  String get colorPaletteTextTitle => '文字の色';

  @override
  String get colorPalettePenTitle => 'ペンの色';

  @override
  String get colorPaletteCoverTitle => '表紙の色';

  @override
  String get coverEditStrokeLimit => 'これ以上描けません。消しゴムで消すと描けます';

  @override
  String get coverEditPenExtraThin => '極細のペン';

  @override
  String get coverEditPenThin => '細いペン';

  @override
  String get coverEditPenMedium => 'ふつうのペン';

  @override
  String get coverEditPenThick => '太いペン';

  @override
  String get coverEditEraser => '消しゴム';

  @override
  String get coverEditPenBlack => '黒';

  @override
  String get coverEditPenWhite => '白';

  @override
  String get coverEditPenRed => '赤';

  @override
  String get coverEditPenOrange => 'オレンジ';

  @override
  String get coverEditPenGreen => '緑';

  @override
  String get coverEditPenBlue => '青';

  @override
  String get coverEditPenPink => 'ピンク';

  @override
  String get coverEditKnob => '回転と拡大縮小';

  @override
  String coverEditStickerSemantics(String emoji) {
    return '貼った絵文字 $emoji';
  }

  @override
  String coverEditNameSemantics(String name) {
    return '表紙の名前 $name';
  }

  @override
  String coverEditTextSemantics(String text) {
    return '置いた文字 $text';
  }

  @override
  String get coverTextSheetTitle => '表紙に文字を置く';

  @override
  String get coverTextSheetEditTitle => '文字を書き換える';

  @override
  String get coverTextSheetHint => '表紙に入れる文字';

  @override
  String get coverTextSheetPlace => '置く';

  @override
  String get coverTextSheetPlaceName => '日記帳の名前を置く';

  @override
  String get coverEditDoodleArea => 'らくがきをする場所。表紙をなぞって線を描き、2本指で拡大する';

  @override
  String get coverEditResetZoom => '等倍に戻す';

  @override
  String get coverEditSaved => '表紙を保存しました';

  @override
  String get coverEditSaveFailed => '保存できませんでした。もう一度お試しください';

  @override
  String get coverEditNeedsUpdate => '表紙を編集するには、アプリをアップデートしてください';

  @override
  String get emojiSheetTitle => '絵文字を選ぶ';

  @override
  String get emojiSheetNoRecents => 'まだありません';

  @override
  String get emojiSheetSearch => '絵文字を検索';

  @override
  String get settingsDiaryReminder => '日記のリマインダー';

  @override
  String get settingsDiaryReminderDescription =>
      '毎日この時刻に、日記を書くよう知らせます。今日の日記を書いた日は知らせません';

  @override
  String get settingsDiaryReminderTime => '知らせる時刻';

  @override
  String get settingsNotificationDenied => '通知がオフになっています。端末の設定で通知を許可してください';

  @override
  String get settingsOpenDeviceSettings => '設定を開く';

  @override
  String get diaryReminderBody => '今日はどんな一日だった？日記を書こう';
}
