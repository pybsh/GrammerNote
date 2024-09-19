import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Checker extends StatefulWidget {
  const Checker({super.key});

  @override
  State<Checker> createState() => _CheckerState();
}

class _CheckerState extends State<Checker> {
  final String originalText = "what be the reason for everyone leave the comapny";

  // 원본 문법 수정 요청 구문
  final List<List<dynamic>> grammarCorrections = [
    ['VERB:FORM', 'leave', 6, 7, 'leaving', 6, 7],
    ['SPELL', 'comapny', 8, 9, 'company', 8, 9],
  ];

  // 문법 수정 요청을 Correction 객체로 변환
  List<Correction> parseCorrections(List<List<dynamic>> corrections) {
    List<Correction> result = [];
    for (var correction in corrections) {
      String originalWord = correction[1];
      String correctedWord = correction[4];
      int position = originalText.indexOf(originalWord);
      if (position != -1) {
        result.add(Correction(original: originalWord, correct: correctedWord, position: position));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // 문법 수정 요청을 파싱하여 Correction 객체 리스트로 변환
    List<Correction> corrections = parseCorrections(grammarCorrections);

    List<TextSpan> textSpans = [];
    int currentPos = 0;

    for (final correction in corrections) {
      // 정상적인 텍스트 추가
      if (currentPos < correction.position) {
        textSpans.add(TextSpan(text: originalText.substring(currentPos, correction.position)));
      }

      // 수정이 필요한 텍스트를 감지하고 GestureDetector로 처리
      textSpans.add(
        TextSpan(
          text: correction.original,
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _showCorrectionDialog(correction.correct);
            },
        ),
      );
      currentPos = correction.position + correction.original.length;
    }

    // 남은 텍스트 추가
    if (currentPos < originalText.length) {
      textSpans.add(TextSpan(text: originalText.substring(currentPos)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grammar Correction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 18, color: Colors.black),
            children: textSpans,
          ),
        ),
      ),
    );
  }

  void _showCorrectionDialog(String correctText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Correction'),
          content: Text('Correct word: $correctText'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Correction {
  final String original;
  final String correct;
  final int position;

  Correction({required this.original, required this.correct, required this.position});
}