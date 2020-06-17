import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class Calculator {
  final int height;
  final int weight;
  final int age;
  final String gender;

  double bmi;
  String resultTitle;
  String resultDescription;
  Color color;

  Calculator({
    @required this.height,
    @required this.weight,
    @required this.age,
    @required this.gender,
  });

  double getBMIFun() {
    bmi = (weight / pow(height / 100, 2));
    return bmi;
  }

  void getResultFun() {
    if (bmi <= 15) {
      resultTitle = 'Very severely underweight';
      color = Colors.yellow[500];
      resultDescription =
          'Risk of developing problems such as nutritional deficiency and osteoporosis 🦴';
    } else if (bmi <= 16) {
      resultTitle = 'Severely underweight';
      color = Colors.lime[700];
      resultDescription =
          'You need to eat some good Nutritious food like Vegetables 🥦 and Legumes';
    } else if (bmi <= 18.5) {
      resultTitle = 'Underweight';
      color = Colors.greenAccent;
      resultDescription =
          'You have a lower than the normal body weight. You can eat 🍖 a bit more.';
    } else if (bmi <= 25) {
      resultTitle = 'Normal (healthy range)';
      color = Colors.green[800];
      resultDescription = 'You have a Perfect 👌 body weight. Good job 🥳';
    } else if (bmi <= 30) {
      resultTitle = 'Overweight';
      color = Colors.orange[700];
      resultDescription =
          'You need some exercise to reach the Perfect body weight, let\'s run 🏃‍♂‍ 5 minutes';
    } else if (bmi <= 35) {
      resultTitle = 'Obese Class I \n(Moderately obese)';
      color = Colors.redAccent;
      resultDescription =
          'You have a higher than normal body weight. Try to exercise 🏋️‍♂‍ more.';
    } else if (bmi <= 25) {
      resultTitle = 'Obese Class II \n(Severely obese)';
      color = Colors.red;
      resultDescription =
          'Moderate risk of developing heart disease, high blood pressure, stroke, diabetes 🤒';
    } else {
      resultTitle = 'Obese Class III \n(Very severely obese)';
      color = Colors.red[900];
      resultDescription =
          'High risk of developing heart disease, high blood pressure, stroke, diabetes 💀';
    }
  }
}
