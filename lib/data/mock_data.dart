class DiaryBook {
  const DiaryBook({
    required this.id,
    required this.name,
    required this.icon,
    required this.members,
    required this.inviteCode,
    this.coverColor,
  });

  final String id;
  final String name;

  /// アイコンに表示する1文字。
  final String icon;

  /// 日記帳の表紙の色（0xAARRGGBB）。null なら決まったグレーにする。
  final int? coverColor;
  final List<String> members;

  /// 友達をこの日記帳に招待するためのコード。受け取った人が入力すると参加できる。
  final String inviteCode;
}

const me = '彩人';

/// 起動時に参加している日記帳。
const initialMockDiaryBooks = [
  DiaryBook(
    id: 'university',
    name: '大学',
    icon: '大',
    members: ['彩人', 'さき', 'ゆう', 'りな', 'けんと'],
    inviteCode: 'UNI482',
    coverColor: 0xFF2F3E5C,
  ),
  DiaryBook(
    id: 'company',
    name: '会社',
    icon: '社',
    members: ['彩人', 'たくみ', 'みお', 'はると', 'そうた', 'あおい', 'れん', 'ひな'],
    inviteCode: 'WRK731',
    coverColor: 0xFF3F5E4A,
  ),
  DiaryBook(
    id: 'high_school',
    name: '高校',
    icon: '高',
    members: ['彩人', 'ゆう', 'たくみ', 'こはる'],
    inviteCode: 'HSC905',
    coverColor: 0xFFA9533F,
  ),
];
