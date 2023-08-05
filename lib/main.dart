import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chats_app/screens/authscreen.dart';
import 'package:firebase_chats_app/screens/chatscreen.dart';
import 'package:firebase_chats_app/screens/splashscreen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: StreamBuilder(
          //////check if state changes ,for ex we get sign in token automatically
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return splashcreen();
            }

            if (snapshot.hasData) {
              return chatscreen();
            }
            return authscreen();
          }),
    );
  }
}
