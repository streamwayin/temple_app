part of 'splash_bloc.dart';

class SplashState extends Equatable {
  const SplashState({
    this.index = 0,
  });
  final int index;
  @override
  List<Object> get props => [index];

  SplashState copyWith({
    int? index,
  }) {
    return SplashState(
      index: index ?? this.index,
    );
  }
}

final class SplashInitial extends SplashState {}
