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
      if (value.data()!.keys.contains("correction") && value['correction'] != "Perfect")  {
        list = value['correction'].values.cast<List<dynamic>>().toList();
      }
    });
    print(list);
    return list;
  }

  void goHome() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const MyApp()));

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
