import 'package:cicada1/pages/finished.dart';
import 'package:cicada1/pages/round1001.dart';
import 'package:cicada1/pages/round2.dart';
import 'package:cicada1/pages/round3.dart';
import 'package:cicada1/pages/round4.dart';
import 'package:cicada1/pages/round5.dart';
import 'package:cicada1/pages/round6.dart';
import 'package:cicada1/pages/round7.dart';
import 'package:cicada1/pages/round8.dart';
import 'package:cicada1/pages/round9.dart';
import 'package:cicada1/pages/rules.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> compareUser() async {
    String enteredPhoneNumber = _phone.text;
    String enteredPassword = _password.text;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(enteredPhoneNumber).get();

      if (doc.exists) {
        String storedPhoneNumber = doc.id.toString();
        String storedPassword = doc['password'];
        String nextRound = doc['nextRound'];

        if (enteredPhoneNumber == storedPhoneNumber &&
            enteredPassword == storedPassword) {
          setState(() {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: "Great!!",
              text: 'You are an authenticated user',
              confirmBtnText: 'Start',
              onConfirmBtnTap: () {
                switch (nextRound) {
                  case '1':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Rules(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '2':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionTwo(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '3':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionThree(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '4':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionFour(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '5':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionFive(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '6':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionSix(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '7':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionSeven(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '8':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionEight(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '9':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionNine(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '10':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionTen(phoneNumber: enteredPhoneNumber),
                      ),
                    );
                    break;

                  case '11':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Finished(),
                      ),
                    );
                }
              },
            );
          });
        } else {
          setState(() {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'OOPS!!',
              text: 'Password incorrect',
              confirmBtnText: 'Try again',
            );
          });
        }
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'OOPS!!',
          text: 'Ticket number is not registered',
          confirmBtnText: 'Try again',
        );
      }
    } catch (e) {
      print('Error comparing values: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200.0,
          ),
          Text(
            "Login Page",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 25.0,
              color: const Color.fromARGB(255, 9, 87, 151),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Ticket number',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  width: 1.25,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: _password,
            decoration: InputDecoration(
              labelText: 'Enter password',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  width: 1.25,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: compareUser,
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
