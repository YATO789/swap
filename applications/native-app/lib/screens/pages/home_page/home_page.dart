import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/mock_data.dart';
import '../../../theme/app_theme.dart';
import '../../components/cover_color_picker.dart';
import '../../components/diary_book_icon.dart';
import '../../components/diary_cover.dart';
import '../../components/post_button.dart';
import '../../components/user_avatar.dart';

/// ホーム。日記帳の一覧と、下に「今なにしてる？」と日記を書くバーを置く。
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 日記帳の一覧を、表紙を大きく見せる横2列のグリッドで出すか。false ならリスト。
    final grid = useState(false);

    // TODO: ストアから取り出す。
    const diaryBooks = initialMockDiaryBooks;

    void openDiaryBook(DiaryBook diaryBook) {
      // TODO: 日記帳の詳細ページを開く。
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          // 日記帳がないうちは切り替えても見た目が変わらないので出さない。
          if (diaryBooks.isNotEmpty)
            IconButton(
              onPressed: () => grid.value = !grid.value,
              tooltip: grid.value ? 'リストで表示' : '表紙を大きく表示',
              icon: Icon(
                grid.value
                    ? Icons.view_agenda_outlined
                    : Icons.grid_view_outlined,
              ),
            ),
          IconButton(
            // TODO: 「日記帳を作る」と「招待コードで参加」を選ぶシートを開く。
            onPressed: () {},
            tooltip: '日記帳を追加',
            icon: const Icon(Icons.menu_book_outlined),
          ),
          IconButton(
            // TODO: プロフィールと設定のページを開く。
            onPressed: () {},
            tooltip: 'プロフィールと設定',
            icon: const UserAvatar(name: me, filled: true, size: 30),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: diaryBooks.isEmpty
          ? const _EmptyDiaryBooks()
          : grid.value
          ? _DiaryBookGrid(diaryBooks: diaryBooks, onTap: openDiaryBook)
          : _DiaryBookList(diaryBooks: diaryBooks, onTap: openDiaryBook),
      // 日記帳に1冊も入っていないうちは、書いても見せる相手がいないので出さない。
      bottomNavigationBar: diaryBooks.isEmpty ? null : const PostButton(),
    );
  }
}

/// 日記帳に1冊も入っていないときの案内。真ん中に本を置き、
/// その下からその場で作るか参加できるようにする。
class _EmptyDiaryBooks extends StatelessWidget {
  const _EmptyDiaryBooks();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          // 画面が十分に高ければ真ん中に寄せ、低ければスクロールさせる。
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                // 無地だと寂しいので、表紙にアプリの名前を入れておく。
                child: DiaryCover(
                  name: 'Swap!',
                  color: initialCoverColor,
                  width: min(constraints.maxWidth * 0.5, 200),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '友達と日記帳を作るか、\n招待コードで参加しましょう',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                // TODO: 日記帳を作るページを開く。
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('日記帳を作る'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                // TODO: 招待コードで参加するページを開く。
                onPressed: () {},
                icon: const Icon(Icons.key_outlined),
                label: const Text('招待コードで参加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiaryBookList extends StatelessWidget {
  const _DiaryBookList({required this.diaryBooks, required this.onTap});

  final List<DiaryBook> diaryBooks;
  final ValueChanged<DiaryBook> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        for (final diaryBook in diaryBooks)
          _ListTile(
            leading: DiaryBookIcon(
              label: diaryBook.icon,
              coverColor: diaryBook.coverColor,
            ),
            title: diaryBook.name,
            subtitle: '${diaryBook.members.length}人',
            onTap: () => onTap(diaryBook),
          ),
      ],
    );
  }
}

/// 日記帳の表紙を横2列に大きく並べる。表紙の下に人数を出す。
class _DiaryBookGrid extends StatelessWidget {
  const _DiaryBookGrid({required this.diaryBooks, required this.onTap});

  final List<DiaryBook> diaryBooks;
  final ValueChanged<DiaryBook> onTap;

  static const _padding = 24.0;
  static const _crossSpacing = 20.0;
  static const _mainSpacing = 28.0;

  /// 表紙と人数の間。
  static const _captionGap = 10.0;
  static const _captionHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final coverWidth =
            (constraints.maxWidth - _padding * 2 - _crossSpacing) / 2;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(_padding, 16, _padding, 40),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: _crossSpacing,
            mainAxisSpacing: _mainSpacing,
            mainAxisExtent: coverWidth * 4 / 3 + _captionGap + _captionHeight,
          ),
          itemCount: diaryBooks.length,
          itemBuilder: (context, index) {
            final diaryBook = diaryBooks[index];
            final memberCount = '${diaryBook.members.length}人';

            return Semantics(
              button: true,
              label: '${diaryBook.name}、$memberCount',
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => onTap(diaryBook),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    DiaryCover(
                      name: diaryBook.name,
                      color: diaryBook.coverColor == null
                          ? null
                          : Color(diaryBook.coverColor!),
                      width: coverWidth,
                    ),
                    const SizedBox(height: _captionGap),
                    SizedBox(
                      height: _captionHeight,
                      child: Text(
                        memberCount,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      label: '$title、$subtitle',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
