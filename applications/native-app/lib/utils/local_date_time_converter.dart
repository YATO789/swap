import 'package:json_annotation/json_annotation.dart';

/// DB の timestamptz（UTC の文字列）を、端末の時刻の DateTime として読む。
class LocalDateTimeConverter implements JsonConverter<DateTime, String> {
  const LocalDateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
