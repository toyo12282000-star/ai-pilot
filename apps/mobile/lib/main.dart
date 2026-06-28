import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:ai_pilot/app/app.dart';
import 'package:ai_pilot/shared/providers/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  await bootstrapApp();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
