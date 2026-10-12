import 'package:flutter/material.dart';
import 'package:swap/infrastructures/datasources/stores/diary_book_grid_store.dart';
import 'package:swap/infrastructures/datasources/stores/post_diary_book_store.dart';
import 'package:swap/infrastructures/datasources/stores/theme_mode_store.dart';

/// 端末に保存せず、選んだ日記帳をメモリに覚えておく。
class FakePostDiaryBookStore implements PostDiaryBookStore {
  Set<String> _diaryBookIds = {};

  @override
  Set<String> read() => _diaryBookIds;

  @override
  Future<void> save(Set<String> diaryBookIds) async {
    _diaryBookIds = diaryBookIds;
  }
}

/// 端末に保存せず、日記帳をグリッドで出すかをメモリに覚えておく。
class FakeDiaryBookGridStore implements DiaryBookGridStore {
  FakeDiaryBookGridStore({this.grid = false});

  bool grid;

  @override
  bool read() => grid;

  @override
  Future<void> save(bool grid) async {
    this.grid = grid;
  }
}

/// 端末に保存せず、選んだテーマをメモリに覚えておく。
class FakeThemeModeStore implements ThemeModeStore {
  FakeThemeModeStore({this.mode = ThemeMode.system});

  ThemeMode mode;

  @override
  ThemeMode read() => mode;

  @override
  Future<void> save(ThemeMode mode) async {
    this.mode = mode;
  }
}
