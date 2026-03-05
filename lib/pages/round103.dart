import 'package:cicada1/pages/round104.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

class R1 {
  final List<Map<String, String>> _question1 = [
    {
      "question":
          " 1+2=123\n2+3=165\n3+4=1127\n7+8=15615\n6+3=?\nAnswer format: 12345",
      "answer": "-3189",
    }
  ];
}

class QuestionThreeOfOne extends StatefulWidget {
  late final String phoneNumber;
  QuestionThreeOfOne({required this.phoneNumber});

  @override
  State<QuestionThreeOfOne> createState() => _QuestionThreeOfOneState();
}

class _QuestionThreeOfOneState extends State<QuestionThreeOfOne> {
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
        _controller.text.trim().toLowerCase() == "seven") {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "That's right!!",
            text: 'Question 3/5 done',
            confirmBtnText: 'Next question',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
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
                      QuestionThreeOfOne(phoneNumber: widget.phoneNumber),
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
            child: Text("Question 3/5"),
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
