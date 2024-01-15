// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'play_audio_screen_bloc.dart';

class PlayAudioScreenState extends Equatable {
  const PlayAudioScreenState({
    this.loopMode = false,
    this.isSuffling = false,
  });
  final bool loopMode;
  final bool isSuffling;
  @override
  List<Object> get props => [loopMode, isSuffling];

  PlayAudioScreenState copyWith({
    bool? loopMode,
    bool? isSuffling,
  }) {
    return PlayAudioScreenState(
      loopMode: loopMode ?? this.loopMode,
      isSuffling: isSuffling ?? this.isSuffling,
    );
  }
}

final class PlayAudioScreenInitial extends PlayAudioScreenState {}
