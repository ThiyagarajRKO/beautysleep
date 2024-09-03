import 'package:get_storage/get_storage.dart';

class AppPreference {
  static const STORAGE_NAME = 'OuraRing';
  static const RING_TOKEN = 'RING_TOKEN';
  static const BED_TOKEN = 'BED_TOKEN';


  static const leadEvaluationStatusLabel = "feature_permission_lead_evaluation";

  final _storage = GetStorage(STORAGE_NAME);

  Future<void> init() async {
    await _storage.initStorage;
  }

  updateRingToken(String ringToken) {
    _storage.write(RING_TOKEN, ringToken);
  }

  String get ringToken {
    try {
      return _storage.read(RING_TOKEN);
    } catch (e) {
      return "";
    }
  }

  updateBedToken(String ringToken) {
    _storage.write(BED_TOKEN, ringToken);
  }

  String get getBedToken {
    try {
      return _storage.read(BED_TOKEN);
    } catch (e) {
      return "";
    }
  }


  void clearData() {
    _storage.erase();
  }
}
