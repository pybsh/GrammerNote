// memo_richtext.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MemoRichText extends StatelessWidget {
  final Future<String> originalTextFuture;
  final Future<List<List<dynamic>>> correctionsFuture;

  const MemoRichText({
    super.key,
    required this.originalTextFuture,
    required this.correctionsFuture,
  });

  // 문법 수정 요청을 Correction 객체로 변환
  List<Correction> parseCorrections(String originalText, List<List<dynamic>> corrections) {
    List<Correction> result = [];
    if (corrections.isEmpty || corrections.every((innerList) => innerList.isEmpty)) return result;
    
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
    return FutureBuilder<String>(
      future: originalTextFuture,
      builder: (context, textSnapshot) {
        if (textSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (textSnapshot.hasError) {
          return const Center(child: Text('Error fetching original text'));
        } else if (!textSnapshot.hasData || textSnapshot.data!.isEmpty) {
          return const Center(child: Text('No original text found'));
        } else {
          String originalText = textSnapshot.data!;

          return FutureBuilder<List<List<dynamic>>>(
            future: correctionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error fetching corrections'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No corrections found'));
              } else {
                // Parse the corrections once data is fetched
                List<Correction> corrections = parseCorrections(originalText, snapshot.data!);

                List<TextSpan> textSpans = [];
                int currentPos = 0;

                for (final correction in corrections) {
                  // Add normal text before the correction
                  if (currentPos < correction.position) {
                    textSpans.add(TextSpan(text: originalText.substring(currentPos, correction.position)));
                  }

                  // Highlight incorrect text and make it tappable
                  textSpans.add(
                    TextSpan(
                      text: correction.original,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _showCorrectionDialog(context, correction.correct);
                        },
                    ),
                  );
                  currentPos = correction.position + correction.original.length;
                }

                // Add the remaining text
                if (currentPos < originalText.length) {
                  textSpans.add(TextSpan(text: originalText.substring(currentPos)));
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      children: textSpans,
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  void _showCorrectionDialog(BuildContext context, String correctText) {
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