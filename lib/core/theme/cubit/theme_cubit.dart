import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/shared_pref_cache_client.dart';
import 'package:zain/core/theme/cubit/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._cache) : super(const ThemeState(ThemeMode.light));

  final SharedPrefCacheClient _cache;

  Future<void> load() async {
    final saved = await _cache.get(CacheKeys.themeMode);
    final mode =
        saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(mode));
  }

  Future<void> toggle() async {
    final next = state.isDark ? ThemeMode.light : ThemeMode.dark;
    await _cache.set(CacheKeys.themeMode, next == ThemeMode.dark ? 'dark' : 'light');
    emit(ThemeState(next));
  }
}
