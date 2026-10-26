import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/infrastructures/datasources/google_form/feedback_datasource.dart';

part '_generated/feedback_repository.g.dart';

@riverpod
FeedbackRepository feedbackRepository(Ref ref) {
  return FeedbackRepository(ref.watch(feedbackDatasourceProvider));
}

/// 設定から書いたフィードバックを送る。
class FeedbackRepository {
  const FeedbackRepository(this._datasource);

  final FeedbackDatasource _datasource;

  /// [body] を送る。送れなかったら例外を投げる。
  Future<void> send(String body) {
    return _datasource.send(body);
  }
}
