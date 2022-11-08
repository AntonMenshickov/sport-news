import 'package:flutter/material.dart';
import 'package:sport_news/screens/loading_screen.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sport News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoaderScreen(),
    );
  }
}
