import 'package:eng_grammar_checker/widgets/memolist.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 92, left: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '반가워요, AccountName님',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                  // read about it in the PieChartData section
                  ),
              swapAnimationDuration:
                  const Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear, // Optional
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "최근에 작성한 노트",
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
