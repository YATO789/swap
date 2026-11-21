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

  /// No description provided for @commonSaySomething.
  ///
  /// In ja, this message translates to:
  /// **'ひとこと'**
  String get commonSaySomething;

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

  /// 友達に送る招待メッセージ。参加するシートは最後に見つかったコードを使うので、コードは必ず最後に置く。url はアプリを入れていない友達のための App Store のページ
  ///
  /// In ja, this message translates to:
  /// **'Swap!で「{name}」に参加しよう！\n\nアプリはこちら\n{url}\n\nアプリの「招待コードで参加」から、このコードを入力してね\n\n【招待コード】\n{code}'**
  String inviteSheetMessage(String name, String url, String code);

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

  /// No description provided for @inviteSheetDecorate.
  ///
  /// In ja, this message translates to:
  /// **'表紙をデコる'**
  String get inviteSheetDecorate;

  /// 日記帳を作った直後の招待シートで、飾った表紙の見本の横に出す文
  ///
  /// In ja, this message translates to:
  /// **'絵文字や文字、らくがきで、表紙を自分たちらしくデコれます'**
  String get inviteSheetDecorateMessage;

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

  /// No description provided for @trackAttach.
  ///
  /// In ja, this message translates to:
  /// **'曲をつける'**
  String get trackAttach;

  /// No description provided for @trackRemove.
  ///
  /// In ja, this message translates to:
  /// **'曲を外す'**
  String get trackRemove;

  /// No description provided for @trackAttachedLabel.
  ///
  /// In ja, this message translates to:
  /// **'つけた曲：{title}、{artist}。押すと選び直せます'**
  String trackAttachedLabel(String title, String artist);

  /// No description provided for @trackPlay.
  ///
  /// In ja, this message translates to:
  /// **'{title}の試聴を再生'**
  String trackPlay(String title);

  /// No description provided for @trackStopPreview.
  ///
  /// In ja, this message translates to:
  /// **'{title}の試聴を止める'**
  String trackStopPreview(String title);

  /// No description provided for @trackPreviewFailed.
  ///
  /// In ja, this message translates to:
  /// **'試聴を再生できませんでした。もう一度お試しください'**
  String get trackPreviewFailed;

  /// No description provided for @trackOpenInStore.
  ///
  /// In ja, this message translates to:
  /// **'{title}を Apple Music で開く'**
  String trackOpenInStore(String title);

  /// No description provided for @trackOpenFailed.
  ///
  /// In ja, this message translates to:
  /// **'Apple Music を開けませんでした'**
  String get trackOpenFailed;

  /// No description provided for @trackSearchHint.
  ///
  /// In ja, this message translates to:
  /// **'曲名・アーティスト名'**
  String get trackSearchHint;

  /// No description provided for @trackSearchClear.
  ///
  /// In ja, this message translates to:
  /// **'消す'**
  String get trackSearchClear;

  /// No description provided for @trackSearchEmpty.
  ///
  /// In ja, this message translates to:
  /// **'曲名やアーティスト名で探せます'**
  String get trackSearchEmpty;

  /// No description provided for @trackSelect.
  ///
  /// In ja, this message translates to:
  /// **'{title}をつける'**
  String trackSelect(String title);

  /// No description provided for @trackSearchNoResults.
  ///
  /// In ja, this message translates to:
  /// **'「{query}」に合う曲は見つかりませんでした'**
  String trackSearchNoResults(String query);

  /// No description provided for @trackSearchFailed.
  ///
  /// In ja, this message translates to:
  /// **'曲を探せませんでした。もう一度お試しください'**
  String get trackSearchFailed;

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

  /// No description provided for @homeMenuInfo.
  ///
  /// In ja, this message translates to:
  /// **'日記帳の情報'**
  String get homeMenuInfo;

  /// No description provided for @homeMenuInvite.
  ///
  /// In ja, this message translates to:
  /// **'友達を招待する'**
  String get homeMenuInvite;

  /// No description provided for @homeMenuDecorate.
  ///
  /// In ja, this message translates to:
  /// **'表紙をデコる'**
  String get homeMenuDecorate;

  /// No description provided for @homeDiaryBookLongPressHint.
  ///
  /// In ja, this message translates to:
  /// **'メニューを開く'**
  String get homeDiaryBookLongPressHint;

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

  /// No description provided for @diaryBookReactionFailed.
  ///
  /// In ja, this message translates to:
  /// **'リアクションを保存できませんでした。もう一度お試しください'**
  String get diaryBookReactionFailed;

  /// 記録の「反応する」ボタンの読み上げの先頭
  ///
  /// In ja, this message translates to:
  /// **'リアクションとコメント'**
  String get respondLabel;

  /// 「反応する」ボタンの読み上げに添える、今付けている絵文字
  ///
  /// In ja, this message translates to:
  /// **'自分のリアクションは{emoji}'**
  String respondMyReaction(String emoji);

  /// 「反応する」ボタンの読み上げに添える、付いているコメントの数
  ///
  /// In ja, this message translates to:
  /// **'{count, plural, other{コメント{count}件}}'**
  String respondCommentCount(int count);

  /// 「反応する」ボタンの読み上げをつなぐ区切り
  ///
  /// In ja, this message translates to:
  /// **'。'**
  String get respondLabelSeparator;

  /// No description provided for @commentHintMine.
  ///
  /// In ja, this message translates to:
  /// **'コメントを書く'**
  String get commentHintMine;

  /// ほかの人の記録にコメントするときの入力欄のヒント。name は記録を書いた人の名前
  ///
  /// In ja, this message translates to:
  /// **'{name}にコメント'**
  String commentHintTo(String name);

  /// No description provided for @commentSend.
  ///
  /// In ja, this message translates to:
  /// **'送る'**
  String get commentSend;

  /// No description provided for @commentSendFailed.
  ///
  /// In ja, this message translates to:
  /// **'コメントを送れませんでした。もう一度お試しください'**
  String get commentSendFailed;

  /// No description provided for @commentDeleteTitle.
  ///
  /// In ja, this message translates to:
  /// **'コメントを削除しますか？'**
  String get commentDeleteTitle;

  /// No description provided for @commentDeleteFailed.
  ///
  /// In ja, this message translates to:
  /// **'コメントを削除できませんでした。もう一度お試しください'**
  String get commentDeleteFailed;

  /// No description provided for @reactionAdd.
  ///
  /// In ja, this message translates to:
  /// **'リアクションを付ける'**
  String get reactionAdd;

  /// もうリアクションを付けた記録のハートボタンの読み上げ。emoji は今付けている絵文字
  ///
  /// In ja, this message translates to:
  /// **'リアクションを変える。今は{emoji}'**
  String reactionChange(String emoji);

  /// 絵文字の吹き出しで、今付けている絵文字のボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'{emoji} を取り消す'**
  String reactionUndo(String emoji);

  /// No description provided for @reactionMoreEmojis.
  ///
  /// In ja, this message translates to:
  /// **'ほかの絵文字'**
  String get reactionMoreEmojis;

  /// No description provided for @reactionYou.
  ///
  /// In ja, this message translates to:
  /// **'あなた'**
  String get reactionYou;

  /// リアクションを付けた人の名前を並べるときの区切り
  ///
  /// In ja, this message translates to:
  /// **'、'**
  String get reactionNameSeparator;

  /// リアクションのチップの読み上げ。names は付けた人の名前を並べたもの
  ///
  /// In ja, this message translates to:
  /// **'{names}が{emoji}'**
  String reactionChipLabel(String names, String emoji);

  /// 今の時間の欄の見出し。time は「14:00」
  ///
  /// In ja, this message translates to:
  /// **'{time} ・ いま'**
  String timelineNowHour(String time);

  /// 今の時間にまだ記録していない人が1人のとき
  ///
  /// In ja, this message translates to:
  /// **'{name}はまだ'**
  String timelinePendingOne(String name);

  /// 今の時間にまだ記録していない人が2人のとき
  ///
  /// In ja, this message translates to:
  /// **'{first}・{second}はまだ'**
  String timelinePendingTwo(String first, String second);

  /// 今の時間にまだ記録していない人が3人以上のとき。rest は名前を出さなかった人数
  ///
  /// In ja, this message translates to:
  /// **'{first}・{second} ほか{rest}人はまだ'**
  String timelinePendingMany(String first, String second, int rest);

  /// No description provided for @timelineBlankTitle.
  ///
  /// In ja, this message translates to:
  /// **'今日のページはまだ白紙です'**
  String get timelineBlankTitle;

  /// No description provided for @timelineBlankMessage.
  ///
  /// In ja, this message translates to:
  /// **'最初に書いた人の一言から、今日が始まります'**
  String get timelineBlankMessage;

  /// No description provided for @diarySectionUntitled.
  ///
  /// In ja, this message translates to:
  /// **'タイトルなし'**
  String get diarySectionUntitled;

  /// No description provided for @diarySectionLockedPast.
  ///
  /// In ja, this message translates to:
  /// **'この日に日記を書いていないので読めません'**
  String get diarySectionLockedPast;

  /// No description provided for @diarySectionLockedToday.
  ///
  /// In ja, this message translates to:
  /// **'今日の日記を書くと読めます'**
  String get diarySectionLockedToday;

  /// No description provided for @diarySectionLockedYesterday.
  ///
  /// In ja, this message translates to:
  /// **'昨日の日記を書くと読めます'**
  String get diarySectionLockedYesterday;

  /// 読めない日記のカードの読み上げ。time は書いた時刻、title はタイトル（なければ「タイトルなし」）、hint は読めるようにする方法
  ///
  /// In ja, this message translates to:
  /// **'{name}の日記（{time}）。{title}。本文はまだ読めません。{hint}'**
  String diarySectionLockedSemantics(
    String name,
    String time,
    String title,
    String hint,
  );

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

  /// No description provided for @diaryDetailReactionFailed.
  ///
  /// In ja, this message translates to:
  /// **'リアクションを保存できませんでした。もう一度お試しください'**
  String get diaryDetailReactionFailed;

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

  /// 日記帳の情報の、表紙の下の名前の入力欄が空のときに出す文
  ///
  /// In ja, this message translates to:
  /// **'日記帳の名前'**
  String get infoNameHint;

  /// No description provided for @infoRenameFailed.
  ///
  /// In ja, this message translates to:
  /// **'名前を変えられませんでした。もう一度お試しください'**
  String get infoRenameFailed;

  /// 日記帳の情報ページで名前を変えられたときのメッセージ
  ///
  /// In ja, this message translates to:
  /// **'名前を保存しました'**
  String get infoRenamed;

  /// 日記帳の名前の入力欄の右の、名前を保存するボタン
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get infoNameSave;

  /// 日記帳の名前を書いているか書き換えたままのあいだ、入力欄の下に出す、保存のしかたの説明
  ///
  /// In ja, this message translates to:
  /// **'「保存」か「完了」を押すと保存します'**
  String get infoNameSaveHelper;

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

  /// 一番上の大きな表紙のボタンの読み上げ。name は日記帳の名前
  ///
  /// In ja, this message translates to:
  /// **'{name}の表紙、表紙を編集'**
  String infoEditCoverSemantics(String name);

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
  /// **'どの日記帳に投稿しますか？'**
  String get editorPickerTitle;

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

  /// No description provided for @editorOverwriteTitle.
  ///
  /// In ja, this message translates to:
  /// **'上書きしますか？'**
  String get editorOverwriteTitle;

  /// names はもう書いてある日記帳の名前を「」で囲んで並べたもの。day は today か yesterday
  ///
  /// In ja, this message translates to:
  /// **'{names}の{day, select, today{今日} other{昨日}}の日記は、この内容で上書きされます。'**
  String editorOverwriteMessage(String names, String day);

  /// No description provided for @editorOverwriteConfirm.
  ///
  /// In ja, this message translates to:
  /// **'上書きする'**
  String get editorOverwriteConfirm;

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

  /// No description provided for @editorAddPhoto.
  ///
  /// In ja, this message translates to:
  /// **'写真を付ける'**
  String get editorAddPhoto;

  /// No description provided for @editorRemovePhoto.
  ///
  /// In ja, this message translates to:
  /// **'写真を外す'**
  String get editorRemovePhoto;

  /// No description provided for @editorPickPhotoFailed.
  ///
  /// In ja, this message translates to:
  /// **'写真を読み込めませんでした'**
  String get editorPickPhotoFailed;

  /// 日記に付けた写真の読み上げ
  ///
  /// In ja, this message translates to:
  /// **'日記の写真'**
  String get diaryPhotoSemantics;

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

  /// ホームの日記帳の表紙を横2列に並べる選択肢
  ///
  /// In ja, this message translates to:
  /// **'並べる'**
  String get layoutGrid;

  /// ホームの日記帳を1冊ずつ画面いっぱいに出し、縦にスワイプして切り替える選択肢
  ///
  /// In ja, this message translates to:
  /// **'1冊ずつ'**
  String get layoutPaged;

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

  /// プロフィール編集のアイコンを押したときの読み上げ
  ///
  /// In ja, this message translates to:
  /// **'アイコンを変える'**
  String get profileEditChangeAvatar;

  /// No description provided for @profileEditPickAvatar.
  ///
  /// In ja, this message translates to:
  /// **'写真を選ぶ'**
  String get profileEditPickAvatar;

  /// No description provided for @profileEditRemoveAvatar.
  ///
  /// In ja, this message translates to:
  /// **'写真を外す'**
  String get profileEditRemoveAvatar;

  /// No description provided for @profileEditPickAvatarFailed.
  ///
  /// In ja, this message translates to:
  /// **'写真を読み込めませんでした'**
  String get profileEditPickAvatarFailed;

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
  /// **'アップデートのお願い'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In ja, this message translates to:
  /// **'このまま使うには、アップデートが必要です。'**
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

  /// No description provided for @updateReleaseNotesTitle.
  ///
  /// In ja, this message translates to:
  /// **'バージョン {version} で変わったこと'**
  String updateReleaseNotesTitle(String version);

  /// No description provided for @coverEditTitle.
  ///
  /// In ja, this message translates to:
  /// **'表紙を編集'**
  String get coverEditTitle;

  /// No description provided for @coverEditUndo.
  ///
  /// In ja, this message translates to:
  /// **'元に戻す'**
  String get coverEditUndo;

  /// 表紙の編集ページの、元に戻した操作をもう一度するボタン
  ///
  /// In ja, this message translates to:
  /// **'やり直す'**
  String get coverEditRedo;

  /// 表紙の編集ページの、絵文字を貼るボタン
  ///
  /// In ja, this message translates to:
  /// **'絵文字'**
  String get coverEditEmoji;

  /// 表紙の編集ページの、文字を置くボタン
  ///
  /// In ja, this message translates to:
  /// **'文字'**
  String get coverEditText;

  /// 表紙の編集ページの、らくがきを始めるボタン
  ///
  /// In ja, this message translates to:
  /// **'らくがき'**
  String get coverEditDoodle;

  /// 表紙の編集ページの、表紙の色を選ぶボタン
  ///
  /// In ja, this message translates to:
  /// **'色'**
  String get coverEditColor;

  /// らくがきや色を選ぶのを終えるボタン
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get coverEditDone;

  /// 選んだものを1つ上の重なりへ移すボタン
  ///
  /// In ja, this message translates to:
  /// **'前へ'**
  String get coverEditBringForward;

  /// 選んだものを1つ下の重なりへ移すボタン
  ///
  /// In ja, this message translates to:
  /// **'うしろへ'**
  String get coverEditSendBackward;

  /// No description provided for @coverEditFrame.
  ///
  /// In ja, this message translates to:
  /// **'白いふち'**
  String get coverEditFrame;

  /// 選んだものを表紙から外すボタン
  ///
  /// In ja, this message translates to:
  /// **'消す'**
  String get coverEditRemove;

  /// No description provided for @coverEditHint.
  ///
  /// In ja, this message translates to:
  /// **'貼ったものはドラッグで動かし、右下のつまみか2本指で回転と拡大縮小。文字は選んでもう一度押すと書き換えられます。'**
  String get coverEditHint;

  /// No description provided for @coverEditStickerLimit.
  ///
  /// In ja, this message translates to:
  /// **'貼れるのは{count}個までです'**
  String coverEditStickerLimit(int count);

  /// No description provided for @coverEditTextLimit.
  ///
  /// In ja, this message translates to:
  /// **'文字は{count}個まで置けます'**
  String coverEditTextLimit(int count);

  /// 選んだ文字を書き換えるボタン
  ///
  /// In ja, this message translates to:
  /// **'書き換える'**
  String get coverEditRewrite;

  /// 文字の色を表紙の色に合わせる丸の中に出す字。とても小さい丸なので短くする
  ///
  /// In ja, this message translates to:
  /// **'自動'**
  String get coverEditTextColorAuto;

  /// 文字の色を表紙の色に合わせる丸の読み上げに使う名前
  ///
  /// In ja, this message translates to:
  /// **'表紙に合わせる'**
  String get coverEditTextColorAutoName;

  /// color は色の名前
  ///
  /// In ja, this message translates to:
  /// **'文字の色 {color}'**
  String coverEditTextColorSemantics(String color);

  /// 文字・ペン・表紙の色の並びにある、色のパレットを開く虹色の丸の読み上げ
  ///
  /// In ja, this message translates to:
  /// **'ほかの色を選ぶ'**
  String get colorPaletteOpen;

  /// パレットの色の読み上げ。color は #RRGGBB
  ///
  /// In ja, this message translates to:
  /// **'色 {color}'**
  String colorPaletteSemantics(String color);

  /// 文字の色を選ぶパレットのシートの題名
  ///
  /// In ja, this message translates to:
  /// **'文字の色'**
  String get colorPaletteTextTitle;

  /// らくがきのペンの色を選ぶパレットのシートの題名
  ///
  /// In ja, this message translates to:
  /// **'ペンの色'**
  String get colorPalettePenTitle;

  /// 表紙の色を選ぶパレットのシートの題名
  ///
  /// In ja, this message translates to:
  /// **'表紙の色'**
  String get colorPaletteCoverTitle;

  /// No description provided for @coverEditStrokeLimit.
  ///
  /// In ja, this message translates to:
  /// **'これ以上描けません。消しゴムで消すと描けます'**
  String get coverEditStrokeLimit;

  /// No description provided for @coverEditPenExtraThin.
  ///
  /// In ja, this message translates to:
  /// **'極細のペン'**
  String get coverEditPenExtraThin;

  /// No description provided for @coverEditPenThin.
  ///
  /// In ja, this message translates to:
  /// **'細いペン'**
  String get coverEditPenThin;

  /// No description provided for @coverEditPenMedium.
  ///
  /// In ja, this message translates to:
  /// **'ふつうのペン'**
  String get coverEditPenMedium;

  /// No description provided for @coverEditPenThick.
  ///
  /// In ja, this message translates to:
  /// **'太いペン'**
  String get coverEditPenThick;

  /// No description provided for @coverEditEraser.
  ///
  /// In ja, this message translates to:
  /// **'消しゴム'**
  String get coverEditEraser;

  /// No description provided for @coverEditPenBlack.
  ///
  /// In ja, this message translates to:
  /// **'黒'**
  String get coverEditPenBlack;

  /// No description provided for @coverEditPenWhite.
  ///
  /// In ja, this message translates to:
  /// **'白'**
  String get coverEditPenWhite;

  /// No description provided for @coverEditPenRed.
  ///
  /// In ja, this message translates to:
  /// **'赤'**
  String get coverEditPenRed;

  /// No description provided for @coverEditPenOrange.
  ///
  /// In ja, this message translates to:
  /// **'オレンジ'**
  String get coverEditPenOrange;

  /// No description provided for @coverEditPenGreen.
  ///
  /// In ja, this message translates to:
  /// **'緑'**
  String get coverEditPenGreen;

  /// No description provided for @coverEditPenBlue.
  ///
  /// In ja, this message translates to:
  /// **'青'**
  String get coverEditPenBlue;

  /// No description provided for @coverEditPenPink.
  ///
  /// In ja, this message translates to:
  /// **'ピンク'**
  String get coverEditPenPink;

  /// No description provided for @coverEditKnob.
  ///
  /// In ja, this message translates to:
  /// **'回転と拡大縮小'**
  String get coverEditKnob;

  /// No description provided for @coverEditStickerSemantics.
  ///
  /// In ja, this message translates to:
  /// **'貼った絵文字 {emoji}'**
  String coverEditStickerSemantics(String emoji);

  /// 表紙に貼った日記帳の名前の読み上げ。name は日記帳の名前
  ///
  /// In ja, this message translates to:
  /// **'表紙の名前 {name}'**
  String coverEditNameSemantics(String name);

  /// No description provided for @coverEditTextSemantics.
  ///
  /// In ja, this message translates to:
  /// **'置いた文字 {text}'**
  String coverEditTextSemantics(String text);

  /// No description provided for @coverTextSheetTitle.
  ///
  /// In ja, this message translates to:
  /// **'表紙に文字を置く'**
  String get coverTextSheetTitle;

  /// No description provided for @coverTextSheetEditTitle.
  ///
  /// In ja, this message translates to:
  /// **'文字を書き換える'**
  String get coverTextSheetEditTitle;

  /// No description provided for @coverTextSheetHint.
  ///
  /// In ja, this message translates to:
  /// **'表紙に入れる文字'**
  String get coverTextSheetHint;

  /// 表紙に文字を置くシートの決定ボタン
  ///
  /// In ja, this message translates to:
  /// **'置く'**
  String get coverTextSheetPlace;

  /// 表紙から外した日記帳の名前を、もう一度表紙に置くボタン
  ///
  /// In ja, this message translates to:
  /// **'日記帳の名前を置く'**
  String get coverTextSheetPlaceName;

  /// No description provided for @coverEditDoodleArea.
  ///
  /// In ja, this message translates to:
  /// **'らくがきをする場所。表紙をなぞって線を描き、2本指で拡大する'**
  String get coverEditDoodleArea;

  /// 表紙の編集ページで、らくがきのために拡大した表紙を元の大きさに戻すボタン
  ///
  /// In ja, this message translates to:
  /// **'等倍に戻す'**
  String get coverEditResetZoom;

  /// No description provided for @coverEditSaved.
  ///
  /// In ja, this message translates to:
  /// **'表紙を保存しました'**
  String get coverEditSaved;

  /// No description provided for @coverEditSaveFailed.
  ///
  /// In ja, this message translates to:
  /// **'保存できませんでした。もう一度お試しください'**
  String get coverEditSaveFailed;

  /// No description provided for @coverEditNeedsUpdate.
  ///
  /// In ja, this message translates to:
  /// **'表紙を編集するには、アプリをアップデートしてください'**
  String get coverEditNeedsUpdate;

  /// No description provided for @emojiSheetTitle.
  ///
  /// In ja, this message translates to:
  /// **'絵文字を選ぶ'**
  String get emojiSheetTitle;

  /// 最近使った絵文字がないときの文
  ///
  /// In ja, this message translates to:
  /// **'まだありません'**
  String get emojiSheetNoRecents;

  /// No description provided for @emojiSheetSearch.
  ///
  /// In ja, this message translates to:
  /// **'絵文字を検索'**
  String get emojiSheetSearch;

  /// No description provided for @settingsDiaryReminder.
  ///
  /// In ja, this message translates to:
  /// **'日記のリマインダー'**
  String get settingsDiaryReminder;

  /// No description provided for @settingsDiaryReminderDescription.
  ///
  /// In ja, this message translates to:
  /// **'毎日この時刻に、日記を書くよう知らせます。今日の日記を書いた日は知らせません'**
  String get settingsDiaryReminderDescription;

  /// No description provided for @settingsDiaryReminderTime.
  ///
  /// In ja, this message translates to:
  /// **'知らせる時刻'**
  String get settingsDiaryReminderTime;

  /// No description provided for @settingsNotificationDenied.
  ///
  /// In ja, this message translates to:
  /// **'通知がオフになっています。端末の設定で通知を許可してください'**
  String get settingsNotificationDenied;

  /// No description provided for @settingsOpenDeviceSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定を開く'**
  String get settingsOpenDeviceSettings;

  /// 毎日決まった時刻に出す、日記を書くよう知らせる通知の本文
  ///
  /// In ja, this message translates to:
  /// **'今日はどんな一日だった？日記を書こう'**
  String get diaryReminderBody;
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
