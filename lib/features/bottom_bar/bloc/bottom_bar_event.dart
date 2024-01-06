part of 'bottom_bar_bloc.dart';

sealed class BottomBarEvent extends Equatable {
  const BottomBarEvent();

  @override
  List<Object> get props => [];
}

class ChangeCurrentPageIndex extends BottomBarEvent {
  final int newIndex;

  ChangeCurrentPageIndex({required this.newIndex});
}
