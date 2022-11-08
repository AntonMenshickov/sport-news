import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_news/screens/message_screen.dart';
import 'package:sport_news/screens/placeholder_screen.dart';
import 'package:sport_news/screens/webview_screen.dart';
import 'package:sport_news/utils/check_sim.dart';
import 'package:sport_news/utils/emu_check.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  final Completer<CheckResult> _completer = Completer();

  @override
  void initState() {
    _checkDevice();
    super.initState();
  }

  _checkDevice() async {
    final bool simValid = await checkSim();
    if (!simValid) {
      return _completer.complete(CheckResult(true, ''));
    }
    final ConnectivityResult connection =
        await Connectivity().checkConnectivity();
    bool showPlaceHolder = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url') ?? '';
    if (connection == ConnectivityResult.mobile ||
        connection == ConnectivityResult.wifi) {
      if (url.isEmpty) {
        try {
          final remoteConfig = FirebaseRemoteConfig.instance;
          await remoteConfig.ensureInitialized();
          await remoteConfig.setConfigSettings(RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval: const Duration(hours: 1),
          ));
          final bool activated = await remoteConfig.fetchAndActivate();
          url = remoteConfig.getString('url');
        } catch (e) {
          return _completer.complete(CheckResult(true, '', e));
        }
      }
      final bool isEmu = await checkIsEmu();

      showPlaceHolder = false;
      if (isEmu || url.isEmpty) {
        showPlaceHolder = true;
      } else {
        await prefs.setString('url', url);
      }
    } else {
      if (url.isNotEmpty) {
        return _completer.complete(CheckResult(showPlaceHolder, url, null,
            'Для продолжения необходимо подключение к сети'));
      }
    }
    _completer.complete(CheckResult(showPlaceHolder, url));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CheckResult>(
      future: _completer.future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SafeArea(
              child: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ));
        } else {
          if (snapshot.data!.error != null) {
            return const MessageScreen(message: 'Ошибка загрузки конфигурации');
          }
          if (snapshot.data!.message != null) {
            return MessageScreen(message: snapshot.data!.message!);
          }
          return snapshot.data!.showPlaceHolder
              ? const PlaceholderScreen()
              : WebViewScreen(
                  url: snapshot.data!.url,
                );
        }
      },
    );
  }
}

class CheckResult {
  final bool showPlaceHolder;
  final String url;
  final dynamic error;
  final String? message;

  CheckResult(this.showPlaceHolder, this.url, [this.error, this.message]);
}
