import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget notelist_builder() {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(8),
    itemCount: 5,
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text('Entry $index')),
        ),
      );
    },
  );
}
