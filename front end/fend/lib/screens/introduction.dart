import 'package:fend/screens/signUp/signUpSID.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      onDone: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      },
      onSkip: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      },
      showNextButton: false,
      showDoneButton: true,
      showSkipButton: true,
      skip: const Text("Skip",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )),
      done: const Text("Done",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Color(0xff0B7A75),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
      pages: [
        PageViewModel(
          title: "Attendance",
          body:
              "An easy and Intuitive way of keeping track of your lectures, labs as well as tutorials for all your subjects.",
          image: Image.asset('assets/attendance.png'),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
                color: Color(0xff0B7A75),
                fontWeight: FontWeight.w700,
                fontSize: 30),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            imageFlex: 7,
            bodyFlex: 5,
          ),
        ),
        PageViewModel(
          title: "Time Table",
          body:
              "Giving you the ability to mark your calendar with all your classes along with personal events.",
          image: Image.asset('assets/timetable.png'),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
                color: Color(0xff0B7A75),
                fontWeight: FontWeight.w700,
                fontSize: 30),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            imageFlex: 7,
            bodyFlex: 5,
          ),
        ),
        PageViewModel(
          title: "Study Material",
          body:
              "A super handy compilation of all the study material you need to ace those tests and subjects.",
          image: Image.asset('assets/studymaterial.png'),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
                color: Color(0xff0B7A75),
                fontWeight: FontWeight.w700,
                fontSize: 30),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            imageFlex: 7,
            bodyFlex: 5,
          ),
        ),
        PageViewModel(
          title: "PecSocial",
          body:
              "An extremely convenient avenue to stay in touch with your social life by being able to search for your college students and getting general information about their year, branch, clubs etc.",
          image: Image.asset('assets/Pecsocial.png'),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
                color: Color(0xff0B7A75),
                fontWeight: FontWeight.w700,
                fontSize: 30),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            imageFlex: 7,
            bodyFlex: 5,
          ),
        ),
        PageViewModel(
          title: "Custom Reminders",
          body:
              "Helping you stay on top of all your activities by creating reminders as well as getting notifications from your CRs and respective Club seccys about important quizzes or events.",
          image: Image.asset('assets/custom_reminders.png'),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
                color: Color(0xff0B7A75),
                fontWeight: FontWeight.w700,
                fontSize: 30),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            imageFlex: 7,
            bodyFlex: 5,
          ),
        ),
      ],
    );
  }
}
