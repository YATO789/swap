import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @commonCancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get commonClose;

  /// No description provided for @commonRetry.
  ///
  /// In ja, this message translates to:
  /// **'もう一度試す'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In ja, this message translates to:
  /// **'保存する'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In ja, this message translates to:
  /// **'削除する'**
  String get commonDelete;

  /// No description provided for @commonOpenLinkFailed.
  ///
  /// In ja, this message translates to:
  /// **'ページを開けませんでした'**
  String get commonOpenLinkFailed;

  /// No description provided for @commonToday.
  ///
  /// In ja, this message translates to:
  /// **'今日'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In ja, this message translates to:
  /// **'昨日'**
  String get commonYesterday;

  /// No description provided for @commonAvatarColor.
  ///
  /// In ja, this message translates to:
  /// **'アイコンの色'**
  String get commonAvatarColor;

  /// No description provided for @commonName.
  ///
  /// In ja, this message translates to:
  /// **'名前'**
  String get commonName;

  /// No description provided for @commonEnterName.
  ///
  /// In ja, this message translates to:
  /// **'名前を入力'**
  String get commonEnterName;

  /// 日記帳から抜けた人の名前の代わりに出す
  ///
  /// In ja, this message translates to:
  /// **'抜けたメンバー'**
  String get commonFormerMember;

  /// No description provided for @commonNoPostsThisDay.
  ///
  /// In ja, this message translates to:
  /// **'この日の記録はありません'**
  String get commonNoPostsThisDay;

  /// No description provided for @commonInviteCode.
  ///
  /// In ja, this message translates to:
  /// **'招待コード'**
  String get commonInviteCode;

  /// No description provided for @commonJoinWithInviteCode.
  ///
  /// In ja, this message translates to:
  /// **'招待コードで参加'**
  String get commonJoinWithInviteCode;

  /// No description provided for @commonCreateDiaryBook.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を作る'**
  String get commonCreateDiaryBook;

  /// No description provided for @commonDiaryBookInfo.
  ///
  /// In ja, this message translates to:
  /// **'日記帳の情報'**
  String get commonDiaryBookInfo;

  /// No description provided for @commonDiaryBookNameHint.
  ///
  /// In ja, this message translates to:
  /// **'日記帳の名前を入力'**
  String get commonDiaryBookNameHint;

  /// No description provided for @commonDiaryBookUnavailable.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳は表示できません'**
  String get commonDiaryBookUnavailable;

  /// No description provided for @commonWriteDiary.
  ///
  /// In ja, this message translates to:
  /// **'日記を書く'**
  String get commonWriteDiary;

  /// No description provided for @commonPost.
  ///
  /// In ja, this message translates to:
  /// **'記録する'**
  String get commonPost;

  /// No description provided for @commonWhatAreYouDoing.
  ///
  /// In ja, this message translates to:
  /// **'今なにしてる？'**
  String get commonWhatAreYouDoing;

  /// No description provided for @commonTermsOfService.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get commonTermsOfService;

  /// No description provided for @commonPrivacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get commonPrivacyPolicy;

  /// No description provided for @commonMemberCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}人'**
  String commonMemberCount(int count);

  /// date は formatMonthDay で作った「10月3日」
  ///
  /// In ja, this message translates to:
  /// **'{date}の日記'**
  String commonDiaryOfDate(String date);

  /// ホームの入力欄の上に手書きで添える説明。変えたら assets/fonts/Yomogi-Hint.ttf を作り直す
  ///
  /// In ja, this message translates to:
  /// **'いまをひとことシェア'**
  String get postHintShare;

  /// ホームのペンのボタンに手書きで添える説明。変えたら assets/fonts/Yomogi-Hint.ttf を作り直す
  ///
  /// In ja, this message translates to:
  /// **'日記はここ！'**
  String get postHintDiary;

  /// No description provided for @confirmSheetIrreversible.
  ///
  /// In ja, this message translates to:
  /// **'この操作は取り消せません'**
  String get confirmSheetIrreversible;

  /// No description provided for @discardGuardTitle.
  ///
  /// In ja, this message translates to:
  /// **'入力内容を破棄しますか？'**
  String get discardGuardTitle;

  /// No description provided for @discardGuardMessage.
  ///
  /// In ja, this message translates to:
  /// **'保存していない内容は失われます。'**
  String get discardGuardMessage;

  /// No description provided for @discardGuardKeepEditing.
  ///
  /// In ja, this message translates to:
  /// **'編集を続ける'**
  String get discardGuardKeepEditing;

  /// No description provided for @discardGuardDiscard.
  ///
  /// In ja, this message translates to:
  /// **'破棄する'**
  String get discardGuardDiscard;

  /// 友達に送る招待メッセージ。参加するシートは最後に見つかったコードを使うので、コードは必ず最後に置く
  ///
  /// In ja, this message translates to:
  /// **'Swap!で「{name}」に参加しよう！\nアプリの「招待コードで参加」から、このコードを入力してね。\n招待コード: {code}'**
  String inviteSheetMessage(String name, String code);

  /// No description provided for @inviteSheetCopied.
  ///
  /// In ja, this message translates to:
  /// **'招待メッセージをコピーしました'**
  String get inviteSheetCopied;

  /// No description provided for @inviteSheetCreatedTitle.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を作りました'**
  String inviteSheetCreatedTitle(String name);

  /// No description provided for @inviteSheetTitle.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」に招待'**
  String inviteSheetTitle(String name);

  /// No description provided for @inviteSheetCreatedDescription.
  ///
  /// In ja, this message translates to:
  /// **'友達を招待して、記録や日記を共有しましょう。招待コードを送ると、受け取った人がコードを入れて参加できます'**
  String get inviteSheetCreatedDescription;

  /// No description provided for @inviteSheetDescription.
  ///
  /// In ja, this message translates to:
  /// **'招待コードを送ると、受け取った人がコードを入れて参加できます'**
  String get inviteSheetDescription;

  /// 読み上げ用。code は1文字ずつ空白で区切った招待コード
  ///
  /// In ja, this message translates to:
  /// **'招待コード {code}'**
  String inviteSheetCodeSemantics(String code);

  /// No description provided for @inviteSheetCopy.
  ///
  /// In ja, this message translates to:
  /// **'招待メッセージをコピー'**
  String get inviteSheetCopy;

  /// No description provided for @inviteSheetLater.
  ///
  /// In ja, this message translates to:
  /// **'あとで招待する'**
  String get inviteSheetLater;

  /// No description provided for @postSheetFailed.
  ///
  /// In ja, this message translates to:
  /// **'記録できませんでした。もう一度お試しください'**
  String get postSheetFailed;

  /// No description provided for @postSheetPosted.
  ///
  /// In ja, this message translates to:
  /// **'記録しました'**
  String get postSheetPosted;

  /// No description provided for @postSheetPostingTo.
  ///
  /// In ja, this message translates to:
  /// **'{name}に記録します'**
  String postSheetPostingTo(String name);

  /// No description provided for @postSheetShareTo.
  ///
  /// In ja, this message translates to:
  /// **'共有する日記帳'**
  String get postSheetShareTo;

  /// No description provided for @postButtonWriteToday.
  ///
  /// In ja, this message translates to:
  /// **'今日の日記を書く'**
  String get postButtonWriteToday;

  /// No description provided for @postButtonWriteYesterday.
  ///
  /// In ja, this message translates to:
  /// **'昨日の日記を書く'**
  String get postButtonWriteYesterday;

  /// No description provided for @coverColorLabel.
  ///
  /// In ja, this message translates to:
  /// **'表紙の色'**
  String get coverColorLabel;

  /// No description provided for @homeRefreshFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を読み込めませんでした。もう一度お試しください'**
  String get homeRefreshFailed;

  /// No description provided for @homeAddDiaryBook.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を追加'**
  String get homeAddDiaryBook;

  /// No description provided for @homeProfileAndSettings.
  ///
  /// In ja, this message translates to:
  /// **'プロフィールと設定'**
  String get homeProfileAndSettings;

  /// No description provided for @homeLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を読み込めませんでした'**
  String get homeLoadFailed;

  /// 読み上げ用。日記帳の名前と人数（「3人」など）
  ///
  /// In ja, this message translates to:
  /// **'{name}、{memberCount}'**
  String homeDiaryBookSemantics(String name, String memberCount);

  /// No description provided for @addDiaryBookCreateDescription.
  ///
  /// In ja, this message translates to:
  /// **'新しい日記帳を作って友達を招待します'**
  String get addDiaryBookCreateDescription;

  /// No description provided for @addDiaryBookJoinDescription.
  ///
  /// In ja, this message translates to:
  /// **'友達から届いたコードで日記帳に入ります'**
  String get addDiaryBookJoinDescription;

  /// No description provided for @emptyDiaryBooksTitle.
  ///
  /// In ja, this message translates to:
  /// **'最初の日記帳をつくろう'**
  String get emptyDiaryBooksTitle;

  /// No description provided for @emptyDiaryBooksMessage.
  ///
  /// In ja, this message translates to:
  /// **'1冊のノートを友達とまわして、\n毎日のできごとを交換しよう。'**
  String get emptyDiaryBooksMessage;

  /// No description provided for @joinSheetCheckFailed.
  ///
  /// In ja, this message translates to:
  /// **'確認できませんでした。もう一度お試しください'**
  String get joinSheetCheckFailed;

  /// No description provided for @joinSheetCodeNotFound.
  ///
  /// In ja, this message translates to:
  /// **'招待コードが見つかりません'**
  String get joinSheetCodeNotFound;

  /// No description provided for @joinSheetJoinFailed.
  ///
  /// In ja, this message translates to:
  /// **'参加できませんでした。もう一度お試しください'**
  String get joinSheetJoinFailed;

  /// No description provided for @joinSheetDescription.
  ///
  /// In ja, this message translates to:
  /// **'友達から届いた{length}文字のコードを入れてください'**
  String joinSheetDescription(int length);

  /// No description provided for @joinSheetPaste.
  ///
  /// In ja, this message translates to:
  /// **'貼り付け'**
  String get joinSheetPaste;

  /// No description provided for @joinSheetCheck.
  ///
  /// In ja, this message translates to:
  /// **'確認する'**
  String get joinSheetCheck;

  /// No description provided for @joinSheetOpen.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を開く'**
  String get joinSheetOpen;

  /// No description provided for @joinSheetJoin.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳に参加する'**
  String get joinSheetJoin;

  /// No description provided for @joinSheetAlreadyJoined.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳にはもう参加しています'**
  String get joinSheetAlreadyJoined;

  /// No description provided for @joinSheetFull.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳は満員です（{limit}人まで）'**
  String joinSheetFull(int limit);

  /// No description provided for @joinSheetSpotsLeft.
  ///
  /// In ja, this message translates to:
  /// **'あと{count}人まで参加できます'**
  String joinSheetSpotsLeft(int count);

  /// No description provided for @joinSheetMemberCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}人のメンバー'**
  String joinSheetMemberCount(int count);

  /// 開いている日記帳から外されたときのお知らせのタイトル。name は日記帳の名前
  ///
  /// In ja, this message translates to:
  /// **'「{name}」は見られなくなりました'**
  String diaryBookNoLongerAvailableTitle(String name);

  /// No description provided for @diaryBookNoLongerAvailableMessage.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳の記録や日記は表示できません。'**
  String get diaryBookNoLongerAvailableMessage;

  /// No description provided for @diaryBookBackToHome.
  ///
  /// In ja, this message translates to:
  /// **'ホームに戻る'**
  String get diaryBookBackToHome;

  /// No description provided for @diaryBookDeletePostTitle.
  ///
  /// In ja, this message translates to:
  /// **'記録を削除しますか？'**
  String get diaryBookDeletePostTitle;

  /// No description provided for @diaryBookDeletePostMessage.
  ///
  /// In ja, this message translates to:
  /// **'ほかの日記帳に出した分は残ります。'**
  String get diaryBookDeletePostMessage;

  /// No description provided for @diaryBookPostDeleted.
  ///
  /// In ja, this message translates to:
  /// **'記録を削除しました'**
  String get diaryBookPostDeleted;

  /// No description provided for @diaryBookPostDeleteFailed.
  ///
  /// In ja, this message translates to:
  /// **'記録を削除できませんでした。もう一度お試しください'**
  String get diaryBookPostDeleteFailed;

  /// No description provided for @diaryBookPickDate.
  ///
  /// In ja, this message translates to:
  /// **'日付を選ぶ'**
  String get diaryBookPickDate;

  /// No description provided for @diaryBookLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を読み込めませんでした'**
  String get diaryBookLoadFailed;

  /// No description provided for @timelineNoPostsYet.
  ///
  /// In ja, this message translates to:
  /// **'まだ記録がありません'**
  String get timelineNoPostsYet;

  /// No description provided for @diarySectionUntitled.
  ///
  /// In ja, this message translates to:
  /// **'タイトルなし'**
  String get diarySectionUntitled;

  /// No description provided for @diarySectionAuthor.
  ///
  /// In ja, this message translates to:
  /// **'{name} の日記'**
  String diarySectionAuthor(String name);

  /// No description provided for @diarySectionLockedPast.
  ///
  /// In ja, this message translates to:
  /// **'この日に日記を書いていないので読めません'**
  String get diarySectionLockedPast;

  /// No description provided for @diarySectionLockedToday.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳に今日の日記を書くと読めます'**
  String get diarySectionLockedToday;

  /// No description provided for @diarySectionLockedYesterday.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳に昨日の日記を書くと読めます'**
  String get diarySectionLockedYesterday;

  /// 読めない日記のカードの読み上げ。time は書いた時刻、hint は読めるようにする方法
  ///
  /// In ja, this message translates to:
  /// **'{name}の日記（{time}）。まだ読めません。{hint}'**
  String diarySectionLockedSemantics(String name, String time, String hint);

  /// No description provided for @calendarPreviousMonth.
  ///
  /// In ja, this message translates to:
  /// **'前の月'**
  String get calendarPreviousMonth;

  /// No description provided for @calendarNextMonth.
  ///
  /// In ja, this message translates to:
  /// **'次の月'**
  String get calendarNextMonth;

  /// No description provided for @calendarHasDiary.
  ///
  /// In ja, this message translates to:
  /// **'日記あり'**
  String get calendarHasDiary;

  /// No description provided for @calendarHasPost.
  ///
  /// In ja, this message translates to:
  /// **'記録あり'**
  String get calendarHasPost;

  /// カレンダーの日の読み上げで、日付・今日・日記あり などをつなぐ区切り
  ///
  /// In ja, this message translates to:
  /// **'、'**
  String get calendarLabelSeparator;

  /// 日記帳の名前が分からないときに削除の確認文で代わりに使う名前
  ///
  /// In ja, this message translates to:
  /// **'日記帳'**
  String get diaryDetailFallbackDiaryBookName;

  /// No description provided for @diaryDetailDeleteTitle.
  ///
  /// In ja, this message translates to:
  /// **'日記を削除しますか？'**
  String get diaryDetailDeleteTitle;

  /// No description provided for @diaryDetailDeleteMessage.
  ///
  /// In ja, this message translates to:
  /// **'「{diaryBookName}」からこの日記を削除します。'**
  String diaryDetailDeleteMessage(String diaryBookName);

  /// No description provided for @diaryDetailDeleteFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記を削除できませんでした。もう一度お試しください'**
  String get diaryDetailDeleteFailed;

  /// No description provided for @diaryDetailDeleted.
  ///
  /// In ja, this message translates to:
  /// **'日記を削除しました'**
  String get diaryDetailDeleted;

  /// No description provided for @diaryDetailMenu.
  ///
  /// In ja, this message translates to:
  /// **'メニュー'**
  String get diaryDetailMenu;

  /// No description provided for @diaryDetailEdit.
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get diaryDetailEdit;

  /// No description provided for @diaryDetailDelete.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get diaryDetailDelete;

  /// No description provided for @diaryDetailUnavailable.
  ///
  /// In ja, this message translates to:
  /// **'この日記は表示できません'**
  String get diaryDetailUnavailable;

  /// No description provided for @diaryDetailLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記を読み込めませんでした'**
  String get diaryDetailLoadFailed;

  /// No description provided for @diaryDetailWrittenAt.
  ///
  /// In ja, this message translates to:
  /// **'{time}に書きました'**
  String diaryDetailWrittenAt(String time);

  /// No description provided for @diaryDetailPostsOfDay.
  ///
  /// In ja, this message translates to:
  /// **'この日の記録'**
  String get diaryDetailPostsOfDay;

  /// No description provided for @infoRenameFailed.
  ///
  /// In ja, this message translates to:
  /// **'名前を変えられませんでした。もう一度お試しください'**
  String get infoRenameFailed;

  /// No description provided for @infoCoverColorFailed.
  ///
  /// In ja, this message translates to:
  /// **'表紙の色を変えられませんでした。もう一度お試しください'**
  String get infoCoverColorFailed;

  /// No description provided for @infoMemberLimitFailed.
  ///
  /// In ja, this message translates to:
  /// **'人数の上限を変えられませんでした。もう一度お試しください'**
  String get infoMemberLimitFailed;

  /// No description provided for @infoRegenerateInviteCodeTitle.
  ///
  /// In ja, this message translates to:
  /// **'招待コードを作り直しますか？'**
  String get infoRegenerateInviteCodeTitle;

  /// No description provided for @infoRegenerateInviteCodeMessage.
  ///
  /// In ja, this message translates to:
  /// **'今のコード（{code}）では参加できなくなります。参加しているメンバーはそのままです。'**
  String infoRegenerateInviteCodeMessage(String code);

  /// 招待コードを作り直す確認シートの決定ボタン
  ///
  /// In ja, this message translates to:
  /// **'作り直す'**
  String get infoRegenerateInviteCodeConfirm;

  /// No description provided for @infoRegenerateInviteCodeFailed.
  ///
  /// In ja, this message translates to:
  /// **'招待コードを作り直せませんでした。もう一度お試しください'**
  String get infoRegenerateInviteCodeFailed;

  /// No description provided for @infoInviteCodeRegenerated.
  ///
  /// In ja, this message translates to:
  /// **'招待コードを作り直しました'**
  String get infoInviteCodeRegenerated;

  /// No description provided for @infoRemoveMemberTitle.
  ///
  /// In ja, this message translates to:
  /// **'{name}さんを外しますか？'**
  String infoRemoveMemberTitle(String name);

  /// No description provided for @infoRemoveMemberMessage.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳の記録や日記が見られなくなります。また参加できないように、招待コードも作り直します。'**
  String get infoRemoveMemberMessage;

  /// メンバーを外す確認シートの決定ボタン
  ///
  /// In ja, this message translates to:
  /// **'外す'**
  String get infoRemoveMemberConfirm;

  /// No description provided for @infoRemoveMemberFailed.
  ///
  /// In ja, this message translates to:
  /// **'メンバーを外せませんでした。もう一度お試しください'**
  String get infoRemoveMemberFailed;

  /// No description provided for @infoMemberRemoved.
  ///
  /// In ja, this message translates to:
  /// **'{name}さんを外しました'**
  String infoMemberRemoved(String name);

  /// name は日記帳の名前
  ///
  /// In ja, this message translates to:
  /// **'「{name}」から退出しますか？'**
  String infoLeaveTitle(String name);

  /// No description provided for @infoLeaveMessage.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳の記録や日記が見られなくなります。招待コードがあればまた参加できます。'**
  String get infoLeaveMessage;

  /// 日記帳から退出する確認シートの決定ボタン
  ///
  /// In ja, this message translates to:
  /// **'退出する'**
  String get infoLeaveConfirm;

  /// No description provided for @infoLeaveFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記帳から退出できませんでした。もう一度お試しください'**
  String get infoLeaveFailed;

  /// name は日記帳の名前
  ///
  /// In ja, this message translates to:
  /// **'「{name}」から退出しました'**
  String infoLeft(String name);

  /// 日記帳の情報の見出し
  ///
  /// In ja, this message translates to:
  /// **'表紙'**
  String get infoCoverSection;

  /// No description provided for @infoRename.
  ///
  /// In ja, this message translates to:
  /// **'名前を変える'**
  String get infoRename;

  /// 日記帳の情報の、メンバーの見出し
  ///
  /// In ja, this message translates to:
  /// **'この日記を書く人'**
  String get infoMembersSection;

  /// No description provided for @infoMemberLimit.
  ///
  /// In ja, this message translates to:
  /// **'人数の上限'**
  String get infoMemberLimit;

  /// No description provided for @infoChangeMemberLimit.
  ///
  /// In ja, this message translates to:
  /// **'人数の上限を変える'**
  String get infoChangeMemberLimit;

  /// No description provided for @infoMemberLimitValue.
  ///
  /// In ja, this message translates to:
  /// **'{count}人まで'**
  String infoMemberLimitValue(int count);

  /// No description provided for @infoRegenerateInviteCode.
  ///
  /// In ja, this message translates to:
  /// **'招待コードを作り直す'**
  String get infoRegenerateInviteCode;

  /// No description provided for @infoLeaveDiaryBook.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を退出'**
  String get infoLeaveDiaryBook;

  /// 題名のボタンの読み上げ。name は日記帳の名前
  ///
  /// In ja, this message translates to:
  /// **'{name}、名前を変える'**
  String infoRenameSemantics(String name);

  /// メンバーの一覧で自分の行に添える
  ///
  /// In ja, this message translates to:
  /// **'あなた'**
  String get infoYou;

  /// No description provided for @infoMemberMenu.
  ///
  /// In ja, this message translates to:
  /// **'{name}さんのメニュー'**
  String infoMemberMenu(String name);

  /// No description provided for @infoRemoveFromDiaryBook.
  ///
  /// In ja, this message translates to:
  /// **'この日記帳から外す'**
  String get infoRemoveFromDiaryBook;

  /// 招待の行の読み上げ。code は1文字ずつ空白で区切った招待コード
  ///
  /// In ja, this message translates to:
  /// **'友達を招待、招待コード {code}'**
  String infoInviteSemantics(String code);

  /// No description provided for @infoInviteFriends.
  ///
  /// In ja, this message translates to:
  /// **'友達を招待する'**
  String get infoInviteFriends;

  /// No description provided for @infoLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記帳の情報を読み込めませんでした'**
  String get infoLoadFailed;

  /// No description provided for @memberLimitTitle.
  ///
  /// In ja, this message translates to:
  /// **'人数の上限'**
  String get memberLimitTitle;

  /// No description provided for @memberLimitCannotGoBelow.
  ///
  /// In ja, this message translates to:
  /// **'今の人数より少なくはできません'**
  String get memberLimitCannotGoBelow;

  /// No description provided for @memberLimitFull.
  ///
  /// In ja, this message translates to:
  /// **'{count}人まで・満員'**
  String memberLimitFull(int count);

  /// count は人数の上限、left はあと何人参加できるか
  ///
  /// In ja, this message translates to:
  /// **'{count}人まで・あと{left}人'**
  String memberLimitLeft(int count, int left);

  /// No description provided for @renameTitle.
  ///
  /// In ja, this message translates to:
  /// **'日記帳の名前'**
  String get renameTitle;

  /// No description provided for @renameIconHelper.
  ///
  /// In ja, this message translates to:
  /// **'最初の1文字がアイコンになります'**
  String get renameIconHelper;

  /// No description provided for @createDiaryBookFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を作れませんでした。もう一度お試しください'**
  String get createDiaryBookFailed;

  /// 日記帳を作るページの右上のボタン
  ///
  /// In ja, this message translates to:
  /// **'作成'**
  String get createDiaryBookCreate;

  /// No description provided for @createDiaryBookIconHint.
  ///
  /// In ja, this message translates to:
  /// **'名前の最初の1文字がアイコンになります'**
  String get createDiaryBookIconHint;

  /// No description provided for @editorLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記を読み込めませんでした'**
  String get editorLoadFailed;

  /// No description provided for @editorPickerTitle.
  ///
  /// In ja, this message translates to:
  /// **'日記を書く日記帳'**
  String get editorPickerTitle;

  /// 「すべての日記帳」の下に添える。day は today か yesterday
  ///
  /// In ja, this message translates to:
  /// **'{day, select, today{今日} other{昨日}}の日記: {total}冊中{written}冊に書いた'**
  String editorAllStatus(String day, int total, int written);

  /// 日記帳の名前の下に添える。day は today か yesterday
  ///
  /// In ja, this message translates to:
  /// **'{day, select, today{今日} other{昨日}}の日記: 書いた'**
  String editorStatusWritten(String day);

  /// 日記帳の名前の下に添える。day は today か yesterday
  ///
  /// In ja, this message translates to:
  /// **'{day, select, today{今日} other{昨日}}の日記: まだ'**
  String editorStatusNotYet(String day);

  /// No description provided for @editorSaveFailed.
  ///
  /// In ja, this message translates to:
  /// **'日記を書けませんでした。もう一度お試しください'**
  String get editorSaveFailed;

  /// No description provided for @editorPosted.
  ///
  /// In ja, this message translates to:
  /// **'日記を投稿しました'**
  String get editorPosted;

  /// No description provided for @editorUpdated.
  ///
  /// In ja, this message translates to:
  /// **'日記を更新しました'**
  String get editorUpdated;

  /// 日記を書くページの右上のボタン（まだ書いていないとき）
  ///
  /// In ja, this message translates to:
  /// **'投稿'**
  String get editorPost;

  /// 日記を書くページの右上のボタン（もう書いてあるとき）
  ///
  /// In ja, this message translates to:
  /// **'更新'**
  String get editorUpdate;

  /// day は today か yesterday
  ///
  /// In ja, this message translates to:
  /// **'{day, select, today{今日} other{昨日}}の記録'**
  String editorDayPosts(String day);

  /// No description provided for @editorTitleHint.
  ///
  /// In ja, this message translates to:
  /// **'タイトル'**
  String get editorTitleHint;

  /// day は today か yesterday
  ///
  /// In ja, this message translates to:
  /// **'{day, select, today{今日} other{昨日}}はどんな一日だった？'**
  String editorBodyHint(String day);

  /// No description provided for @editorNoDiaryBook.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を作ると書けます'**
  String get editorNoDiaryBook;

  /// name は日記帳の名前か「すべての日記帳」
  ///
  /// In ja, this message translates to:
  /// **'日記を書く日記帳: {name}'**
  String editorDiaryBookSemantics(String name);

  /// No description provided for @editorChangeDiaryBook.
  ///
  /// In ja, this message translates to:
  /// **'日記帳を選び直す'**
  String get editorChangeDiaryBook;

  /// No description provided for @diaryBookPickerAll.
  ///
  /// In ja, this message translates to:
  /// **'すべての日記帳'**
  String get diaryBookPickerAll;

  /// No description provided for @settingsTitle.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTitle;

  /// No description provided for @settingsSignOutConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'ログアウトしますか？'**
  String get settingsSignOutConfirmTitle;

  /// No description provided for @settingsSignOut.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutFailed.
  ///
  /// In ja, this message translates to:
  /// **'ログアウトできませんでした。もう一度お試しください'**
  String get settingsSignOutFailed;

  /// No description provided for @settingsDeleteAccountConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを削除しますか？'**
  String get settingsDeleteAccountConfirmTitle;

  /// No description provided for @settingsDeleteAccountConfirmMessage.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール・記録・日記がすべて削除されます。日記帳からも抜け、ほかに誰もいない日記帳は削除されます。'**
  String get settingsDeleteAccountConfirmMessage;

  /// No description provided for @settingsDeleteAccountFailed.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを削除できませんでした。もう一度お試しください'**
  String get settingsDeleteAccountFailed;

  /// No description provided for @settingsHomeLayoutSection.
  ///
  /// In ja, this message translates to:
  /// **'ホームの日記帳の並べ方'**
  String get settingsHomeLayoutSection;

  /// No description provided for @settingsDisplaySection.
  ///
  /// In ja, this message translates to:
  /// **'表示'**
  String get settingsDisplaySection;

  /// No description provided for @settingsTheme.
  ///
  /// In ja, this message translates to:
  /// **'テーマ'**
  String get settingsTheme;

  /// ホームの書き込みバーに手書きの説明を出すかの設定
  ///
  /// In ja, this message translates to:
  /// **'書き込みバーの説明'**
  String get settingsPostHint;

  /// No description provided for @settingsPostHintDescription.
  ///
  /// In ja, this message translates to:
  /// **'ホームの入力欄とペンに、手書きの説明を添えます'**
  String get settingsPostHintDescription;

  /// No description provided for @settingsDiarySection.
  ///
  /// In ja, this message translates to:
  /// **'日記'**
  String get settingsDiarySection;

  /// No description provided for @settingsDayStart.
  ///
  /// In ja, this message translates to:
  /// **'日付の切り替わり'**
  String get settingsDayStart;

  /// No description provided for @settingsDayStartDescription.
  ///
  /// In ja, this message translates to:
  /// **'これより前に書いた記録や日記は前日の分になります'**
  String get settingsDayStartDescription;

  /// 日付が切り替わる朝の時刻
  ///
  /// In ja, this message translates to:
  /// **'朝{hour}:00'**
  String settingsDayStartValue(int hour);

  /// No description provided for @settingsOtherSection.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get settingsOtherSection;

  /// No description provided for @settingsFeedback.
  ///
  /// In ja, this message translates to:
  /// **'フィードバックを送る'**
  String get settingsFeedback;

  /// No description provided for @settingsVersion.
  ///
  /// In ja, this message translates to:
  /// **'バージョン'**
  String get settingsVersion;

  /// No description provided for @settingsAccountSection.
  ///
  /// In ja, this message translates to:
  /// **'アカウント'**
  String get settingsAccountSection;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを削除'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsEditProfile.
  ///
  /// In ja, this message translates to:
  /// **'プロフィールを編集'**
  String get settingsEditProfile;

  /// 設定のプロフィール行の読み上げ
  ///
  /// In ja, this message translates to:
  /// **'{name}、プロフィールを編集'**
  String settingsProfileTileSemantics(String name);

  /// No description provided for @themeModeSystem.
  ///
  /// In ja, this message translates to:
  /// **'端末に合わせる'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In ja, this message translates to:
  /// **'ライト'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In ja, this message translates to:
  /// **'ダーク'**
  String get themeModeDark;

  /// No description provided for @layoutList.
  ///
  /// In ja, this message translates to:
  /// **'リスト'**
  String get layoutList;

  /// ホームの日記帳を表紙のグリッドで並べる選択肢
  ///
  /// In ja, this message translates to:
  /// **'表紙'**
  String get layoutCover;

  /// No description provided for @onboardingSaveNameFailed.
  ///
  /// In ja, this message translates to:
  /// **'名前を保存できませんでした。もう一度お試しください'**
  String get onboardingSaveNameFailed;

  /// No description provided for @onboardingNameTitle.
  ///
  /// In ja, this message translates to:
  /// **'なんて呼べばいい？'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameDescription.
  ///
  /// In ja, this message translates to:
  /// **'日記帳のメンバーに表示される名前です。あとから変えられます。'**
  String get onboardingNameDescription;

  /// No description provided for @onboardingAllowNotifications.
  ///
  /// In ja, this message translates to:
  /// **'通知を許可する'**
  String get onboardingAllowNotifications;

  /// No description provided for @onboardingLater.
  ///
  /// In ja, this message translates to:
  /// **'あとで'**
  String get onboardingLater;

  /// No description provided for @onboardingNext.
  ///
  /// In ja, this message translates to:
  /// **'次へ'**
  String get onboardingNext;

  /// No description provided for @notificationStepTitle.
  ///
  /// In ja, this message translates to:
  /// **'通知をオンにしよう'**
  String get notificationStepTitle;

  /// No description provided for @notificationStepDescription.
  ///
  /// In ja, this message translates to:
  /// **'日記帳のメンバーが記録や日記を書くと、お知らせが届きます。'**
  String get notificationStepDescription;

  /// 通知の見本に出す架空の人の名前
  ///
  /// In ja, this message translates to:
  /// **'はるか'**
  String get notificationStepSample1Name;

  /// 記録の通知の本文。Edge Function（notify-post）が送る文面と合わせる
  ///
  /// In ja, this message translates to:
  /// **'新しい記録を書いたよ'**
  String get notificationStepSample1Body;

  /// No description provided for @notificationStepSample1Time.
  ///
  /// In ja, this message translates to:
  /// **'たった今'**
  String get notificationStepSample1Time;

  /// 通知の見本に出す架空の人の名前
  ///
  /// In ja, this message translates to:
  /// **'そうた'**
  String get notificationStepSample2Name;

  /// 日記の通知の本文。Edge Function（notify-diary）が送る文面と合わせる
  ///
  /// In ja, this message translates to:
  /// **'日記を書いたよ'**
  String get notificationStepSample2Body;

  /// No description provided for @notificationStepSample2Time.
  ///
  /// In ja, this message translates to:
  /// **'5分前'**
  String get notificationStepSample2Time;

  /// No description provided for @notificationStepFootnote.
  ///
  /// In ja, this message translates to:
  /// **'通知はあとから端末の設定で変えられます。'**
  String get notificationStepFootnote;

  /// No description provided for @feedbackTitle.
  ///
  /// In ja, this message translates to:
  /// **'フィードバック'**
  String get feedbackTitle;

  /// フィードバックのページの右上のボタン
  ///
  /// In ja, this message translates to:
  /// **'送信'**
  String get feedbackSend;

  /// No description provided for @feedbackDescription.
  ///
  /// In ja, this message translates to:
  /// **'使ってみた感想や、困ったこと、ほしい機能を教えてください。いただいた内容はアプリの改善に使います。返信はできません。'**
  String get feedbackDescription;

  /// No description provided for @feedbackHint.
  ///
  /// In ja, this message translates to:
  /// **'ご意見・ご要望を入力'**
  String get feedbackHint;

  /// No description provided for @feedbackSendFailed.
  ///
  /// In ja, this message translates to:
  /// **'送信できませんでした。もう一度お試しください'**
  String get feedbackSendFailed;

  /// No description provided for @feedbackSent.
  ///
  /// In ja, this message translates to:
  /// **'フィードバックを送りました。ありがとうございます'**
  String get feedbackSent;

  /// No description provided for @profileEditTitle.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール'**
  String get profileEditTitle;

  /// No description provided for @profileEditSave.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get profileEditSave;

  /// No description provided for @profileEditSaveFailed.
  ///
  /// In ja, this message translates to:
  /// **'プロフィールを保存できませんでした。もう一度お試しください'**
  String get profileEditSaveFailed;

  /// No description provided for @profileEditSaved.
  ///
  /// In ja, this message translates to:
  /// **'プロフィールを保存しました'**
  String get profileEditSaved;

  /// No description provided for @profileEditNameRequired.
  ///
  /// In ja, this message translates to:
  /// **'名前を入力してください'**
  String get profileEditNameRequired;

  /// No description provided for @welcomeSignInFailed.
  ///
  /// In ja, this message translates to:
  /// **'サインインできませんでした。もう一度お試しください'**
  String get welcomeSignInFailed;

  /// No description provided for @welcomeTagline.
  ///
  /// In ja, this message translates to:
  /// **'交換日記みたいに、みんなで\n1日の日記を共有しよう'**
  String get welcomeTagline;

  /// No description provided for @welcomeSigningIn.
  ///
  /// In ja, this message translates to:
  /// **'サインイン中…'**
  String get welcomeSigningIn;

  /// No description provided for @welcomeSignInWithApple.
  ///
  /// In ja, this message translates to:
  /// **'Appleでサインイン'**
  String get welcomeSignInWithApple;

  /// No description provided for @welcomeTryAnonymously.
  ///
  /// In ja, this message translates to:
  /// **'匿名で試す（開発用）'**
  String get welcomeTryAnonymously;

  /// 同意文のうち、利用規約のリンクの前
  ///
  /// In ja, this message translates to:
  /// **'続けると、'**
  String get welcomeAgreementPrefix;

  /// 同意文のうち、利用規約とプライバシーポリシーのリンクの間
  ///
  /// In ja, this message translates to:
  /// **'と'**
  String get welcomeAgreementConjunction;

  /// 同意文のうち、プライバシーポリシーのリンクの後
  ///
  /// In ja, this message translates to:
  /// **'に\n同意したことになります'**
  String get welcomeAgreementSuffix;

  /// No description provided for @splashLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'読み込めませんでした'**
  String get splashLoadFailed;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In ja, this message translates to:
  /// **'アップデートしてください'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In ja, this message translates to:
  /// **'新しいバージョンが出ています。\nこのまま使うには、アップデートが必要です。'**
  String get updateRequiredMessage;

  /// No description provided for @updateOptionalTitle.
  ///
  /// In ja, this message translates to:
  /// **'新しいバージョンがあります'**
  String get updateOptionalTitle;

  /// No description provided for @updateOptionalMessage.
  ///
  /// In ja, this message translates to:
  /// **'アップデートすると、新しい機能や改善を使えます。'**
  String get updateOptionalMessage;

  /// No description provided for @updateNow.
  ///
  /// In ja, this message translates to:
  /// **'アップデート'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In ja, this message translates to:
  /// **'あとで'**
  String get updateLater;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
