import 'package:cloud_firestore/cloud_firestore.dart';
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
          if (doc.id != 'user_info') {
            list.add(doc.data());
          }
        }
      },
    );
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

Widget _buildMemoList(data) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(8),
    itemCount: data.length,
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
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${data[index]['title']}'),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: (){},
                          child: const Text('삭제'),
                        ),
                      ];
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
