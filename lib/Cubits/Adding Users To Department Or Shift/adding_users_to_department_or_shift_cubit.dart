import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'adding_users_to_department_or_shift_state.dart';

class AddingUsersToDepartmentOrShiftCubit
    extends Cubit<AddingUsersToDepartmentOrShiftState> {
  AddingUsersToDepartmentOrShiftCubit()
      : super(AddingUsersToDepartmentOrShiftInitial());

  void Check_User() {
    emit(AddingUsersToDepartmentOrShiftInitial());
  }
}