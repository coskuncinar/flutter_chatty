import 'dart:math';

class Utils {
  static final Utils _instance = Utils._internal();
  static int randomNumber({int min = 10, int max = 1000}) {
    //static int get randomNumber {
    var random = Random();
    // int xmin = 10;
    // int xmax = 1000;

    int result = min + random.nextInt(max - min);
    return result;
  }

  factory Utils() => _instance;

  //static Utils get() => _instance;

  Utils._internal();
}
