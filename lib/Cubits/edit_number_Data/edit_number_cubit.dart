import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/edit_number_Data/edit_number_state.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Repository/dio_helper.dart';

class EditNmberCubit extends Cubit<EditNumberStates> {
  EditNmberCubit() : super(InitialEditState());

  static EditNmberCubit get(context) => BlocProvider.of(context);
  void update({
    required String phone,
  }) {
    emit(EditNumberLoadingState());
    DioHelper.updata(
      url: 'rest/v1/users',
      query: {
        'id': 'eq.${employeer_id}',
      },
      data: {
        'phone': phone,
      },
    ).then((value) {
      emit(EditNumberSuccessState());
    }).catchError((error) {
      emit(EditNumberErrorState(error: error.toString()));
    });
  }
}
