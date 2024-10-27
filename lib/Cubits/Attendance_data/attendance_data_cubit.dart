import 'package:bloc/bloc.dart';
import 'package:graduation_project/data/Repository/get_attendance_repo.dart';
import 'package:meta/meta.dart';

part 'attendance_data_state.dart';

class AttendanceDataCubit extends Cubit<AttendanceDataState> {
  AttendanceDataCubit() : super(AttendanceDataInitial());
  GetAttendanceRepo attendanceRepo = GetAttendanceRepo();

  Future<void> getAttendanceData() async {
    emit(AttendanceDataLoading());

    try {
      await attendanceRepo.getAttendanceData().then((value) {
        if (value != null) {
          emit(AttendanceDataSuccess());
        } else {
          emit(AttendanceDataError('Failed to fetch Attendance\'s'));
        }
      });
    } catch (error) {
      emit(AttendanceDataError('An error occurred'));
    }
  }
}
