import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_grammar_checker/app.dart';
import 'package:eng_grammar_checker/screens/checker.dart';
import 'package:eng_grammar_checker/screens/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 92, left: 16, right: 16, bottom: 16),
            child: SearchBar(
              controller: _searchController,
              hintText: "제목, 내용..",
              backgroundColor: const WidgetStatePropertyAll(Color(0xffe9e9e8)),
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 32),
            child: Text(
              "검색 결과",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff787774),
              ),
            ),
          ),
          Expanded(
            child: notelist_builder(_searchQuery),
          ),
        ],
      ),
    );
  }
}

Widget notelist_builder(String searchQuery) {
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

    // Filter list based on search query
    if (searchQuery.isNotEmpty) {
      list = list.where((doc) {
        var title = doc['title'].toLowerCase();
        var content = doc['content'].toLowerCase();
        return title.contains(searchQuery) || content.contains(searchQuery);
      }).toList();
    }

    return list;
  }

  return FutureBuilder(
    future: getMemoList(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return _buildMemoList(snapshot.data);
        } else {
          return const Center(
            child: Text('검색 결과가 없습니다.'),
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