part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.onPlayAudioScreen = false,
    this.updateMandatory = false,
  });
  final bool onPlayAudioScreen;
  final bool updateMandatory;

  @override
  List<Object> get props => [onPlayAudioScreen];
  HomeState copyWith({
    bool? onPlayAudioScreen,
    bool? updateMandatory,
  }) {
    return HomeState(
      onPlayAudioScreen: onPlayAudioScreen ?? this.onPlayAudioScreen,
      updateMandatory: updateMandatory ?? this.updateMandatory,
    );
  }
}

final class HomeInitial extends HomeState {}
