class HeartRateResponse {
  List<HeartRateData>? data;
  String? nextToken;

  HeartRateResponse({this.data, this.nextToken});

  HeartRateResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HeartRateData>[];
      json['data'].forEach((v) {
        data!.add(HeartRateData.fromJson(v));
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

class HeartRateData {
  int? bpm;
  String? source;
  String? timestamp;

  HeartRateData({this.bpm, this.source, this.timestamp});

  HeartRateData.fromJson(Map<String, dynamic> json) {
    bpm = json['bpm'];
    source = json['source'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bpm'] = bpm;
    data['source'] = source;
    data['timestamp'] = timestamp;
    return data;
  }
}