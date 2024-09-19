import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_grammar_checker/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _MemoState();
}

class _MemoState extends State<Note> {
  final db = FirebaseFirestore.instance;

  final firebaseAuth = FirebaseAuth.instance;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void saveMemo() {
    const uuid = Uuid();
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('내용 비어 있음.'),
            content: const Text('내용을 채워주세요.'),
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
      return;
    }
    db.collection(firebaseAuth.currentUser!.uid).doc(uuid.v4()).set({
      'title': _titleController.text,
      'content': _contentController.text,
      'gen_date': Timestamp.fromDate(DateTime.now()),
    });
    goHome();
  }

  void goHome() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const MyApp()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 92, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const IconButton(
                icon: Icon(Icons.insert_photo),
                onPressed: null,
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: saveMemo,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: TextField(
            controller: _titleController,
            cursorColor: Colors.black,
            style: const TextStyle(fontSize: 24),
            decoration: const InputDecoration(
              hintText: "제목",
              hintStyle: TextStyle(fontSize: 24),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SizedBox(
            height: 600,
            child: TextField(
              controller: _contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: "내용",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
