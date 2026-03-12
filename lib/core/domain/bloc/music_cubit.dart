import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_tap_quest/core/domain/bloc/music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  static const String _volumeKey = 'audio.volume';
  static const String _effectsVolumeKey = 'audio.effects.volume';
  static const String _mutedKey = 'audio.muted';
  static const String _effectsMutedKey = 'audio.effects.muted';
  static const String _menuReachedKey = 'audio.menu.reached';
  static const int _maxClickPlayers = 4;
  static const String _bgMusicAsset = 'sounds/bg_music.mp3';
  static const String _clickSoundAsset = 'sounds/click.mp3';

  final AudioPlayer _player = AudioPlayer();
  final List<AudioPlayer> _clickPlayers = [];
  bool _isSourceSet = false;
  bool _isInitialized = false;
  bool _isAppForeground = true;
  bool _menuReached = false;
  int _clickPlayerIndex = 0;
  bool _audioContextConfigured = false;

  MusicCubit() : super(const MusicState());

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await _configureAudioContext();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(state.volume);
    final prefs = await SharedPreferences.getInstance();
    final volume = prefs.getDouble(_volumeKey) ?? 0.6;
    final muted = prefs.getBool(_mutedKey) ?? false;
    final effectsVolume = prefs.getDouble(_effectsVolumeKey) ?? 0.7;
    final effectsMuted = prefs.getBool(_effectsMutedKey) ?? false;
    final menuReached = prefs.getBool(_menuReachedKey) ?? false;

    emit(
      state.copyWith(
        volume: volume.clamp(0.0, 1.0),
        effectsVolume: effectsVolume.clamp(0.0, 1.0),
        isMuted: muted,
        isEffectsMuted: effectsMuted,
        isPlaying: false,
      ),
    );

    _menuReached = menuReached;
    if (_menuReached && _isAppForeground) {
      await _startPlaybackIfNeeded();
    }
  }

  Future<void> _configureAudioContext() async {
    if (_audioContextConfigured) return;
    _audioContextConfigured = true;
    await AudioPlayer.global.setAudioContext(
      AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build(),
    );
  }

  void onHomeReached() {
    if (_menuReached) return;
    _menuReached = true;
    _persistMenuReached();
    unawaited(_startPlaybackIfNeeded());
  }

  Future<void> setMuted(bool muted) async {
    emit(state.copyWith(isMuted: muted));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mutedKey, muted);

    if (muted) {
      await _player.pause();
      emit(state.copyWith(isPlaying: false));
      return;
    }

    await _player.setVolume(state.volume);
    await _startPlaybackIfNeeded();
  }

  Future<void> setVolume(double volume) async {
    final clampedVolume = volume.clamp(0.0, 1.0);
    emit(state.copyWith(volume: clampedVolume));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, clampedVolume);
    await _player.setVolume(clampedVolume);

    if (!state.isMuted && state.isPlaying) {
      await _startPlaybackIfNeeded();
    }
  }

  void setAppLifecycleState(bool isActive) {
    _isAppForeground = isActive;
    if (_isAppForeground) {
      unawaited(_startPlaybackIfNeeded());
    } else {
      unawaited(_pause());
    }
  }

  Future<void> playClickSound() async {
    if (state.isEffectsMuted || state.effectsVolume <= 0) return;

    final player = _getClickPlayer();
    await player.setVolume(state.effectsVolume);
    await player.setSource(AssetSource(_clickSoundAsset));
    await player.resume();
  }

  AudioPlayer _getClickPlayer() {
    if (_clickPlayers.length < _maxClickPlayers) {
      final player = AudioPlayer();
      unawaited(
        player.setAudioContext(
          AudioContext(
            android: AudioContextAndroid(
              usageType: AndroidUsageType.assistanceSonification,
              contentType: AndroidContentType.sonification,
              audioFocus: AndroidAudioFocus.none,
            ),
            iOS: AudioContextIOS(
              options: {AVAudioSessionOptions.mixWithOthers},
            ),
          ),
        ),
      );
      unawaited(player.setPlayerMode(PlayerMode.lowLatency));
      unawaited(player.setReleaseMode(ReleaseMode.stop));
      unawaited(player.setVolume(state.effectsVolume));
      _clickPlayers.add(player);
      return player;
    }

    _clickPlayerIndex = (_clickPlayerIndex + 1) % _clickPlayers.length;
    final player = _clickPlayers[_clickPlayerIndex];
    unawaited(player.stop());
    return player;
  }

  void _setClickPlayersVolume() {
    for (final player in _clickPlayers) {
      unawaited(player.setVolume(state.effectsVolume));
    }
  }

  Future<void> setEffectsMuted(bool muted) async {
    emit(state.copyWith(isEffectsMuted: muted));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_effectsMutedKey, muted);
    if (muted) {
      await _pauseClickPlayers();
    }
  }

  Future<void> setEffectsVolume(double volume) async {
    final clampedEffectsVolume = volume.clamp(0.0, 1.0);
    emit(state.copyWith(effectsVolume: clampedEffectsVolume));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_effectsVolumeKey, clampedEffectsVolume);
    _setClickPlayersVolume();
  }

  Future<void> _startPlaybackIfNeeded() async {
    if (!_isSourceSet) {
      await _player.setSource(AssetSource(_bgMusicAsset));
      _isSourceSet = true;
    }
    if (!_isAppForeground || !_menuReached || state.isMuted) return;
    if (_player.state == PlayerState.playing) return;

    await _player.setVolume(state.volume);
    await _player.resume();
    emit(state.copyWith(isPlaying: true));
  }

  Future<void> _pause() async {
    if (_player.state == PlayerState.playing) {
      await _player.pause();
      emit(state.copyWith(isPlaying: false));
    }
    await _pauseClickPlayers();
  }

  Future<void> _pauseClickPlayers() async {
    for (final player in _clickPlayers) {
      if (player.state == PlayerState.playing) {
        await player.pause();
      }
    }
  }

  Future<void> _persistMenuReached() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_menuReachedKey, true);
  }

  @override
  Future<void> close() {
    _player.dispose();
    for (final player in _clickPlayers) {
      player.dispose();
    }
    return super.close();
  }
}
