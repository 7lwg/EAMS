import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/information/information_states.dart';
import 'package:graduation_project/data/Models/get_departments_model.dart';
import 'package:graduation_project/data/Models/get_shifts_model.dart';
import 'package:graduation_project/data/Models/information_model.dart';
import 'package:graduation_project/data/Repository/dio_helper.dart';

class InformationCubit extends Cubit<InformationStates> {
  InformationCubit() : super(InatialInforamtionState());

  static InformationCubit get(context) => BlocProvider.of(context);

  InformationModel? informationModel;
  GetShiftsModel? getShiftsModel;
  GetDepartmentsModel? getDepartmentsModel;

  String? color;
  double net_pay = 0;
  void getData({
    required String id,
  }) {
    DioHelper.getdata(
      url: 'rest/v1/users',
      query: {
        'id': id,
      },
    ).then((value) {
      informationModel = InformationModel.fromJson(value.data[0]);
      emit(GetDataSuccess());
    }).catchError((error) {
      print(error.toString());
    });
  }

  void sum_net_pay(salary, current_salary) {
    net_pay = current_salary - salary;
  }

  void set_color() {
    if (net_pay >= 0) {
      color = '008000';
    } else {
      color = '#FF0000';
    }
  }

  void getDepartments({
    required String id,
  }) {
    DioHelper.getdata(
      url: 'rest/v1/departments',
      query: {
        'id': id,
      },
    ).then((value) {
      getDepartmentsModel = GetDepartmentsModel.fromJson(value.data[0]);
      emit(GetDepartmentsSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetDepartmentsError(error: error));
    });
  }

  void getShifts({
    required String id,
  }) {
    DioHelper.getdata(
      url: 'rest/v1/shifts',
      query: {
        'id': id,
      },
    ).then((value) {
      getShiftsModel = GetShiftsModel.fromJson(value.data[0]);
      emit(GetShiftsSuccess());
    }).catchError((error) {
      emit(GetShiftsError(error: error));
    });
  }
}
