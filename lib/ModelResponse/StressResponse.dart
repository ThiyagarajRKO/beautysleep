class StressResponse {
  List<StressData>? data;
  Null nextToken;

  StressResponse({this.data, this.nextToken});

  StressResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <StressData>[];
      json['data'].forEach((v) {
        data!.add(StressData.fromJson(v));
      });
    }
    nextToken = json['next_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['next_token'] = nextToken;
    return data;
  }
}

class StressData {
  String? id;
  String? day;
  int? stressHigh;
  int? recoveryHigh;
  String? daySummary;

  StressData(
      {this.id, this.day, this.stressHigh, this.recoveryHigh, this.daySummary});

  StressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    stressHigh = json['stress_high'];
    recoveryHigh = json['recovery_high'];
    daySummary = json['day_summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['day'] = day;
    data['stress_high'] = stressHigh;
    data['recovery_high'] = recoveryHigh;
    data['day_summary'] = daySummary;
    return data;
  }
}