import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/views/auth/loagin_page.dart';
 

import 'firebase_options.dart';
 
import 'package:flutter/material.dart';

import 'views/videos/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch<AuthService>(authProvider);

    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
