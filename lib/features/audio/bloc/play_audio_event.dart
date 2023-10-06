part of 'play_audio_bloc.dart';

class PlayAudioEvent extends Equatable {
  const PlayAudioEvent();

  @override
  List<Object> get props => [];
}

class GetAudioListFromWebEvent extends PlayAudioEvent {}

class AlbumIndexChanged extends PlayAudioEvent {
  final int oldIndex;
  final int newIndex;

  const AlbumIndexChanged({required this.oldIndex, required this.newIndex});
  @override
  List<Object> get props => [oldIndex, newIndex];
}

class SongIndexChanged extends PlayAudioEvent {
  final int oldIndex;
  final int newIndex;
  final int albumIndex;

  const SongIndexChanged({
    required this.oldIndex,
    required this.newIndex,
    required this.albumIndex,
  });
  @override
  List<Object> get props => [oldIndex, newIndex];
}

class LoadCurrentPlaylistEvent extends PlayAudioEvent {
  final int albumIndex;

  const LoadCurrentPlaylistEvent({required this.albumIndex});
}

class DownloadSongEvent extends PlayAudioEvent {
  // final int currentSongIndex;
  final BuildContext context;

  const DownloadSongEvent({required this.context});
}

class ChangeSongEvent extends PlayAudioEvent {
  final bool next;
  final bool previous;

  const ChangeSongEvent({this.next = false, this.previous = false});
}

class PlayOrPauseSongEvent extends PlayAudioEvent {
  final bool play;

  const PlayOrPauseSongEvent({required this.play});
}

class SetSeekDurationEvent extends PlayAudioEvent {
  final Duration duration;

  const SetSeekDurationEvent({required this.duration});
}
