import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MemoPiechart extends StatefulWidget {
  const MemoPiechart({super.key});

  @override
  State<MemoPiechart> createState() => _MemoPiechartState();
}

class _MemoPiechartState extends State<MemoPiechart> {
  Map data = {};
  List<PieChartSectionData> list = [];
  Future getPieChartData() async {
    final db = FirebaseFirestore.instance;
    final firebaseAuth = FirebaseAuth.instance;
    await db.collection(firebaseAuth.currentUser!.uid).get().then((value) {
      for (var element in value.docs) {
        if (element.data().keys.contains("correction") &&
            element['correction'] != null &&
            element['correction'] != "Perfect") {
          element['correction'].values.cast<List<dynamic>>().forEach((element) {
            if (data[element[0]] == null) {
              data[element[0]] = 1;
            } else {
              data[element[0]] += 1;
            }
          });
        }
      }
    });

    Color getRandomBrightColor() {
      Random random = Random();
      double hue = random.nextDouble() * 360;
      double saturation = 0.5 + random.nextDouble() * 0.5;
      double lightness = 0.7 + random.nextDouble() * 0.3;
      return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
    }

    data.forEach((key, value) {
      list.add(
        PieChartSectionData(
          value: value.toDouble(),
          title: "$key | $value",
          radius: 150,
          color: getRandomBrightColor(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPieChartData(),
      builder: (context, textSnapshot) {
        if (textSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (textSnapshot.connectionState == ConnectionState.done) {
          // Check if the list has data to display
          if (list.isEmpty) {
            return const Center(child: Text('아직 틀린 문법이 없으시군요!'));
          }
          return PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              sectionsSpace: 0,
              sections: list,
            ),
          );
        } else {
          // If there's an error or no data
          return const Center(child: Text('Error fetching data'));
        }
      },
    );
  }
}
