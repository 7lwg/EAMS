class AskDataModel {
  int? id;
  String? askTime;
  int? startHoliday;
  int? endHoliday;
  bool? respondStatus;
  String? reason;
  int? employeeId;
  String? companyName;

  AskDataModel({
    this.id,
    this.askTime,
    this.startHoliday,
    this.endHoliday,
    this.respondStatus,
    this.reason,
    this.employeeId,
    this.companyName,
  });

  AskDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    askTime = json['ask_time'];
    startHoliday = json['start_holiday'];
    endHoliday = json['end_holiday'];
    respondStatus = json['respond_status'];
    reason = json['reason'];
    employeeId = json['employee_id'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ask_time'] = this.askTime;
    data['start_holiday'] = this.startHoliday;
    data['end_holiday'] = this.endHoliday;
    data['respond_status'] = this.respondStatus;
    data['reason'] = this.reason;
    data['employee_id'] = this.employeeId;
    data['company_name'] = this.companyName;
    return data;
  }
}

class ListModel {
  List<AskDataModel> data = [];

  ListModel.fromJson(List<dynamic> jsonList) {
    for (var item in jsonList) {
      data.add(AskDataModel.fromJson(item));
    }
  }
}
