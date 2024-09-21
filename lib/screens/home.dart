import 'package:eng_grammar_checker/main.dart';
import 'package:eng_grammar_checker/screens/register.dart';
import 'package:eng_grammar_checker/widgets/memolist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void logOut() async {
    final firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
    goHome();
  }
  
  String getAccountName() {
    final firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    return user!.displayName!;
  }
  
  void goHome() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp()));
  
  @override
  Widget build(BuildContext context) {
    String accountName = getAccountName();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 92, left: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '반가워요, $accountName님,',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: logOut,
                          child: const Text('로그아웃'),
                        ),
                      ];
                    },
                  ),
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
