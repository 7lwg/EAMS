import 'package:bloc/bloc.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:meta/meta.dart';

part 'users_data_state.dart';

class UsersDataCubit extends Cubit<UsersDataState> {
  UsersDataCubit() : super(UsersDataInitial());
  GetUsersRepo usersRepo = GetUsersRepo();

  Future<void> getUsersData() async {
    emit(UsersDataLoading());

    try {
      await usersRepo.getEmployeeData().then((value) {
        if (value != null) {
          emit(UsersDataSuccess());
        } else {
          emit(UsersDataError('No Employee\'s Found'));
        }
      });
    } catch (error) {
      emit(UsersDataError('An error occurred'));
    }
  }

  void Gender() {
    emit(GenderRadioButton());
  }

  void SalaryType() {
    emit(SalaryTypeButton());
  }

  void uploadedImage() {
    emit(SalaryTypeButton());
  }
}
