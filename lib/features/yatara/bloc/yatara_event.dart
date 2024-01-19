part of 'yatara_bloc.dart';

class YataraEvent extends Equatable {
  const YataraEvent();

  @override
  List<Object> get props => [];
}

class YataraInitialEvent extends YataraEvent {}

class AddYataraListFromRefreshIndicator extends YataraEvent {
  final List<YataraModel> yataraList;

  AddYataraListFromRefreshIndicator({required this.yataraList});
}
