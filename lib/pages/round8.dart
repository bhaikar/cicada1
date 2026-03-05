import 'package:cicada1/pages/round9.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class QuestionEight extends StatefulWidget {
  final String phoneNumber;
  QuestionEight({required this.phoneNumber});

  @override
  State<QuestionEight> createState() => _QuestionEightState();
}

class _QuestionEightState extends State<QuestionEight> {
  final TextEditingController _acontroller1 = TextEditingController();
  final TextEditingController _acontroller2 = TextEditingController();
  final TextEditingController _acontroller3 = TextEditingController();
  final TextEditingController _acontroller4 = TextEditingController();
  final TextEditingController _acontroller5 = TextEditingController();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/videos/round8.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _acontroller1.dispose();
    _acontroller2.dispose();
    _acontroller3.dispose();
    _acontroller4.dispose();
    _acontroller5.dispose();
    _controller.dispose();
    super.dispose();
  }

  void correct() {
    setState(
      () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "That's right!!",
          text: 'You have cleared Round 8',
          confirmBtnText: 'Next Round',
          barrierDismissible: false,
          onConfirmBtnTap: () async {
            FirebaseFirestore _firestore = FirebaseFirestore.instance;
            try {
              String nextRound = '9';
              await _firestore
                  .collection('users')
                  .doc(widget.phoneNumber)
                  .update({
                'nextRound': nextRound,
              });
            } catch (e) {
              print('Error updating round: $e');
            }
            _controller.pause();
            Navigator.pushReplacement(
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

  void wrong(String wrongAnswer) {
    setState(
      () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Wrong answer',
          text: 'List of wrong answers$wrongAnswer.\n2 mins added to your time',
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
            } catch (e) {
              print('Error updating penalty time: $e');
            }
            _controller.pause();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    QuestionEight(phoneNumber: widget.phoneNumber),
              ),
            );
          },
        );
      },
    );
  }

  void checkAnswer() {
  var wrongAnswer = "";

  if (_acontroller1.text.trim().toLowerCase() != "21") {
    wrongAnswer = "$wrongAnswer 1";
    wrong(wrongAnswer);
  } else {
    correct();
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
              "Round 8",
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                const SizedBox(
                  height: 20.0,
                ),
               _controller.value.isInitialized
  ? Container(
      width: 350,
      height: 405, // or any height you prefer
      child: VideoPlayer(_controller),
    )
                    : Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Find the number of dancing girls in the video.\nAnswer Format: 11",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _acontroller1,
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