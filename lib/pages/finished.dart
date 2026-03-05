import 'package:flutter/material.dart';

class Finished extends StatefulWidget {
  const Finished({super.key});

  @override
  State<Finished> createState() => _FinishedState();
}

class _FinishedState extends State<Finished> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 300.0),
            child: Center(
              child: Text(
                "Congratulations\nYou have finished the online round\nPlease wait for the results.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
