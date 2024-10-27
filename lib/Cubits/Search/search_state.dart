part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class GenderColorButton extends SearchState {}

final class AgeRangeSlide extends SearchState {}

final class Sort extends SearchState {}
