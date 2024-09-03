class SleepResponse {
  List<SleepResponseData>? data;
  String? nextToken;

  SleepResponse({this.data, this.nextToken});

  SleepResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SleepResponseData>[];
      json['data'].forEach((v) {
        data!.add(SleepResponseData.fromJson(v));
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

class SleepResponseData {
  String? id;
  Contributors? contributors;
  String? day;
  int? score;
  String? timestamp;

  SleepResponseData({this.id, this.contributors, this.day, this.score, this.timestamp});

  SleepResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contributors = json['contributors'] != null
        ? Contributors.fromJson(json['contributors'])
        : null;
    day = json['day'];
    score = json['score'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (contributors != null) {
      data['contributors'] = contributors!.toJson();
    }
    data['day'] = day;
    data['score'] = score;
    data['timestamp'] = timestamp;
    return data;
  }
}

class Contributors {
  int? deepSleep;
  int? efficiency;
  int? latency;
  int? remSleep;
  int? restfulness;
  int? timing;
  int? totalSleep;

  Contributors(
      {this.deepSleep,
        this.efficiency,
        this.latency,
        this.remSleep,
        this.restfulness,
        this.timing,
        this.totalSleep}
      );

  Contributors.fromJson(Map<String, dynamic> json) {
    deepSleep = json['deep_sleep'] ?? 0;
    efficiency = json['efficiency'] ?? 0;
    latency = json['latency'] ?? 0;
    remSleep = json['rem_sleep'] ?? 0;
    restfulness = json['restfulness']?? 0;
    timing = json['timing'] ?? 0;
    totalSleep = json['total_sleep'] ?? 0;
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
    return data;
  }
}

