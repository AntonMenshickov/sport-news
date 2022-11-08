import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

Future<bool> checkSim() async {
  String platformVersion;
  try {
    platformVersion = (await FlutterSimCountryCode.simCountryCode)!;
  } on PlatformException {
    platformVersion = 'Failed';
  }

  return platformVersion.length != 2;
}
