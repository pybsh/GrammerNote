import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _MemoState();
}

class _MemoState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 92, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.insert_photo),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: null,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 32),
          child: TextField(
            cursorColor: Colors.black,
            style: TextStyle(fontSize: 24),
            decoration: InputDecoration(
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
          padding: EdgeInsets.only(left: 32),
          child: SizedBox(
            height: 600,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: Colors.black,
              decoration: InputDecoration(
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
