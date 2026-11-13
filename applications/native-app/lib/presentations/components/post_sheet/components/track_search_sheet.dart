import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domains/post/track.dart';
import '../../../../infrastructures/repositories/post_repository.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/popular_tracks_notifier.dart';
import '../../../providers/track_preview_notifier.dart';
import '../../../../theme/app_theme.dart';
import '../../track_view.dart';

/// 曲を探して1曲選ぶシートを開く。選んだ曲を返し、選ばずに閉じたら null を返す。
/// [initialQuery] があれば、検索欄に入れて探した状態で開く。
Future<Track?> showTrackSearchSheet(
  BuildContext context, {
  String? initialQuery,
}) {
  return showModalBottomSheet<Track>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _TrackSearchSheet(initialQuery: initialQuery),
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
  const _TrackSearchSheet({this.initialQuery});

  final String? initialQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final controller = useTextEditingController(text: initialQuery);
    useListenable(controller);
    final query = controller.text.trim();

    /// いま出している結果。何も打っていなければ null。
    final result = useState<_SearchResult?>(null);

    // 何も打っていないあいだは、人気の曲を並べる。前に取れなかったなら、開いたときに取り直す。
    // 無くても曲は探せるので、取れなければ並べないだけにする。
    useEffect(() {
      ref.read(popularTracksProvider.notifier).prefetch();
      return null;
    }, const []);
    final popularTracks = switch (ref.watch(popularTracksProvider)) {
      AsyncData(:final value) => value,
      AsyncError() => const <Track>[],
      _ => null,
    };

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
    final loading = query.isEmpty
        ? popularTracks == null
        : current?.query != query;

    /// 押した曲。下のバーに出し、→ で記録に添える。まだ押していなければ null。
    final focused = useState<Track?>(null);

    // 曲を押したら、その曲を下のバーに出して試聴を流す。
    // もう流している曲を押したときは止めずにそのまま流す。
    void focus(Track track) {
      focused.value = track;
      final playing = ref.read(trackPreviewProvider) == track.id;
      // 試聴できない曲を toggleTrackPreview に渡すと Apple Music に移ってしまうので、渡さない。
      if (track.previewUrl != null && !playing) {
        toggleTrackPreview(context, ref, track);
      }
    }

    // シートの高さは変えず、キーボードが出たら結果の欄を縮めてその上に収める。
    // 高さにキーボードのぶんを足すと、画面の上まで伸びて隙間がなくなってしまう。
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: TextField(
                  controller: controller,
                  // 開いてすぐは人気の曲を見られるよう、キーボードは出さない。
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
                child: Stack(
                  children: [
                    _Results(
                      query: query,
                      // 探しているあいだは、前の結果を出したままにする。
                      result: current,
                      popularTracks: popularTracks,
                      loading: loading,
                      focused: focused.value,
                      onTapTrack: focus,
                      // 下のバーに最後の曲が隠れないよう、バーのぶんあける。
                      bottomInset: focused.value == null
                          ? 16
                          : _FocusedTrackBar.height + 24,
                    ),
                    if (focused.value case final track?)
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 8,
                        child: _FocusedTrackBar(
                          track: track,
                          onSelect: () => Navigator.of(context).pop(track),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 検索結果の欄。何も打っていなければ人気の曲を並べる。
/// 並べる曲がない・見つからない・探せなかったときは、その旨を出す。
class _Results extends StatelessWidget {
  const _Results({
    required this.query,
    required this.result,
    required this.popularTracks,
    required this.loading,
    required this.focused,
    required this.onTapTrack,
    required this.bottomInset,
  });

  final String query;
  final _SearchResult? result;

  /// 人気の曲。取っている途中なら null。
  final List<Track>? popularTracks;
  final bool loading;

  /// 押した曲。その行を目立たせる。
  final Track? focused;
  final ValueChanged<Track> onTapTrack;

  /// 曲の一覧の下にあける幅。
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = this.result;

    if (query.isEmpty) {
      return switch (popularTracks) {
        null => const SizedBox.shrink(),
        [] => _Message(l10n.trackSearchEmpty),
        final tracks => _TrackList(
          tracks: tracks,
          focused: focused,
          onTapTrack: onTapTrack,
          bottomInset: bottomInset,
        ),
      };
    }

    final message = switch (result) {
      _ when loading => null,
      _Failed() => l10n.trackSearchFailed,
      _Found(:final tracks) when tracks.isEmpty => l10n.trackSearchNoResults(
        query,
      ),
      _ => null,
    };
    if (message != null) {
      return _Message(message);
    }

    return _TrackList(
      tracks: switch (result) {
        _Found(:final tracks) => tracks,
        _ => const <Track>[],
      },
      focused: focused,
      onTapTrack: onTapTrack,
      bottomInset: bottomInset,
    );
  }
}

/// 結果の欄に、曲の代わりに出す案内。
class _Message extends StatelessWidget {
  const _Message(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: context.appColors.textSecondary),
      ),
    );
  }
}

/// 曲を並べる。
class _TrackList extends StatelessWidget {
  const _TrackList({
    required this.tracks,
    required this.focused,
    required this.onTapTrack,
    required this.bottomInset,
  });

  final List<Track> tracks;
  final Track? focused;
  final ValueChanged<Track> onTapTrack;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // 指でスクロールしたらキーボードを閉じて、結果を見やすくする。
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(16, 4, 16, bottomInset),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return _TrackResultTile(
          track: track,
          focused: track.id == focused?.id,
          onTap: () => onTapTrack(track),
        );
      },
    );
  }
}

/// 曲の検索結果の1行。アルバム画像・曲名・アーティストとアルバムを並べる。
/// 押すと試聴を流し、下のバーに出す（選ぶのはバーの →）。押した行は背景を付けて目立たせる。
class _TrackResultTile extends ConsumerWidget {
  const _TrackResultTile({
    required this.track,
    required this.focused,
    required this.onTap,
  });

  final Track track;

  /// 押した曲なら true。
  final bool focused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final playing = ref.watch(trackPreviewProvider) == track.id;

    return Semantics(
      button: true,
      selected: focused,
      label: '${track.title}、${track.artist}、${track.album}',
      excludeSemantics: true,
      child: Material(
        color: focused ? colors.placeholder : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
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
                            color: colors.textSecondary,
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
    );
  }
}

/// 押した曲を出す、一覧の下に浮かぶバー。アルバム画像・曲名・アーティスト・試聴ボタン・→ を並べ、
/// → を押すとその曲を記録に添える。
class _FocusedTrackBar extends ConsumerWidget {
  const _FocusedTrackBar({required this.track, required this.onSelect});

  final Track track;
  final VoidCallback onSelect;

  static const double height = 64;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final playing = ref.watch(trackPreviewProvider) == track.id;

    // 一覧と見分けがつくよう、文字の色を地にした濃いバーにする。
    return Material(
      color: colors.textPrimary,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 10),
          child: Row(
            children: [
              TrackArtwork(track: track, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: colors.surface),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.surface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 試聴できない曲は、押すと Apple Music に移ってしまうので出さない。
              if (track.previewUrl != null)
                IconButton(
                  onPressed: () => toggleTrackPreview(context, ref, track),
                  tooltip: playing
                      ? l10n.trackStopPreview(track.title)
                      : l10n.trackPlay(track.title),
                  icon: Icon(
                    playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    size: 30,
                    color: colors.surface,
                  ),
                ),
              const SizedBox(width: 4),
              SizedBox.square(
                dimension: 40,
                child: Material(
                  color: colors.surface,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onSelect,
                    child: Tooltip(
                      message: l10n.trackSelect(track.title),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 22,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
