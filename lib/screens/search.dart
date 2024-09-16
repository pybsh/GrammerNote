import 'package:eng_grammar_checker/widgets/memolist.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 92, left: 16, right: 16, bottom: 16),
            child: SearchBar(
              hintText: "제목, 내용..",
              backgroundColor: const WidgetStatePropertyAll(Color(0xffe9e9e8)),
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
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
            child: notelist_builder(),
          ),
        ],
      ),
    );
  }
}
