abstract class EditNumberStates {}

class InitialEditState extends EditNumberStates {}

class EditNumberSuccessState extends EditNumberStates {}

class EditNumberErrorState extends EditNumberStates {
  final String error;

  EditNumberErrorState({required this.error});
}

class EditNumberLoadingState extends EditNumberStates {}
