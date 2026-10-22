import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swap/utils/local_date_time_converter.dart';

part '_generated/diary.freezed.dart';
part '_generated/diary.g.dart';

/// 1日の締めくくりに書く日記。日記帳と [date]（朝4時区切り）ごとに1人1つだけ。
@freezed
abstract class Diary with _$Diary {
  const Diary._();

  const factory Diary({
    required String id,
    required String authorId,
    /// どの日の日記か（年月日のみ）。朝4時区切りなので、深夜に書いたものは前日になる。
    required DateTime date,
    /// 実際に書いた時刻。端末の時計ではなくサーバーの時刻。
    @LocalDateTimeConverter() required DateTime writtenAt,

    /// タイトルと本文。まだ読めない日記（自分がその日に書いていない）なら null。
    String? title,
    String? body,
  }) = _Diary;

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);

  /// 本文が伏せてあるか。他の人の日記は、自分も同じ日記帳にその日の日記を書くと読める。
  bool get isLocked => body == null;
}

/// 日記のタイトルと本文の最大文字数。DB の diary_contents の制約と合わせる。
const maxDiaryTitleLength = 40;
const maxDiaryBodyLength = 1000;

/// 日記の日付が切り替わる時刻。これより前に書いたものは前日の日記として扱う。
const diaryDayStartHour = 4;

/// [time] がどの日の日記に当たるか（年月日のみ）を返す。
DateTime diaryDateOf(DateTime time) {
  final shifted = time.subtract(const Duration(hours: diaryDayStartHour));
  return DateTime(shifted.year, shifted.month, shifted.day);
}

/// 日記の [date] が始まる時刻（その日の朝4時）。
DateTime diaryDayStartOf(DateTime date) =>
    DateTime(date.year, date.month, date.day, diaryDayStartHour);

/// 自分の日記を書いたり直したりできる日か。書き忘れや夜更かしに備えて昨日まで。
bool isEditableDiaryDate(DateTime date, {required DateTime today}) {
  final yesterday = DateTime(today.year, today.month, today.day - 1);
  return date == today || date == yesterday;
}
