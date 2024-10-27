import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'show_password_state.dart';

class ShowPasswordCubit extends Cubit<ShowPasswordState> {
  ShowPasswordCubit() : super(ShowPasswordInitial());

  bool Show_password = true;
  bool Show_old_password = true;

  void password() {
    if (Show_password == true) {
      Show_password = false;
    } else {
      Show_password = true;
    }
    emit(ShowPasswordInitial());
  }

  void ole_password() {
    if (Show_old_password == true) {
      Show_old_password = false;
    } else {
      Show_old_password = true;
    }
    emit(ShowPasswordSecond());
  }
}
