import 'package:cicada1/pages/finished.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class QuestionFiveOfTen extends StatefulWidget {
  final String phoneNumber;
  QuestionFiveOfTen({required this.phoneNumber});

  @override
  State<QuestionFiveOfTen> createState() => _QuestionFiveOfTenState();
}

class _QuestionFiveOfTenState extends State<QuestionFiveOfTen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void checkAnswer() {
    if (_controller.text.trim().toLowerCase() == "b") {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "That's right!!",
            text: 'You have finished all the rounds',
            confirmBtnText: 'Okay',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
              late DateTime endTime;
              endTime = DateTime.now();
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                DocumentSnapshot doc = await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .get();
                String nextRound = "11";
                DateTime startTime = doc['startTime'].toDate();
                Duration elapsed = DateTime.now().difference(startTime);
                var penaltyTime = doc['penaltyTime'];
                var tTinS = elapsed.inSeconds + penaltyTime;
                var tTinMin = tTinS / 60.0;
                await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .update({
                  'endTime': endTime,
                  'timeTaken': tTinS,
                  'nextRound': nextRound,
                  'tTinMin': tTinMin,
                });
              } catch (e) {}
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Finished(),
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
                      QuestionFiveOfTen(phoneNumber: widget.phoneNumber),
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
              "Round 10",
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
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Question 5/5"),
                const SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'lib/assets/images/round10q5.png',
                  width: 300,
                  height: 350,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter your answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
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
        ),
      ),
    );
  }
}
