part of 'companies_name_cubit.dart';

@immutable
sealed class CompaniesNameState {}

final class CompaniesNameInitial extends CompaniesNameState {}

final class CompaniesNameLoading extends CompaniesNameState {}

final class CompaniesNameSuccess extends CompaniesNameState {}

final class test extends CompaniesNameState {}

final class CompaniesNameError extends CompaniesNameState {
  late final String errorMessage;
  CompaniesNameError(this.errorMessage);
  List<Object> get props => [errorMessage];
}
