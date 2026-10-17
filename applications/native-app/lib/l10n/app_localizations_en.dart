// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonOpenLinkFailed => 'Couldn\'t open the page';

  @override
  String get commonToday => 'Today';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get commonName => 'Name';

  @override
  String get commonEnterName => 'Enter a name';

  @override
  String get commonFormerMember => 'Former member';

  @override
  String get commonNoPostsThisDay => 'No posts on this day';

  @override
  String get commonInviteCode => 'Invite code';

  @override
  String get commonJoinWithInviteCode => 'Join with invite code';

  @override
  String get commonCreateDiaryBook => 'Create a diary book';

  @override
  String get commonDiaryBookInfo => 'Diary book info';

  @override
  String get commonDiaryBookNameHint => 'Enter a diary book name';

  @override
  String get commonDiaryBookUnavailable => 'This diary book can\'t be shown';

  @override
  String get commonWriteDiary => 'Write diary';

  @override
  String get commonPost => 'Post';

  @override
  String get commonWhatAreYouDoing => 'What are you up to?';

  @override
  String get commonTermsOfService => 'Terms of Service';

  @override
  String get commonPrivacyPolicy => 'Privacy Policy';

  @override
  String commonMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String commonDiaryOfDate(String date) {
    return 'Diary for $date';
  }

  @override
  String commonTodayWithDate(String date) {
    return 'Today · $date';
  }

  @override
  String get postHintShare => 'Share a moment';

  @override
  String get postHintDiary => 'Diary here!';

  @override
  String get confirmSheetIrreversible => 'This can\'t be undone';

  @override
  String get discardGuardTitle => 'Discard your changes?';

  @override
  String get discardGuardMessage => 'Anything you haven\'t saved will be lost.';

  @override
  String get discardGuardKeepEditing => 'Keep editing';

  @override
  String get discardGuardDiscard => 'Discard';

  @override
  String inviteSheetMessage(String name, String code) {
    return 'Join “$name” on Swap!\nIn the app, tap “Join with invite code” and enter this code.\nInvite code: $code';
  }

  @override
  String get inviteSheetCopied => 'Invite message copied';

  @override
  String inviteSheetCreatedTitle(String name) {
    return 'Created “$name”';
  }

  @override
  String inviteSheetTitle(String name) {
    return 'Invite to “$name”';
  }

  @override
  String get inviteSheetCreatedDescription =>
      'Invite friends to share posts and diaries. Send them the invite code, and they can join by entering it.';

  @override
  String get inviteSheetDescription =>
      'Send the invite code, and your friends can join by entering it.';

  @override
  String inviteSheetCodeSemantics(String code) {
    return 'Invite code $code';
  }

  @override
  String get inviteSheetCopy => 'Copy invite message';

  @override
  String get inviteSheetLater => 'Invite later';

  @override
  String get postSheetFailed => 'Couldn\'t post. Please try again.';

  @override
  String get postSheetPosted => 'Posted';

  @override
  String postSheetPostingTo(String name) {
    return 'Posting to $name';
  }

  @override
  String get postSheetShareTo => 'Share to';

  @override
  String get postButtonWriteToday => 'Write today\'s diary';

  @override
  String get postButtonWriteYesterday => 'Write yesterday\'s diary';

  @override
  String get coverColorLabel => 'Cover color';

  @override
  String get homeRefreshFailed =>
      'Couldn\'t load diary books. Please try again.';

  @override
  String get homeAddDiaryBook => 'Add diary book';

  @override
  String get homeProfileAndSettings => 'Profile and settings';

  @override
  String get homeLoadFailed => 'Couldn\'t load diary books';

  @override
  String homeDiaryBookSemantics(String name, String memberCount) {
    return '$name, $memberCount';
  }

  @override
  String get addDiaryBookCreateDescription =>
      'Start a new diary book and invite friends';

  @override
  String get addDiaryBookJoinDescription =>
      'Join a diary book with a code from a friend';

  @override
  String get emptyDiaryBooksTitle => 'Create your\nfirst diary book';

  @override
  String get emptyDiaryBooksMessage =>
      'Pass one notebook around with friends\nand swap what happens each day.';

  @override
  String get joinSheetCheckFailed =>
      'Couldn\'t check the code. Please try again.';

  @override
  String get joinSheetCodeNotFound => 'Invite code not found';

  @override
  String get joinSheetJoinFailed => 'Couldn\'t join. Please try again.';

  @override
  String joinSheetDescription(int length) {
    return 'Enter the $length-character code from your friend';
  }

  @override
  String get joinSheetPaste => 'Paste';

  @override
  String get joinSheetCheck => 'Check';

  @override
  String get joinSheetOpen => 'Open diary book';

  @override
  String get joinSheetJoin => 'Join this diary book';

  @override
  String get joinSheetAlreadyJoined => 'You\'ve already joined this diary book';

  @override
  String joinSheetFull(int limit) {
    return 'This diary book is full (up to $limit members)';
  }

  @override
  String joinSheetSpotsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more people can join',
      one: '1 more person can join',
    );
    return '$_temp0';
  }

  @override
  String joinSheetMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String diaryBookNoLongerAvailableTitle(String name) {
    return '“$name” is no longer available';
  }

  @override
  String get diaryBookNoLongerAvailableMessage =>
      'Posts and diaries in this diary book can\'t be shown.';

  @override
  String get diaryBookBackToHome => 'Back to home';

  @override
  String get diaryBookDeletePostTitle => 'Delete this post?';

  @override
  String get diaryBookDeletePostMessage =>
      'Copies shared to other diary books will stay.';

  @override
  String get diaryBookPostDeleted => 'Post deleted';

  @override
  String get diaryBookPostDeleteFailed =>
      'Couldn\'t delete the post. Please try again.';

  @override
  String get diaryBookPickDate => 'Pick a date';

  @override
  String get diaryBookLoadFailed => 'Couldn\'t load the diary book';

  @override
  String get timelineNoPostsYet => 'No posts yet';

  @override
  String get deletePostPickerTitle => 'Choose a post to delete';

  @override
  String get diarySectionUntitled => 'Untitled';

  @override
  String get diarySectionLockedPast =>
      'You can\'t read this because you didn\'t write a diary that day';

  @override
  String get diarySectionLockedToday =>
      'Write today\'s diary in this diary book to read it';

  @override
  String get diarySectionLockedYesterday =>
      'Write yesterday\'s diary in this diary book to read it';

  @override
  String diarySectionLockedSemantics(String name, String time, String hint) {
    return '$name\'s diary ($time). You can\'t read it yet. $hint';
  }

  @override
  String get calendarPreviousMonth => 'Previous month';

  @override
  String get calendarNextMonth => 'Next month';

  @override
  String get calendarHasDiary => 'Diary';

  @override
  String get calendarHasPost => 'Posts';

  @override
  String get calendarLabelSeparator => ', ';

  @override
  String get diaryDetailFallbackDiaryBookName => 'diary book';

  @override
  String get diaryDetailDeleteTitle => 'Delete this diary?';

  @override
  String diaryDetailDeleteMessage(String diaryBookName) {
    return 'This diary will be deleted from “$diaryBookName”.';
  }

  @override
  String get diaryDetailDeleteFailed =>
      'Couldn\'t delete the diary. Please try again.';

  @override
  String get diaryDetailDeleted => 'Diary deleted';

  @override
  String get diaryDetailMenu => 'Menu';

  @override
  String get diaryDetailEdit => 'Edit';

  @override
  String get diaryDetailDelete => 'Delete';

  @override
  String get diaryDetailPrevious => 'Previous diary';

  @override
  String get diaryDetailNext => 'Next diary';

  @override
  String get diaryDetailUnavailable => 'This diary can\'t be shown';

  @override
  String get diaryDetailLoadFailed => 'Couldn\'t load the diary';

  @override
  String diaryDetailWrittenAt(String time) {
    return 'Written at $time';
  }

  @override
  String get diaryDetailPostsOfDay => 'Posts from this day';

  @override
  String get infoRenameFailed => 'Couldn\'t change the name. Please try again.';

  @override
  String get infoCoverColorFailed =>
      'Couldn\'t change the cover color. Please try again.';

  @override
  String get infoMemberLimitFailed =>
      'Couldn\'t change the member limit. Please try again.';

  @override
  String get infoRegenerateInviteCodeTitle => 'Create a new invite code?';

  @override
  String infoRegenerateInviteCodeMessage(String code) {
    return 'The current code ($code) will no longer work. Current members will stay.';
  }

  @override
  String get infoRegenerateInviteCodeConfirm => 'Create new code';

  @override
  String get infoRegenerateInviteCodeFailed =>
      'Couldn\'t create a new invite code. Please try again.';

  @override
  String get infoInviteCodeRegenerated => 'Created a new invite code';

  @override
  String infoRemoveMemberTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get infoRemoveMemberMessage =>
      'They will no longer see posts or diary entries in this diary book. The invite code will also be renewed so they can\'t rejoin.';

  @override
  String get infoRemoveMemberConfirm => 'Remove';

  @override
  String get infoRemoveMemberFailed =>
      'Couldn\'t remove the member. Please try again.';

  @override
  String infoMemberRemoved(String name) {
    return 'Removed $name';
  }

  @override
  String infoLeaveTitle(String name) {
    return 'Leave “$name”?';
  }

  @override
  String get infoLeaveMessage =>
      'You will no longer see posts or diary entries in this diary book. You can rejoin with an invite code.';

  @override
  String get infoLeaveConfirm => 'Leave';

  @override
  String get infoLeaveFailed =>
      'Couldn\'t leave the diary book. Please try again.';

  @override
  String infoLeft(String name) {
    return 'Left “$name”';
  }

  @override
  String get infoCoverSection => 'Cover';

  @override
  String get infoRename => 'Change name';

  @override
  String get infoMembersSection => 'Who writes this diary';

  @override
  String get infoMemberLimit => 'Member limit';

  @override
  String get infoChangeMemberLimit => 'Change member limit';

  @override
  String infoMemberLimitValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Up to $count people',
      one: 'Up to 1 person',
    );
    return '$_temp0';
  }

  @override
  String get infoRegenerateInviteCode => 'Create new invite code';

  @override
  String get infoLeaveDiaryBook => 'Leave diary book';

  @override
  String infoRenameSemantics(String name) {
    return '$name, change name';
  }

  @override
  String get infoYou => 'You';

  @override
  String infoMemberMenu(String name) {
    return 'Menu for $name';
  }

  @override
  String get infoRemoveFromDiaryBook => 'Remove from this diary book';

  @override
  String infoInviteSemantics(String code) {
    return 'Invite friends, invite code $code';
  }

  @override
  String get infoInviteFriends => 'Invite friends';

  @override
  String get infoLoadFailed => 'Couldn\'t load diary book info';

  @override
  String get memberLimitTitle => 'Member limit';

  @override
  String get memberLimitCannotGoBelow =>
      'Can\'t be lower than the current number of members';

  @override
  String memberLimitFull(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Up to $count people',
      one: 'Up to 1 person',
    );
    return '$_temp0 · Full';
  }

  @override
  String memberLimitLeft(int count, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Up to $count people',
      one: 'Up to 1 person',
    );
    String _temp1 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: '$left spots left',
      one: '1 spot left',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get renameTitle => 'Diary book name';

  @override
  String get renameIconHelper => 'The first letter becomes the icon';

  @override
  String get createDiaryBookFailed =>
      'Couldn\'t create the diary book. Please try again.';

  @override
  String get createDiaryBookCreate => 'Create';

  @override
  String get createDiaryBookIconHint =>
      'The first letter of the name becomes the icon';

  @override
  String get editorLoadFailed => 'Couldn\'t load the diary';

  @override
  String get editorPickerTitle => 'Diary book to write in';

  @override
  String editorAllStatus(String day, int total, int written) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'today': 'Today\'s',
      'other': 'Yesterday\'s',
    });
    return '$_temp0 diary: written in $written of $total';
  }

  @override
  String editorStatusWritten(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'today': 'Today\'s',
      'other': 'Yesterday\'s',
    });
    return '$_temp0 diary: written';
  }

  @override
  String editorStatusNotYet(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'today': 'Today\'s',
      'other': 'Yesterday\'s',
    });
    return '$_temp0 diary: not yet';
  }

  @override
  String get editorSaveFailed => 'Couldn\'t save the diary. Please try again.';

  @override
  String get editorPosted => 'Diary posted';

  @override
  String get editorUpdated => 'Diary updated';

  @override
  String get editorPost => 'Post';

  @override
  String get editorUpdate => 'Update';

  @override
  String editorDayPosts(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'today': 'Today\'s posts',
      'other': 'Yesterday\'s posts',
    });
    return '$_temp0';
  }

  @override
  String get editorTitleHint => 'Title';

  @override
  String editorBodyHint(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'today': 'How was your day today?',
      'other': 'How was your day yesterday?',
    });
    return '$_temp0';
  }

  @override
  String get editorNoDiaryBook => 'Create a diary book to start writing';

  @override
  String editorDiaryBookSemantics(String name) {
    return 'Diary book to write in: $name';
  }

  @override
  String get editorChangeDiaryBook => 'Change diary book';

  @override
  String get diaryBookPickerAll => 'All diary books';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSignOutConfirmTitle => 'Log out?';

  @override
  String get settingsSignOut => 'Log out';

  @override
  String get settingsSignOutFailed => 'Couldn\'t log out. Please try again.';

  @override
  String get settingsDeleteAccountConfirmTitle => 'Delete your account?';

  @override
  String get settingsDeleteAccountConfirmMessage =>
      'Your profile, posts, and diary entries will all be deleted. You\'ll also leave your diary books, and any diary book with no other members will be deleted.';

  @override
  String get settingsDeleteAccountFailed =>
      'Couldn\'t delete your account. Please try again.';

  @override
  String get settingsHomeLayoutSection => 'Diary book layout on Home';

  @override
  String get settingsDisplaySection => 'Display';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsPostHint => 'Post bar hints';

  @override
  String get settingsPostHintDescription =>
      'Adds handwritten notes to the input field and pen on Home';

  @override
  String get settingsDiarySection => 'Diary';

  @override
  String get settingsDayStart => 'New day starts at';

  @override
  String get settingsDayStartDescription =>
      'Posts and diary entries written before this count toward the previous day';

  @override
  String settingsDayStartValue(int hour) {
    return '$hour:00 AM';
  }

  @override
  String get settingsOtherSection => 'Other';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsEditProfile => 'Edit profile';

  @override
  String settingsProfileTileSemantics(String name) {
    return '$name, edit profile';
  }

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get layoutList => 'List';

  @override
  String get layoutCover => 'Covers';

  @override
  String get onboardingSaveNameFailed =>
      'Couldn\'t save your name. Please try again.';

  @override
  String get onboardingNameTitle => 'What should we call you?';

  @override
  String get onboardingNameDescription =>
      'This name is shown to members of your diary books. You can change it later.';

  @override
  String get onboardingAllowNotifications => 'Allow notifications';

  @override
  String get onboardingLater => 'Later';

  @override
  String get onboardingNext => 'Next';

  @override
  String get notificationStepTitle => 'Turn on notifications';

  @override
  String get notificationStepDescription =>
      'You\'ll get a notification when a member of your diary book posts.';

  @override
  String get notificationStepSample1Name => 'Haruka';

  @override
  String get notificationStepSample1Body =>
      'Trying out the new café by the station ☕';

  @override
  String get notificationStepSample1Time => 'now';

  @override
  String get notificationStepSample2Name => 'Sota';

  @override
  String get notificationStepSample2Body => 'Finally finished my report!';

  @override
  String get notificationStepSample2Time => '5m ago';

  @override
  String get notificationStepFootnote =>
      'You can change notifications later in your device settings.';

  @override
  String get profileEditTitle => 'Profile';

  @override
  String get profileEditSave => 'Save';

  @override
  String get profileEditSaveFailed =>
      'Couldn\'t save your profile. Please try again.';

  @override
  String get profileEditSaved => 'Profile saved';

  @override
  String get profileEditNameRequired => 'Please enter a name';

  @override
  String get welcomeSignInFailed => 'Couldn\'t sign in. Please try again.';

  @override
  String get welcomeTagline =>
      'Share your day with friends,\nlike a shared diary';

  @override
  String get welcomeSigningIn => 'Signing in…';

  @override
  String get welcomeSignInWithApple => 'Sign in with Apple';

  @override
  String get welcomeTryAnonymously => 'Try anonymously (dev only)';

  @override
  String get welcomeAgreementPrefix => 'By continuing, you agree to our\n';

  @override
  String get welcomeAgreementConjunction => ' and ';

  @override
  String get welcomeAgreementSuffix => '.';

  @override
  String get splashLoadFailed => 'Couldn\'t load';
}
