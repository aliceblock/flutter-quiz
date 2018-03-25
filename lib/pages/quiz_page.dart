import 'package:flutter/material.dart';

import '../UI/answer_button.dart';
import '../UI/correct_wrong_overlay.dart';
import '../UI/question_text.dart';
import '../utils/question.dart';
import '../utils/quiz.dart';
import 'score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => new _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz =  new Quiz([
    new Question("Elon Musk is human?", false),
    new Question("Pizza is healthy?", true),
    new Question("Tony Stark is Iron Man?", true),
    new Question("Cat has four legs?", true),
  ]);
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = currentQuestion.answer == answer;
    quiz.answer(isCorrect);
    setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( // This is our main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false)),
          ],
        ),
        overlayShouldBeVisible? new CorrectWrongOverlay(
          isCorrect,
          () {
            currentQuestion = quiz.nextQuestion;
            if(currentQuestion != null) {
              setState(() {
                overlayShouldBeVisible = false;
                questionText = currentQuestion.question;
                questionNumber = quiz.questionNumber;
              });
            } else {
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)), (Route route) => route.isFirst);
            }
          }
        ): new Container(),
      ],
    );
  }
}