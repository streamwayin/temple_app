part of 'play_audio_bloc.dart';

class PlayAudioEvent extends Equatable {
  const PlayAudioEvent();

  @override
  List<Object> get props => [];
}

class PlayAudioEventInitial extends PlayAudioEvent {}

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
  final int initialIndex;
  const LoadCurrentPlaylistEvent({required this.initialIndex});
}

class PlaySinglesongEvent extends PlayAudioEvent {
  final int index;
  const PlaySinglesongEvent({required this.index});
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

class FetchSongsOfAlbum extends PlayAudioEvent {
  final String albumId;

  const FetchSongsOfAlbum({required this.albumId});
}

class UpdateSelectedAlbumIndex extends PlayAudioEvent {
  final int index;

  const UpdateSelectedAlbumIndex({required this.index});
}

// class ChangeOnPlayAudioSreenOrNot extends PlayAudioEvent {
//   final bool onPlayAudioScreen;

//   const ChangeOnPlayAudioSreenOrNot({required this.onPlayAudioScreen});
// }

class ChangeShowBottomMusicController extends PlayAudioEvent {
  final bool changeShowBottomMusicController;

  const ChangeShowBottomMusicController(
      {required this.changeShowBottomMusicController});
}

class SaveCurrentAlbumToLocalStorage extends PlayAudioEvent {
  const SaveCurrentAlbumToLocalStorage();
}

class LoadSavedTrackInPlayerEvent extends PlayAudioEvent {}

class GetAlbumsByArtistEvent extends PlayAudioEvent {
  final int index;

  const GetAlbumsByArtistEvent({required this.index});
}

class ChangeOnAboutUsNavBar extends PlayAudioEvent {
  final bool onAboutUsNavBar;

  const ChangeOnAboutUsNavBar({required this.onAboutUsNavBar});
}

class ChangeCurrentPlaylistAlbumId extends PlayAudioEvent {}

class SavePlayingTracksEvent extends PlayAudioEvent {}
