import 'package:cicada1/pages/round2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

class R1 {
  final List<Map<String, String>> _question1 = [
    {
      "question": """Alice and Betty are playing "guess my word." 
Betty thinks of a six-letter word (all distinct letters), and Alice guesses. 
For each guess, Betty tells Alice how many letters from her guess are right.

Alice's Guess       Betty's Answer
---------------------------------
MIRDOX                   2
MATRIX                   0
VASTLY                   2
TEACUP                   2
CULTRY                   0
?                        6

Answer format: TRUCKS.""",
      "answer": "DEVOPS",
    }
  ];
}

class QuestionFiveOfOne extends StatefulWidget {
  late final String phoneNumber;
  QuestionFiveOfOne({required this.phoneNumber});

  @override
  State<QuestionFiveOfOne> createState() => _QuestionFiveOfOneState();
}

class _QuestionFiveOfOneState extends State<QuestionFiveOfOne> {
  final R1 questionProvider = R1();
  late Map<String, String> currentQuestion;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentQuestion = questionProvider._question1[0];
  }

  Widget _buildGuessRow(String guess, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(guess, style: const TextStyle(fontSize: 16.0)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              answer,
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
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
            text: 'Question 5/5 done',
            confirmBtnText: 'Next Round',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                String nextRound = '2';
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
                      QuestionTwo(phoneNumber: widget.phoneNumber),
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
                      QuestionFiveOfOne(phoneNumber: widget.phoneNumber),
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
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text("Question 5/5"),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alice and Betty are playing "guess my word."\nBetty thinks of a six-letter word (all distinct letters), and Alice guesses.\nFor each guess, Betty tells Alice how many letters from her guess are right.\n',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Alice's Guess",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Betty's Answer",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1),
                      _buildGuessRow("MIRDOX", "2"),
                      _buildGuessRow("MATRIX", "0"),
                      _buildGuessRow("VASTLY", "2"),
                      _buildGuessRow("TEACUP", "2"),
                      _buildGuessRow("CULTRY", "0"),
                      _buildGuessRow("?", "6"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Answer format: TRUCKS.',
                  style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                ),
              ],
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