import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_grammar_checker/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class Note extends StatefulWidget {
  final bool isNew;
  final String? id;

  const Note({
    required this.isNew,
    this.id,
    super.key,
  });

  @override
  State<Note> createState() => _MemoState();
}

class _MemoState extends State<Note> {
  final db = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void saveMemo() {
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

    var id = widget.id;
    id ??= const Uuid().v4();
    db.collection(firebaseAuth.currentUser!.uid).doc(id).set({
      'title': _titleController.text,
      'content': _contentController.text,
      if (widget.isNew) 'gen_date': Timestamp.fromDate(DateTime.now()),
      'edit_date': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
    snedReq(id);
    goHome();
  }

  Future<http.Response> snedReq(String docId) {
    return http.post(
      Uri.parse(dotenv.env['IP']!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': firebaseAuth.currentUser!.uid,
        'doc_id': docId,
      }),
    );
  }

  void goHome() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const MyApp()));

  @override
  void initState() {
    if (!widget.isNew) {
      db.collection(firebaseAuth.currentUser!.uid).doc(widget.id).get().then(
        (value) {
          _titleController.text = value['title'];
          _contentController.text = value['content'];
        },
      );
    }
    super.initState();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (!widget.isNew)
                      IconButton(
                        alignment: Alignment.centerLeft,
                        icon: const Icon(Icons.keyboard_arrow_left),
                        onPressed: goHome,
                      ),
                  ],
                ),
                Row(
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
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
            padding: const EdgeInsets.only(left: 32, right: 32),
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
      ),
    );
  }
}
