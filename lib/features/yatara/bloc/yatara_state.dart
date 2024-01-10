part of 'yatara_bloc.dart';

class YataraState extends Equatable {
  const YataraState({
    this.isLoading = true,
    this.yataraList = const [],
  });
  final bool isLoading;
  final List<YataraModel> yataraList;
  @override
  List<Object> get props => [isLoading, yataraList];

  YataraState copyWith({
    bool? isLoading,
    List<YataraModel>? yataraList,
  }) {
    return YataraState(
      isLoading: isLoading ?? this.isLoading,
      yataraList: yataraList ?? this.yataraList,
    );
  }
}

final class YataraInitial extends YataraState {}
