import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'field_requirments_state.dart';

class FieldRequirmentsCubit extends Cubit<FieldRequirmentsState> {
  FieldRequirmentsCubit() : super(FieldRequirmentsInitial());

  void FieldRequirments() {
    emit(FieldRequirmentsInitial());
  }
}
