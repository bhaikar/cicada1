import 'package:cicada1/pages/round101.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Rules extends StatefulWidget {
  final String phoneNumber;
  Rules({required this.phoneNumber});

  @override
  State<Rules> createState() => RulesState();
}

class RulesState extends State<Rules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 31, 59),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rules",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 20, 31, 59),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: const Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: Text(
                "1. Completion of all 10 rounds is required for your results to be stored in our database.\n2. The start time is recorded when the start button is pressed.\n3. If more than one device from a team is connected to the app , the team will be disqualified. (Only 1 person should download the mobile application).\n4. Always keep your device connected to the internet , If not your progress might not be saved.\n5. The result calculation involves the difference between the user's start time and end time.\n6. Incorrect responses will add two minutes to your time.\n7. In the rare event of an application malfunction, try restarting the application; your progress will be saved after pressing the submit button for each round.\n8. Only the top 15 participants, evaluated based on time, will advance to the final offline round.\n9. In the case of application failure (even after restarting the application) please contact our Team.\n10. DevOps disclaims responsibility for any harm or loss of valuable items in the playing arena.\n11. Don't click any buttons twice.\n12. Do not navigate back at any time.",
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white,fontSize: 13.0),
                              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 70.0),
              child: ElevatedButton(
                onPressed: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: 'Are you ready!!',
                    text: 'Your time will starts now',
                    confirmBtnText: 'Start',
                    onConfirmBtnTap: () async {
                      late DateTime startTime;
                      startTime = DateTime.now();
                      FirebaseFirestore _firestore = FirebaseFirestore.instance;
                      try {
                        await _firestore
                            .collection('users')
                            .doc(widget.phoneNumber)
                            .update({
                          'startTime': startTime,
                        });
                      } catch (e) {
                        print('Error comparing values: $e');
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuestionOne(phoneNumber: widget.phoneNumber),
                        ),
                      );
                    },
                  );
                },
                child: const Text("Start"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
