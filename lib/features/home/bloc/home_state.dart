part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.onPlayAudioScreen = false,
    this.updateMandatory = false,
    this.cauraselPageIndex = 0,
    this.booksList = const [],
    this.downloadEbookMap = const {},
  });
  final bool onPlayAudioScreen;
  final bool updateMandatory;
  final int cauraselPageIndex;
  final List<EbookModel> booksList;
  final Map<String, String> downloadEbookMap;
  @override
  List<Object> get props =>
      [onPlayAudioScreen, cauraselPageIndex, updateMandatory];
  HomeState copyWith({
    bool? onPlayAudioScreen,
    bool? updateMandatory,
    int? cauraselPageIndex,
    List<EbookModel>? booksList,
    Map<String, String>? downloadEbookMap,
  }) {
    return HomeState(
      onPlayAudioScreen: onPlayAudioScreen ?? this.onPlayAudioScreen,
      updateMandatory: updateMandatory ?? this.updateMandatory,
      cauraselPageIndex: cauraselPageIndex ?? this.cauraselPageIndex,
      booksList: booksList ?? this.booksList,
      downloadEbookMap: downloadEbookMap ?? this.downloadEbookMap,
    );
  }
}

final class HomeInitial extends HomeState {}
