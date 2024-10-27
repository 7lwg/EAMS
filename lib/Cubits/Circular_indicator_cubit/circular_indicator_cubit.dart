import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'circular_indicator_state.dart';

class CircularIndicatorCubit extends Cubit<CircularIndicatorState> {
  CircularIndicatorCubit() : super(CircularIndicatorInitial());

  var isLoading = false;

  var isLoading_Location = false;

  void Circular() async {
    isLoading = true;
    emit(CircularIndicatorInitial());
    await Future.delayed(Duration(seconds: 3), () {
      isLoading = false;
      emit(CircularIndicator());
    });
  }

  void Circular_Location() async {
    isLoading_Location = true;
    emit(CircularIndicatorInitial_Location());
    await Future.delayed(Duration(seconds: 1), () {
      isLoading_Location = false;
      emit(CircularIndicator_Location());
    });
  }

  void forget_location() async {
    emit(CircularIndicator_Location());
  }
}
