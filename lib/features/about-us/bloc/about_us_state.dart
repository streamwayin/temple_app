part of 'about_us_bloc.dart';

class AboutUsState extends Equatable {
  const AboutUsState({
    this.acharayasList = const [],
    this.santList = const [],
  });
  final List<AcharayasModel> acharayasList;
  final List<SantModel> santList;
  @override
  List<Object> get props => [
        acharayasList,
        santList,
      ];
  AboutUsState copyWith({
    List<AcharayasModel>? acharayasList,
    List<SantModel>? santList,
  }) {
    return AboutUsState(
      acharayasList: acharayasList ?? this.acharayasList,
      santList: santList ?? this.santList,
    );
  }
}

final class AboutUsInitial extends AboutUsState {}
