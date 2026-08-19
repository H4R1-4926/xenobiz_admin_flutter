import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'app/app.dart';
import 'shared/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: p.ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const XenobizAdminApp(),
      ),
    ),
  );
}
