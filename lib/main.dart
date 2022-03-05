// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/lecture.dart';
import 'models/link.dart';
import 'models/note.dart';
import 'models/subject.dart';
import 'screens/subjects_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/daily_schedule_screen.dart';
import 'themes/themes.dart';

const lecturesBoxName = 'LecturesBox';
const subjectBoxName = 'SubjectsBox';
Future<void> main() async {
  //Hive related code...........................................................

  /* IMPORTANT NOTE: IF YOU HAVE ADDED SOMETHING NEW TO BE STORED IN THE HIVE BOX
     YOU MAY HAVE AN ERROR THAT SAYS (NULL IS NOT SUBTYPE OF..) TO FIX THIS YOU HAVE TO
     DELETE THE APP ,THEN RECOMPILE THIS SHOULD FIX IT 
  */
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LectureAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(LinkAdapter());
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox('box');
  await Hive.openBox<Lecture>(lecturesBoxName);
  await Hive.openBox<Subject>(subjectBoxName);

  //.............................................................................
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University',
      theme: Themes.lightTheme,
      // flutter detects if the system is in dark mode ,and it will use the theme in the attribue (darkTheme)
      darkTheme: Themes.darkTheme,
      home: HomePage(),
    );
  }
}

/////////////////////////////////////////// here the code for the actual UI \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
class HomePage extends StatefulWidget {
  var x = true;

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const isLightTheme = true;
  int _currentIndex = 0;
  final List _children = [
    DailySchedule(),
    Schedule(),
    SubjectsScreen(
      theme: isLightTheme ? Themes.lightTheme : Themes.darkTheme,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('University')),
      body: _children[
          _currentIndex], //the widget that will be displayed between our app bar and bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'daily Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books),
            label: 'Subjects',
          ),
        ],
      ),
    );
  }
}
