import 'package:bloc/bloc.dart';
import 'package:graduation_project/data/Repository/get_companies_name_repo.dart';
import 'package:meta/meta.dart';

part 'companies_name_state.dart';

class CompaniesNameCubit extends Cubit<CompaniesNameState> {
  CompaniesNameCubit() : super(CompaniesNameInitial());
  GetCompaniesNameRepo copaniesnameRepo = GetCompaniesNameRepo();

  Future<void> getCompainesNameData() async {
    emit(CompaniesNameLoading());

    try {
      await copaniesnameRepo.getCompaniesNameData().then((value) {
        if (value != null) {
          emit(CompaniesNameSuccess());
        } else {
          emit(CompaniesNameError('No Companies Found'));
        }
      });
    } catch (error) {
      emit(CompaniesNameError('An error occurred'));
    }
  }
}
