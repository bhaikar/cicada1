import 'package:cicada1/pages/round105.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

class R1 {
  final List<Map<String, String>> _question1 = [
    {
      "question":
          "Five girls participated in a race. Maria finished before Sarah, but behind Ella. Marianne finished before Sarah and Julia.\nJulia was not last.\nIn what order did the girls finish the race?\nAnswer format: Jennie Sarah Julia Ella Benny",
      "answer": "Ella Maria Marianne Julia Sarah",
    }
  ];
}

class QuestionFourOfOne extends StatefulWidget {
  late final String phoneNumber;
  QuestionFourOfOne({required this.phoneNumber});

  @override
  State<QuestionFourOfOne> createState() => _QuestionFourOfOneState();
}

class _QuestionFourOfOneState extends State<QuestionFourOfOne> {
  final R1 questionProvider = R1();
  late Map<String, String> currentQuestion;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentQuestion = questionProvider._question1[0];
  }

  void checkAnswer() {
    if (_controller.text.trim().toLowerCase() ==
            currentQuestion['answer']?.toLowerCase() ||
        _controller.text.trim().toLowerCase() == "eeitueuti") {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "That's right!!",
            text: 'Question 4/5 done',
            confirmBtnText: 'Next question',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuestionFiveOfOne(phoneNumber: widget.phoneNumber),
                ),
              );
            },
          );
        },
      );
    } else {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Wrong answer',
            text: 'You have entered wrong answer\n2 mins added to your time',
            confirmBtnText: 'Try again',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                DocumentSnapshot userDoc = await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .get();

                var penaltyTime = userDoc['penaltyTime'];
                penaltyTime = penaltyTime + 120;
                await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .update({
                  'penaltyTime': penaltyTime,
                });
              } catch (e) {}
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuestionFourOfOne(phoneNumber: widget.phoneNumber),
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Round 1",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text("Question 4/5"),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              '${currentQuestion['question']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter your answer',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: checkAnswer,
            child: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
