import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_grammar_checker/app.dart';
import 'package:eng_grammar_checker/screens/checker.dart';
import 'package:eng_grammar_checker/screens/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget notelist_builder() {
  final firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<List> getMemoList() async {
    List list = [];
    await db.collection(firebaseAuth.currentUser!.uid).get().then(
      (value) {
        for (var doc in value.docs) {
          list.add(doc);
        }
      },
    );

    list.sort((a, b) {
      var adate = a['edit_date'];
      var bdate = b['edit_date'];
      return bdate.compareTo(adate);
    });

    return list;
  }

  return FutureBuilder(
    future: getMemoList(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData) {
          return _buildMemoList(snapshot.data);
        } else {
          return const Center(
            child: Text('No data'),
          );
        }
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

void goEdit(context, id) => Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (context) => Note(isNew: false, id: id)));

void deleteMemo(context, id) {
  final firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  db.collection(firebaseAuth.currentUser!.uid).doc(id).delete();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const App()));
}

void goChecker(context, id) => Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (context) => Checker(memo_id: id)));

Widget _buildMemoList(data) {
  return ListView.builder(
    // physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(8),
    itemCount: data.length,
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${data[index]['title']}'),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.spellcheck),
                  onPressed: () => goChecker(context, data[index].id),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => goEdit(context, data[index].id),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteMemo(context, data[index].id),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
