import 'package:hive/hive.dart';

import '../main.dart';

part 'adapters/lecture.g.dart';

@HiveType(typeId: 1)
class Lecture {
  @HiveField(1)
  String subject;

  @HiveField(2)
  String day;

  @HiveField(3)
  String startingTime;

  @HiveField(4)
  String endingTime;

  @HiveField(5)
  String place;

  @HiveField(6)
  late int value; //used for sorting

  @HiveField(7)
  late int dayNum; //used in calculation when displaying daily schedule

  /*
   starting time for lecture could be [8,9,10,11,12,1,2,3] => 8 times
   day could be [sat,sun,...friday] => 6 days

   which means we have => 8*6 = 48 possible time for any lecture

   Now each each possible time  has a uniqe value (incremental value)

   value = number of day[first day = 0] * 8 + time 
  */

  Lecture({
    required this.subject,
    required this.day,
    required this.startingTime,
    required this.endingTime,
    required this.place,
  }) {
    value =
        calculateValue(day, startingTime); //value is calculated automatically
    switch (day) {
      case 'السبت':
        dayNum = 6;
        break;

      case 'الأحد':
        dayNum = 7;
        break;

      case 'الاثنين':
        dayNum = 1;
        break;

      case 'الثلاثاء':
        dayNum = 2;
        break;

      case 'الأربعاء':
        dayNum = 3;
        break;

      case 'الخميس':
        dayNum = 4;
        break;

      default:
        dayNum = 5; //friday
    }
  }

  int calculateValue(String day, String startingTime) {
    int result = 0;

    switch (day) {
      case 'السبت':
        result = 0;
        break;

      case 'الأحد':
        result = 8;
        break;

      case 'الاثنين':
        result = 16;
        break;

      case 'الثلاثاء':
        result = 24;
        break;

      case 'الأربعاء':
        result = 32;
        break;

      case 'الخميس':
        result = 40;
        break;
    }

    switch (startingTime) {
      case '8':
        return result = result + 1;

      case '9':
        return result = result + 2;

      case '10':
        return result = result + 3;

      case '11':
        return result = result + 4;

      case '12':
        return result = result + 5;

      case '1':
        return result = result + 6;

      case '2':
        return result = result + 7;

      case '3':
        return result = result + 8;
    }

    return 0; // this line has no meaning (JUST TO PLEASE THE STUPID COMPILER)
  }

  static var lecturesList = lecturesBox.values.toList();

  //List<Lecture>

  static void updateLecturesBox() async {
    //Clears the box ,Then takes all lectures from lectures list in the same order
    await lecturesBox.clear();
    await lecturesBox.addAll(lecturesList);
  }

  static void sortLecturesList() {
    lecturesList.sort((a, b) {
      return a.value.compareTo(b.value);
    });

    updateLecturesBox();
  }

  static void addLecture(Lecture lecture) {
    lecturesList.add(lecture);
    updateLecturesBox();
  }

  static void deleteLecture(Lecture lecture) {
    lecturesList.remove(lecture);

    updateLecturesBox();
  }

  static void deleteLectureAtNumber(int number) {
    lecturesList.removeAt(number - 1);

    updateLecturesBox();
  }

  static Box<Lecture> get lecturesBox {
    return Hive.box<Lecture>(lecturesBoxName);
  }
}
