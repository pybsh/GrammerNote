import 'package:eng_grammar_checker/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrammarMemo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfff7f7f5),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}