part of 'shifts_data_cubit.dart';

@immutable
sealed class ShiftsDataState {}

final class ShiftsDataInitial extends ShiftsDataState {}

final class ShiftsDataLoading extends ShiftsDataState {}

final class ShiftsDataSuccess extends ShiftsDataState {}

final class ShiftsDataError extends ShiftsDataState {
  late final String errorMessage;
  ShiftsDataError(this.errorMessage);
  List<Object> get props => [errorMessage];
}
