part of 'bottom_bar_bloc.dart';

class BottomBarState extends Equatable {
  const BottomBarState({this.currentPageIndex = 0});
  final int currentPageIndex;
  @override
  List<Object> get props => [currentPageIndex];

  BottomBarState copyWith({int? currentPageIndex}) {
    return BottomBarState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}

final class BottomBarInitial extends BottomBarState {}
