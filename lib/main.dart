import 'package:eng_grammar_checker/app.dart';
import 'package:eng_grammar_checker/firebase_options.dart';
import 'package:eng_grammar_checker/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  bool getCurrentUser() {
    final firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    return user != null;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrammarMemo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfff7f7f5),
        useMaterial3: true,
      ),
      home: getCurrentUser() ? const App() : const Register(),
    );
  }
}
