import 'package:bloc/bloc.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:meta/meta.dart';

part 'shifts_data_state.dart';

class ShiftsDataCubit extends Cubit<ShiftsDataState> {
  ShiftsDataCubit() : super(ShiftsDataInitial());
  GetShiftsRepo shiftsRepo = GetShiftsRepo();

  Future<void> getShiftsData() async {
    emit(ShiftsDataLoading());

    try {
      await shiftsRepo.getShiftsData().then((value) {
        if (value != null) {
          emit(ShiftsDataSuccess());
        } else {
          emit(ShiftsDataError('No Shifts Found'));
        }
      });
    } catch (error) {
      emit(ShiftsDataError('An error occurred'));
    }
  }
}
