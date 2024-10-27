abstract class AskStates {}

class InatialAskState extends AskStates {}

class PostDataSccess extends AskStates {}

class PostDataLoading extends AskStates {}

class GetDataLoading extends AskStates {}

class GetDataSccess extends AskStates {}

class GetDataError extends AskStates {
  final String error;

  GetDataError({required this.error});
}

class PostDataError extends AskStates {
  final String error;

  PostDataError({required this.error});
}
