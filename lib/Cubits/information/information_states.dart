abstract class InformationStates {}

class InatialInforamtionState extends InformationStates {}

class GetDataSuccess extends InformationStates {}

class GetShiftsSuccess extends InformationStates {}

class GetDepartmentsSuccess extends InformationStates {}

// class GetDepartmentsError extends InformationStates {}

class GetDepartmentsError extends InformationStates {
  final String error;

  GetDepartmentsError({required this.error});
}

// class GetShiftsError extends InformationStates {}

class GetShiftsError extends InformationStates {
  final String error;

  GetShiftsError({required this.error});
}

class GetDataError extends InformationStates {
  final String error;

  GetDataError({required this.error});
}
