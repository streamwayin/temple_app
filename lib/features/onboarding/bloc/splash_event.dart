part of 'splash_bloc.dart';

class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class SetIndexEvent extends SplashEvent {
  final int index;

  const SetIndexEvent({required this.index});
}
