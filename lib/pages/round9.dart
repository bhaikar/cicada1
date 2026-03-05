import 'package:cicada1/pages/round1001.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

class R9 {
  final List<Map<String, String>> _question9 = [
    {
      "question":
          "On which date is the prelude poster of the HACK.MCE 5.0 posted in devops_malnad account?\nAnswer format: 5th October 2024",
      "answer": "16th November 2025",
    },
  ];
}

class QuestionNine extends StatefulWidget {
  final String phoneNumber;
  QuestionNine({required this.phoneNumber});

  @override
  State<QuestionNine> createState() => _QuestionNineState();
}

class _QuestionNineState extends State<QuestionNine> {
  final R9 questionProvider = R9();
  late Map<String, String> currentQuestion;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentQuestion = questionProvider._question9[0];
  }

  void checkAnswer() {
    if (_controller.text.trim().toLowerCase() ==
        currentQuestion['answer']?.toLowerCase()) {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "That's right!!",
            text: 'You have cleared Round 9',
            confirmBtnText: 'Next round',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                String nextRound = '10';
                await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .update({
                  'nextRound': nextRound,
                });
              } catch (e) {}
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuestionTen(phoneNumber: widget.phoneNumber),
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
                      QuestionNine(phoneNumber: widget.phoneNumber),
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
              "Question 9 [Instagram]",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Form a word from following hints",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ),
            const Text(
              "hint: Devops Malnad Insta id",
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w200),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${currentQuestion['question']}',
                style: const TextStyle(fontSize: 20.0),
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
      ),
    );
  }
}
