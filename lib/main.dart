import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'utils/pref_helper.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final String savedName = await PrefHelper.getUserName();

  runApp(MyApp(savedName: savedName));
}

class MyApp extends StatelessWidget {
  final String savedName;

  const MyApp({super.key, required this.savedName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tudee',
      home: savedName.isNotEmpty ? const HomeScreen() : const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
