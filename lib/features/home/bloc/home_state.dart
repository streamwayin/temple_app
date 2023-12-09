part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({this.onPlayAudioScreen = false});
  final bool onPlayAudioScreen;
  @override
  List<Object> get props => [onPlayAudioScreen];
  HomeState copyWith({
    bool? onPlayAudioScreen,
  }) {
    return HomeState(
      onPlayAudioScreen: onPlayAudioScreen ?? this.onPlayAudioScreen,
    );
  }
}

final class HomeInitial extends HomeState {}
