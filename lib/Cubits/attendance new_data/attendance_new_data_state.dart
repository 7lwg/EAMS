part of 'attendance_new_data_cubit.dart';

@immutable
sealed class AttendanceNewDataState {}

final class AttendanceNewDataInitial extends AttendanceNewDataState {}

final class AttendanceNewDataLoading extends AttendanceNewDataState {}

final class AttendanceNewDataSuccess extends AttendanceNewDataState {}

final class AttendanceNewDataError extends AttendanceNewDataState {
  late final String errorMessage;
  AttendanceNewDataError(this.errorMessage);
  List<Object> get props => [errorMessage];
}
