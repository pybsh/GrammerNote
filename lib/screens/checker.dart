// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_grammar_checker/main.dart';
import 'package:eng_grammar_checker/widgets/memo_richtext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Checker extends StatefulWidget {
  final String memo_id;
  const Checker({required this.memo_id, super.key});

  @override
  State<Checker> createState() => _CheckerState();
}

class _CheckerState extends State<Checker> {
  final db = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  String title = "";

  // Simulate fetching original text from a backend service
  Future<String> fetchOriginalText() async {
    var str = "";
    await db
        .collection(firebaseAuth.currentUser!.uid)
        .doc(widget.memo_id)
        .get()
        .then((value) {
      str = value['content'];
    });
    return str;
  }

  Future<String> fetchTitle() async {
    var str = "";
    await db
        .collection(firebaseAuth.currentUser!.uid)
        .doc(widget.memo_id)
        .get()
        .then((value) {
      str = value['title'];
    });
    return str;
  }

  // Simulate fetching grammar corrections from a backend service
  Future<List<List<dynamic>>> fetchGrammarCorrections() async {
    var list = [[]];
    await db
        .collection(firebaseAuth.currentUser!.uid)
        .doc(widget.memo_id)
        .get()
        .then((value) {
      if (value.data()!.keys.contains("correction") &&
          value['correction'] != null &&
          value['correction'] != "Perfect") {
        list = value['correction'].values.cast<List<dynamic>>().toList();
      } else {
        _showMyDialog();
      }
    });
    return list;
  }

  void goHome() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const MyApp()));

  bool isDialogShowing = false;

  Future<void> _showMyDialog() async {
    if (isDialogShowing) return; // Prevents showing the dialog multiple times
    isDialogShowing = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('문법 검사가 진행중입니다.'),
                Text('계속해서 이 알림이 등장한다면 노트를 재저장해주세요.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                isDialogShowing = false; // Reset flag after dialog is closed
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTitle().then((fetchedTitle) {
      setState(() {
        title = fetchedTitle;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 92, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.keyboard_arrow_left),
                  onPressed: goHome,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: SizedBox(
              height: 600,
              child: MemoRichText(
                originalTextFuture: fetchOriginalText(),
                correctionsFuture: fetchGrammarCorrections(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
