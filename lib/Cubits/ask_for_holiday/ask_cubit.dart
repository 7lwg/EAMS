import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/ask_for_holiday/ask_state.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Models/get_ask_holiday_data.dart';
import 'package:graduation_project/data/Models/get_holidays_asks_model.dart';
import 'package:graduation_project/data/Repository/dio_helper.dart';

class AskCubit extends Cubit<AskStates> {
  AskCubit() : super(InatialAskState());

  static AskCubit get(context) => BlocProvider.of(context);

  GetHolidaysAsksModel? getHolidaysAsksModel;
  ListModel? listModel;
  List id = [];
  int id_ = 0;

  void getHolidaysData() {
    DioHelper.getdata(url: 'rest/v1/ask_for_holiday').then((value) {
      listModel = ListModel.fromJson(value.data);
      listModel?.data.forEach((item) {
        if (item.id != null) {
          id.add(item.id);
        }
      });
      id.forEach((item) {
        if (id_ < item) {
          id_ = item;
        }
      });
      emit(GetDataSccess());
    }).catchError((error) {
      emit(GetDataError(error: error.toString()));
    });
  }

  void postAsk({
    required int id,
    required String employee_id,
    required int startDate,
    required int endDate,
    required String reasone,
    required String askTime,
  }) {
    emit(PostDataLoading());
    DioHelper.postData(
      url: 'rest/v1/ask_for_holiday',
      data: {
        'id': id,
        'ask_time': askTime,
        'start_holiday': startDate,
        'end_holiday': endDate,
        'reason': reasone,
        'employee_id': employeer_id,
        'company_name': Company_Name,
      },
    ).then((value) {
      emit(PostDataSccess());
    }).catchError((error) {
      emit(PostDataError(error: error));
    });
  }
}
