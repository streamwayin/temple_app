part of 'bottom_bar_bloc.dart';

class BottomBarState extends Equatable {
  const BottomBarState({this.currentPageIndex = 0, this.navigationString = ''});
  final int currentPageIndex;
  final String navigationString;
  @override
  List<Object> get props => [currentPageIndex, navigationString];

  BottomBarState copyWith({
    int? currentPageIndex,
    String? navigationString,
  }) {
    return BottomBarState(
        currentPageIndex: currentPageIndex ?? this.currentPageIndex,
        navigationString: navigationString ?? '');
  }
}

final class BottomBarInitial extends BottomBarState {}
