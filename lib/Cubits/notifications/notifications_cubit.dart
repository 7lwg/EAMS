import 'package:bloc/bloc.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:meta/meta.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());
  GetNotificationsRepo notificationsRepo = GetNotificationsRepo();

  Future<void> getNotificationsData() async {
    emit(NotificationsLoading());

    try {
      await notificationsRepo.getNotificationsData().then((value) {
        if (value != null) {
          emit(NotificationsSuccess());
        } else {
          emit(NotificationsError('No Notifications Found'));
        }
      });
    } catch (error) {
      emit(NotificationsError('An error occurred'));
    }
  }
}
