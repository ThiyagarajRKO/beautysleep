

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ApiCallsss extends GetConnect{


  @override
  void onInit() {
    super.onInit();
    httpClient.addResponseModifier((request, response){

      debugPrint(", rgr g" );
    });

  }


}