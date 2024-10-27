part of 'attendance_data_cubit.dart';

@immutable
sealed class AttendanceDataState {}

final class AttendanceDataInitial extends AttendanceDataState {}

final class AttendanceDataLoading extends AttendanceDataState {}

final class AttendanceDataSuccess extends AttendanceDataState {}

final class AttendanceDataError extends AttendanceDataState {
  late final String errorMessage;
  AttendanceDataError(this.errorMessage);
  List<Object> get props => [errorMessage];
}
