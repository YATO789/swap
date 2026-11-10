import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domains/post/track.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../providers/track_preview_notifier.dart';

/// 曲のアルバム画像。読み込んでいるあいだはシマーを出し、画像がない・読めないときは音符の四角を出す。
class TrackArtwork extends StatelessWidget {
  const TrackArtwork({
    super.key,
    required this.track,
    required this.size,
    this.radius = 6,
  });

  final Track track;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final url = track.artworkUrl;
    final missing = _MissingArtwork(size: size);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.square(
        dimension: size,
        child: url == null
            ? missing
            : CachedNetworkImage(
                imageUrl: url.toString(),
                fit: BoxFit.cover,
                placeholder: (_, _) => const _Shimmer(),
                errorWidget: (_, _, _) => missing,
              ),
      ),
    );
  }
}

/// 読み込み中に出す、光が左から右へ流れる四角。
/// 動きを減らす設定のときは、流さずに止めておく。
class _Shimmer extends HookWidget {
  const _Shimmer();

  /// 光が端から端まで流れる時間。
  static const _period = Duration(milliseconds: 1200);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final base = colors.placeholder;
    // 明るい画面では白に、暗い画面では少しだけ明るく寄せて、どちらでも光って見えるようにする。
    final highlight = Color.lerp(
      base,
      Colors.white,
      Theme.of(context).brightness == Brightness.dark ? 0.08 : 0.7,
    )!;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final controller = useAnimationController(duration: _period);
    useEffect(() {
      if (reduceMotion) {
        controller.stop();
      } else {
        controller.repeat();
      }
      return null;
    }, [reduceMotion]);
    final progress = useAnimation(controller);

    // 光の帯を、四角の左の外から右の外まで動かす。
    final center = -1.5 + progress * 3;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(center - 1, -0.3),
          end: Alignment(center + 1, 0.3),
          colors: [base, highlight, base],
          stops: const [0.25, 0.5, 0.75],
        ),
      ),
    );
  }
}

/// アルバム画像がない・読めないときに出す、音符の四角。
class _MissingArtwork extends StatelessWidget {
  const _MissingArtwork({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ColoredBox(
      color: colors.placeholder,
      child: Icon(
        Icons.music_note_rounded,
        size: size * 0.45,
        color: colors.textSecondary,
      ),
    );
  }
}

/// 曲の試聴を流す丸いボタン。流しているあいだは止めるボタンになる。
/// 試聴の音源がない曲は、押すと Apple Music で曲を開く。
class TrackPlayButton extends ConsumerWidget {
  const TrackPlayButton({
    super.key,
    required this.track,
    this.size = 36,
    this.enabled = true,
  });

  final Track track;
  final double size;

  /// false なら見た目だけで押せない。浮かせた見本の記録などに使う。
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final playing = ref.watch(trackPreviewProvider) == track.id;

    return Semantics(
      button: true,
      label: playing
          ? l10n.trackStopPreview(track.title)
          : l10n.trackPlay(track.title),
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: Material(
          color: colors.textPrimary,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: enabled
                ? () => toggleTrackPreview(context, ref, track)
                : null,
            child: Icon(
              playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
              size: size * 0.6,
              color: colors.surface,
            ),
          ),
        ),
      ),
    );
  }
}

/// [track] の試聴を流す。流していれば止める。試聴の音源がない曲は、Apple Music で開く。
Future<void> toggleTrackPreview(
  BuildContext context,
  WidgetRef ref,
  Track track,
) async {
  if (track.previewUrl == null) {
    await openTrackInStore(context, track);
    return;
  }
  final messenger = ScaffoldMessenger.of(context);
  final failedMessage = context.l10n.trackPreviewFailed;
  final ok = await ref.read(trackPreviewProvider.notifier).toggle(track);
  if (ok) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(failedMessage)));
}

/// Apple Music で [track] の曲のページを開く。Apple Music のアプリが入っていればアプリで開く。
Future<void> openTrackInStore(BuildContext context, Track track) async {
  final messenger = ScaffoldMessenger.of(context);
  final failedMessage = context.l10n.trackOpenFailed;
  var opened = false;
  try {
    opened = await launchUrl(
      track.storeUrl,
      mode: LaunchMode.externalApplication,
    );
  } on Exception {
    opened = false;
  }
  if (opened) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(failedMessage)));
}

/// 曲名とアーティスト名を2行で出す。
class TrackTitle extends StatelessWidget {
  const TrackTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleSize = 14,
  });

  final String title;
  final String subtitle;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w600),
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// タイムラインの記録に添えた曲。アルバム画像を白い縁の写真のように少し傾けて貼り、
/// 右に曲名とアーティスト名を書く。写真を押すと試聴を流し、曲名を押すと Apple Music で開く。
/// ひとことより目立たないよう、枠や黒い再生ボタンは付けない。
///
/// iTunes Search API の試聴は、出所（provided courtesy of iTunes）を書いて使う決まりなので、
/// 試聴を流しているあいだだけ出す。
/// 同じ規約には、曲のページへのリンクになった公式のバッジをそばに置く決まりもあるが、
/// 見た目を優先してバッジは置いていない（2026-11-11 に判断）。
class TrackCard extends ConsumerWidget {
  const TrackCard({super.key, required this.track, this.enabled = true});

  final Track track;

  /// false なら押せない。浮かせた見本の記録などに使う。
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final playing = ref.watch(trackPreviewProvider) == track.id;

    return Padding(
      // 傾けた写真の角と影が、上下の文字やチップにかからないようにあける。
      padding: const EdgeInsets.only(left: 2, top: 4, bottom: 2),
      child: Row(
        children: [
          _TrackPhoto(track: track, playing: playing, enabled: enabled),
          const SizedBox(width: 14),
          Expanded(
            child: Semantics(
              button: enabled,
              label: context.l10n.trackOpenInStore(track.title),
              excludeSemantics: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: enabled ? () => openTrackInStore(context, track) : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TrackTitle(title: track.title, subtitle: track.artist),
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
            ),
          ),
        ],
      ),
    );
  }
}

/// 白い縁を付けて少し傾けた、写真のようなアルバム画像。真ん中に再生（流しているあいだは停止）の印を重ねる。
class _TrackPhoto extends ConsumerWidget {
  const _TrackPhoto({
    required this.track,
    required this.playing,
    required this.enabled,
  });

  final Track track;
  final bool playing;
  final bool enabled;

  static const double _artworkSize = 52;

  /// 写真の傾き（ラジアン）。左に3度ほど。
  static const double _tilt = -0.05;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dark = Theme.of(context).brightness == Brightness.dark;
    // 写真の縁。ダークモードでは真っ白だとまぶしいので、少し落とす。
    final frame = dark ? const Color(0xFFDADADA) : Colors.white;

    return Semantics(
      button: enabled,
      label: playing
          ? l10n.trackStopPreview(track.title)
          : l10n.trackPlay(track.title),
      excludeSemantics: true,
      child: Transform.rotate(
        angle: _tilt,
        child: GestureDetector(
          onTap: enabled ? () => toggleTrackPreview(context, ref, track) : null,
          child: Container(
            // 下の縁を広めにして、ポラロイド写真に見せる。
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
            decoration: BoxDecoration(
              color: frame,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? 0.5 : 0.18),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                TrackArtwork(track: track, size: _artworkSize, radius: 1),
                // 画像の明るさにかかわらず見えるよう、半透明の黒い丸に白い印を置く。
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    size: 16,
                    color: Colors.white,
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

/// 試聴の出所。規約で決まった文なので訳さない。
const previewCourtesy = 'provided courtesy of iTunes';

/// 日記の「この日の記録」に出す、曲名とアーティスト名だけの小さな1行。押すと Apple Music で曲を開く。
/// 小さい行ではバッジを並べられないので、バッジが要るアルバム画像と試聴は出さない。
class TrackLine extends StatelessWidget {
  const TrackLine({super.key, required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.textSecondary;

    return Semantics(
      button: true,
      label: context.l10n.trackOpenInStore(track.title),
      excludeSemantics: true,
      child: InkWell(
        onTap: () => openTrackInStore(context, track),
        borderRadius: BorderRadius.circular(4),
        child: Row(
          children: [
            Icon(Icons.music_note_outlined, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${track.title} ・ ${track.artist}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
