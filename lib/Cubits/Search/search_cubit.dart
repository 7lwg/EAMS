import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  bool search = false;

  bool sort = false;

  void search_icon() {
    if (search == true) {
      search = false;
    } else {
      search = true;
    }
    emit(SearchInitial());
  }

  void close_search() {
    search = false;
    emit(SearchInitial());
  }

  void Gender_color() {
    emit(GenderColorButton());
  }

  void Age_Range_Slide() {
    emit(AgeRangeSlide());
  }

  void Sorting() {
    search = false;
    emit(Sort());
  }

  void sort_icon() {
    if (sort == true) {
      sort = false;
    } else {
      sort = true;
    }
    emit(Sort());
  }

  void close_sort() {
    sort = false;
    emit(Sort());
  }
}
