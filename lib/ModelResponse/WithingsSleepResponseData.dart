class WithingsSleepResponseData {
  int? status;
  WithingsBody? body;

  WithingsSleepResponseData({this.status, this.body});

  WithingsSleepResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    body = json['body'] != null ? WithingsBody.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class WithingsBody {
  List<WithingsSeries>? series;
  bool? more;
  int? offset;

  WithingsBody({this.series, this.more, this.offset});

  WithingsBody.fromJson(Map<String, dynamic> json) {
    if (json['series'] != null) {
      series = <WithingsSeries>[];
      json['series'].forEach((v) {
        series!.add(WithingsSeries.fromJson(v));
      });
    }
    more = json['more'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (series != null) {
      data['series'] = series!.map((v) => v.toJson()).toList();
    }
    data['more'] = more;
    data['offset'] = offset;
    return data;
  }
}

class WithingsSeries {
  int? id;
  String? timezone;
  int? model;
  int? modelId;
  String? hashDeviceid;
  int? startdate;
  int? enddate;
  String? date;
  Data? data;
  int? created;
  int? modified;

  WithingsSeries(
      {this.id,
        this.timezone,
        this.model,
        this.modelId,
        this.hashDeviceid,
        this.startdate,
        this.enddate,
        this.date,
        this.data,
        this.created,
        this.modified});

  WithingsSeries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timezone = json['timezone'];
    model = json['model'];
    modelId = json['model_id'];
    hashDeviceid = json['hash_deviceid'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    date = json['date'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timezone'] = timezone;
    data['model'] = model;
    data['model_id'] = modelId;
    data['hash_deviceid'] = hashDeviceid;
    data['startdate'] = startdate;
    data['enddate'] = enddate;
    data['date'] = date;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}
class Data {
  int? wakeupduration;
  int? wakeupcount;
  int? durationtosleep;
  int? remsleepduration;
  int? durationtowakeup;
  int? totalTimeinbed;
  int? totalSleepTime;
  double? sleepEfficiency;
  int? sleepLatency;
  int? wakeupLatency;
  int? waso;
  int? outOfBedCount;
  int? lightsleepduration;
  int? deepsleepduration;
  int? hrAverage;
  int? hrMin;
  int? hrMax;
  int? rrAverage;
  int? rrMin;
  int? rrMax;
  int? breathingDisturbancesIntensity;
  int? snoring;
  int? snoringepisodecount;
  int? sleepScore;
  String? nightEvents;
  dynamic apneaHypopneaIndex;

  Data(
      {this.wakeupduration,
        this.wakeupcount,
        this.durationtosleep,
        this.remsleepduration,
        this.durationtowakeup,
        this.totalTimeinbed,
        this.totalSleepTime,
        this.sleepEfficiency,
        this.sleepLatency,
        this.wakeupLatency,
        this.waso,
        this.outOfBedCount,
        this.lightsleepduration,
        this.deepsleepduration,
        this.hrAverage,
        this.hrMin,
        this.hrMax,
        this.rrAverage,
        this.rrMin,
        this.rrMax,
        this.breathingDisturbancesIntensity,
        this.snoring,
        this.snoringepisodecount,
        this.sleepScore,
        this.nightEvents,
        this.apneaHypopneaIndex});

  Data.fromJson(Map<String, dynamic> json) {
    wakeupduration = json['wakeupduration'];
    wakeupcount = json['wakeupcount'];
    durationtosleep = json['durationtosleep'];
    remsleepduration = json['remsleepduration'];
    durationtowakeup = json['durationtowakeup'];
    totalTimeinbed = json['total_timeinbed'];
    totalSleepTime = json['total_sleep_time'];
    sleepEfficiency = json['sleep_efficiency'];
    sleepLatency = json['sleep_latency'];
    wakeupLatency = json['wakeup_latency'];
    waso = json['waso'];
    outOfBedCount = json['out_of_bed_count'];
    lightsleepduration = json['lightsleepduration'];
    deepsleepduration = json['deepsleepduration'];
    hrAverage = json['hr_average'] ?? 0;
    hrMin = json['hr_min'];
    hrMax = json['hr_max'];
    rrAverage = json['rr_average'];
    rrMin = json['rr_min'];
    rrMax = json['rr_max'];
    breathingDisturbancesIntensity = json['breathing_disturbances_intensity'];
    snoring = json['snoring'];
    snoringepisodecount = json['snoringepisodecount'];
    sleepScore = json['sleep_score'];
    nightEvents = json['night_events'];
    apneaHypopneaIndex = json['apnea_hypopnea_index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wakeupduration'] = wakeupduration;
    data['wakeupcount'] = wakeupcount;
    data['durationtosleep'] = durationtosleep;
    data['remsleepduration'] = remsleepduration;
    data['durationtowakeup'] = durationtowakeup;
    data['total_timeinbed'] = totalTimeinbed;
    data['total_sleep_time'] = totalSleepTime;
    data['sleep_efficiency'] = sleepEfficiency;
    data['sleep_latency'] = sleepLatency;
    data['wakeup_latency'] = wakeupLatency;
    data['waso'] = waso;
    data['out_of_bed_count'] = outOfBedCount;
    data['lightsleepduration'] = lightsleepduration;
    data['deepsleepduration'] = deepsleepduration;
    data['hr_average'] = hrAverage;
    data['hr_min'] = hrMin;
    data['hr_max'] = hrMax;
    data['rr_average'] = rrAverage;
    data['rr_min'] = rrMin;
    data['rr_max'] = rrMax;
    data['breathing_disturbances_intensity'] =
        breathingDisturbancesIntensity;
    data['snoring'] = snoring;
    data['snoringepisodecount'] = snoringepisodecount;
    data['sleep_score'] = sleepScore;
    data['night_events'] = nightEvents;
    data['apnea_hypopnea_index'] = apneaHypopneaIndex;
    return data;
  }
}