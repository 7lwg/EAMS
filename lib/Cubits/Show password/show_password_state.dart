part of 'show_password_cubit.dart';

@immutable
sealed class ShowPasswordState {}

final class ShowPasswordInitial extends ShowPasswordState {}

final class ShowPasswordSecond extends ShowPasswordState {}
