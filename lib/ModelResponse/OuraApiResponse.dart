class OuraApiResponse {
  int? deepSleep;
  int? efficiency;
  int? latency;
  int? remSleep;
  int? restfulness;
  int? timing;
  int? totalSleep;
  String? id;
  String? day;
  int? stressHigh;
  int? recoveryHigh;
  String? daySummary;

  OuraApiResponse(
      {this.deepSleep,
        this.efficiency,
        this.latency,
        this.remSleep,
        this.restfulness,
        this.timing,this.id, this.day, this.stressHigh, this.recoveryHigh, this.daySummary,
        this.totalSleep});

  OuraApiResponse.fromJson(Map<String, dynamic> json) {
    deepSleep = json['deep_sleep'] ?? 0;
    efficiency = json['efficiency'] ?? 0;
    latency = json['latency'] ?? 0;
    remSleep = json['rem_sleep'] ?? 0;
    restfulness = json['restfulness']?? 0;
    timing = json['timing'] ?? 0;
    totalSleep = json['total_sleep'] ?? 0;
    id = json['id'] ?? 0;
    day = json['day'] ?? "";
    stressHigh = json['stress_high'] ?? 0;
    recoveryHigh = json['recovery_high'] ?? 0;
    daySummary = json['day_summary'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deep_sleep'] = deepSleep;
    data['efficiency'] = efficiency;
    data['latency'] = latency;
    data['rem_sleep'] = remSleep;
    data['restfulness'] = restfulness;
    data['timing'] = timing;
    data['total_sleep'] = totalSleep;
    data['id'] = id;
    data['day'] = day;
    data['stress_high'] = stressHigh;
    data['recovery_high'] = recoveryHigh;
    data['day_summary'] = daySummary;
    return data;
  }
}
