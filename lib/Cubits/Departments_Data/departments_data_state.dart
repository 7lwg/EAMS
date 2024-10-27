part of 'departments_data_cubit.dart';

@immutable
sealed class DepartmentsDataState {}

final class DepartmentsDataInitial extends DepartmentsDataState {}

final class DepartmentsDataLoading extends DepartmentsDataState {}

final class DepartmentsDataSuccess extends DepartmentsDataState {}

final class DepartmentsDataError extends DepartmentsDataState {
  late final String errorMessage;
  DepartmentsDataError(this.errorMessage);
  List<Object> get props => [errorMessage];
}
