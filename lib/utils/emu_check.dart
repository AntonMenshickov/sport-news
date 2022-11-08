import 'package:device_info_plus/device_info_plus.dart';

Future<bool> checkIsEmu() async {
  final devinfo = DeviceInfoPlugin();
  final em = await devinfo.androidInfo;
  final String phoneModel = em.model ?? '';
  final String buildProduct = em.product ?? '';
  var buildHardware = em.hardware;
  var result = ((em.fingerprint ?? '').startsWith("generic") ||
      phoneModel.contains("google_sdk") ||
      phoneModel.contains("droid4x") ||
      phoneModel.contains("Emulator") ||
      phoneModel.contains("Android SDK built for x86") ||
      (em.manufacturer ?? '').contains("Genymotion") ||
      buildHardware == "goldfish" ||
      buildHardware == "vbox86" ||
      buildProduct == "sdk" ||
      buildProduct == "google_sdk" ||
      buildProduct == "sdk_x86" ||
      buildProduct == "vbox86p" ||
      buildProduct == "sdk_gphone_x86_arm" ||
      (em.board ?? '').toLowerCase().contains("nox") ||
      (em.bootloader ?? '').toLowerCase().contains("nox") ||
      (buildHardware ?? '').toLowerCase().contains("nox") ||
      buildProduct.toLowerCase().contains("nox"));
  if (result && !(em.isPhysicalDevice ?? true)) return true;
  result = result ||
      ((em.brand ?? '').startsWith("generic") &&
          (em.device ?? '').startsWith("generic"));
  if (result && !(em.isPhysicalDevice ?? true)) return true;
  result = result || ("google_sdk" == buildProduct);
  return result && !(em.isPhysicalDevice ?? true);
}
