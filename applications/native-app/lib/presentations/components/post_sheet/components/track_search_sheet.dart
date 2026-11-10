import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domains/post/track.dart';
import '../../../../infrastructures/repositories/post_repository.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/track_preview_notifier.dart';
import '../../../../theme/app_theme.dart';
import '../../track_view.dart';

/// 曲を探して1曲選ぶシートを開く。選んだ曲を返し、選ばずに閉じたら null を返す。
Future<Track?> showTrackSearchSheet(BuildContext context) {
  return showModalBottomSheet<Track>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _TrackSearchSheet(),
  );
}

/// 打つのが止まってから探しに行くまでの時間。1文字ごとに探さないようにする。
const _debounce = Duration(milliseconds: 300);

/// 検索の結果。[query] で探した結果か、探せなかったか。
sealed class _SearchResult {
  const _SearchResult(this.query);

  final String query;
}

class _Found extends _SearchResult {
  const _Found(super.query, this.tracks);

  final List<Track> tracks;
}

class _Failed extends _SearchResult {
  const _Failed(super.query);
}

class _TrackSearchSheet extends HookConsumerWidget {
  const _TrackSearchSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final controller = useTextEditingController();
    useListenable(controller);
    final query = controller.text.trim();

    /// いま出している結果。何も打っていなければ null。
    final result = useState<_SearchResult?>(null);

    // 試聴しながら選べるようにしているので、シートを閉じたら（曲を選んだときも）試聴を止める。
    final preview = ref.read(trackPreviewProvider.notifier);
    useEffect(() {
      return () {
        // 閉じている途中に状態を変えないよう、閉じ終わってから止める。
        Future.microtask(preview.stop);
      };
    }, const []);

    // 打つのが止まったら探す。結果が来る前に打ち直していたら、古い結果は捨てる。
    useEffect(() {
      if (query.isEmpty) {
        result.value = null;
        return null;
      }
      var canceled = false;
      final timer = Timer(_debounce, () async {
        _SearchResult next;
        try {
          final tracks = await ref
              .read(postRepositoryProvider)
              .searchTracks(query);
          next = _Found(query, tracks);
        } on Exception catch (error, stackTrace) {
          debugPrint('曲を探せませんでした: $error\n$stackTrace');
          next = _Failed(query);
        }
        if (canceled) return;
        result.value = next;
      });
      return () {
        canceled = true;
        timer.cancel();
      };
    }, [query]);

    final current = result.value;
    final loading = query.isNotEmpty && current?.query != query;

    return Padding(
      // キーボードが出たら、結果の欄を縮めてその上に収める。
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.85,
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.trackAttach,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.trackSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            onPressed: controller.clear,
                            tooltip: l10n.trackSearchClear,
                            icon: const Icon(Icons.cancel, size: 20),
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(
                height: 2,
                child: loading
                    ? LinearProgressIndicator(
                        color: colors.textPrimary,
                        backgroundColor: Colors.transparent,
                      )
                    : null,
              ),
              Expanded(
                child: _Results(
                  query: query,
                  // 探しているあいだは、前の結果を出したままにする。
                  result: current,
                  loading: loading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 検索結果の欄。何も打っていない・見つからない・探せなかったときは、その旨を出す。
class _Results extends StatelessWidget {
  const _Results({
    required this.query,
    required this.result,
    required this.loading,
  });

  final String query;
  final _SearchResult? result;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = this.result;

    final message = switch (result) {
      _ when query.isEmpty => l10n.trackSearchEmpty,
      _ when loading => null,
      _Failed() => l10n.trackSearchFailed,
      _Found(:final tracks) when tracks.isEmpty => l10n.trackSearchNoResults(
        query,
      ),
      _ => null,
    };
    if (message != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: context.appColors.textSecondary,
          ),
        ),
      );
    }

    final tracks = switch (result) {
      _Found(:final tracks) => tracks,
      _ => const <Track>[],
    };
    return ListView.builder(
      // 指でスクロールしたらキーボードを閉じて、結果を見やすくする。
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return _TrackResultTile(
          track: track,
          onTap: () => Navigator.of(context).pop(track),
        );
      },
    );
  }
}

/// 曲の検索結果の1行。アルバム画像・曲名・アーティストとアルバム・試聴ボタンを並べる。
/// 行を押すとその曲を選び、試聴ボタンを押すと選ばずに試聴だけ流す。
class _TrackResultTile extends ConsumerWidget {
  const _TrackResultTile({required this.track, required this.onTap});

  final Track track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playing = ref.watch(trackPreviewProvider) == track.id;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              button: true,
              label: '${track.title}、${track.artist}、${track.album}',
              excludeSemantics: true,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      TrackArtwork(track: track, size: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TrackTitle(
                              title: track.title,
                              subtitle: '${track.artist} ・ ${track.album}',
                            ),
                            // 試聴を流しているあいだは、試聴の出所を小さく添える。
                            if (playing)
                              Text(
                                previewCourtesy,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: context.appColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 試聴できない曲は、押すと Apple Music に移ってしまうので、選んでいる途中には出さない。
          if (track.previewUrl != null) ...[
            const SizedBox(width: 8),
            TrackPlayButton(track: track),
          ],
        ],
      ),
    );
  }
}
