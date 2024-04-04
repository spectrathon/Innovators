import 'package:flutter/widgets.dart';

class ScorePro extends ChangeNotifier{

  int _score = 0;

  int get score => _score;

  setScore(int newScore){
    _score = newScore;
    notifyListeners();
  }

}
