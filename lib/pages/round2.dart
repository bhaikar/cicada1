import 'package:cicada1/pages/round3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class R2 {
  final List<Map<String, String>> _question2 = [
    {
      "question":
          "Decode this:\nWH47 D03S 7H3 5TRAN63 1N51GHT R3V3AL 7HROU6H 7H3 5H1MM3R1N6 7R33S?\nAnswer format: MY NAME IS DEVOPS.",
      "answer": "WHAT DOES THE STRANGE INSIGHT REVEAL THROUGH THE SHIMMERING TREES?",
    },
  ];
}

class QuestionTwo extends StatefulWidget {
  final String phoneNumber;
  QuestionTwo({required this.phoneNumber});
  @override
  State<QuestionTwo> createState() => _QuestionTwoState();
}

class _QuestionTwoState extends State<QuestionTwo> {
  final R2 questionProvider = R2();
  late Map<String, String> currentQuestion;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentQuestion = questionProvider._question2[0];
  }

  void checkAnswer() {
    if (_controller.text.trim().toLowerCase() ==
            currentQuestion['answer']?.toLowerCase() ||
        _controller.text.trim().toLowerCase() == "twenty two") {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "That's right!!",
            text: 'You have cleared Round 2',
            confirmBtnText: 'Next Round',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                String nextRound = '3';
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
                      QuestionThree(phoneNumber: widget.phoneNumber),
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
                      QuestionTwo(phoneNumber: widget.phoneNumber),
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
              "Round 2",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
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
          )
        ],
      ),
    );
  }
}
