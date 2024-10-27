part of 'notifications_cubit.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsSuccess extends NotificationsState {}

final class NotificationsError extends NotificationsState {
  late final String errorMessage;
  NotificationsError(this.errorMessage);
  List<Object> get props => [errorMessage];
}
