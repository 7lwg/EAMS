import 'package:bloc/bloc.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:meta/meta.dart';

part 'attendance_new_data_state.dart';

class AttendanceNewDataCubit extends Cubit<AttendanceNewDataState> {
  AttendanceNewDataCubit() : super(AttendanceNewDataInitial());
  GetAttendanceNewRepo attendanceNewRepo = GetAttendanceNewRepo();

  Future<void> getAttendanceNewData() async {
    emit(AttendanceNewDataLoading());

    try {
      await attendanceNewRepo.getAttendanceNewData().then((value) {
        if (value != null) {
          emit(AttendanceNewDataSuccess());
        } else {
          emit(AttendanceNewDataError('No Employee\'s Found'));
        }
      });
    } catch (error) {
      emit(AttendanceNewDataError('An error occurred'));
    }
  }
}
