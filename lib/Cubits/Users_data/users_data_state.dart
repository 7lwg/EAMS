part of 'users_data_cubit.dart';

@immutable
sealed class UsersDataState {}

final class UsersDataInitial extends UsersDataState {}

final class UsersDataLoading extends UsersDataState {}

final class UsersDataSuccess extends UsersDataState {}

final class UsersDataError extends UsersDataState {
  late final String errorMessage;
  UsersDataError(this.errorMessage);
  List<Object> get props => [errorMessage];
}

final class GenderRadioButton extends UsersDataState {}

final class SalaryTypeButton extends UsersDataState {}

final class UploadedImage extends UsersDataState {}
