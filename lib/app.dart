import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wasteagram/main.dart';
import './screens/list_screen.dart';
import 'package:flutter/foundation.dart' as Foundation;


class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [SentryNavigatorObserver()],
      title: 'Wasteagram',
      theme: ThemeData.dark(),
      home: ListScreen(),
    );
  }
}