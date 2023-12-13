part of 'sightseen_bloc.dart';

class SightseenState extends Equatable {
  const SightseenState({this.sightseenList = const []});
  final List<SightseenModel> sightseenList;

  @override
  List<Object> get props => [sightseenList];

  SightseenState copyWith({
    List<SightseenModel>? sightseenList,
  }) {
    return SightseenState(
      sightseenList: sightseenList ?? this.sightseenList,
    );
  }
}

final class SightseenInitial extends SightseenState {}
