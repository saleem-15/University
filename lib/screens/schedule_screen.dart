// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../models/lecture.dart';
import '../models/subject.dart';
// ignore: unused_import
import 'subjects_screen.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var numberOfLectureToBeDeleted = TextEditingController();
  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  showDeleteLectureDialog(context);
                }
              },
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: const Text("احذف موعد"),
                      value: 1,
                    ),
                  ]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showAddNewSubjectDialog(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FittedBox(
              // fit: BoxFit.none,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'القاعة',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'المادة',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'الموعد',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'اليوم',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
                rows: Lecture.lecturesList.map((e) {
                  return DataRow(
                    onLongPress: () {},
                    cells: <DataCell>[
                      DataCell(
                        Text(
                          e.place,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      DataCell(
                        Text(
                          e.subject,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${e.startingTime}-${e.endingTime}',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      DataCell(
                        Text(
                          e.day,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String dropdownDay = 'السبت';
  String? dropdownSubject;
  //  = Subject.subjectsList[0].name;
  String? dropDownStartingTime;
  //= startingTime[0];
  String? dropDownEndingTime;
  // = endingTime[0];

  final days = ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];
  static const startingTime = ['8', '9', '10', '11', '12', '1', '2'];
  static const endingTime = ['9', '10', '11', '12', '1', '2', '3'];

  var subjectInput = TextEditingController();
  var placeInput = TextEditingController();
  var startingTimeInput = TextEditingController();
  var endingTimeInput = TextEditingController();

  void showAddNewSubjectDialog(BuildContext ctx) {
    showDialog(
        barrierDismissible:
            false, //make the dialog not to close when clicking on the screen
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'أضف موعد جديد',
              textDirection: TextDirection.rtl,
            ),
            content: StatefulBuilder(
              builder: (ctx, setState) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          //subject drop down
                          height: 45,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text('المادة'),
                              value: dropdownSubject,
                              elevation: 16,
                              onChanged: (String? newValue) => setState(() {
                                dropdownSubject = newValue!;
                              }),
                              items:
                                  Subject.subjectsBox.values.map((Subject sub) {
                                return DropdownMenuItem(
                                  value: sub.name,
                                  child: Text(sub.name),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Container(
                          //day drop down
                          margin: EdgeInsets.only(
                            top: 15,
                          ),
                          height: 45,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: dropdownDay,
                              elevation: 16,
                              onChanged: (String? newValue) => setState(() {
                                dropdownDay = newValue!;
                              }),
                              items: days.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              //ending time dropDown
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(top: 15, right: 10),
                                height: 45,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text('الى'),
                                    isExpanded: true,
                                    value: dropDownEndingTime,
                                    elevation: 16,
                                    onChanged: (String? newValue) =>
                                        setState(() {
                                      dropDownEndingTime = newValue;
                                    }),
                                    items: endingTime.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              //starting time dropDown
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(top: 15, left: 10),
                                height: 45,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text('من'),
                                    isExpanded: true,
                                    value: dropDownStartingTime,
                                    elevation: 16,
                                    onChanged: (String? newValue) =>
                                        setState(() {
                                      dropDownStartingTime = newValue!;
                                    }),
                                    items: startingTime.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                          ),
                          height: 45,
                          // padding: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            controller: placeInput,
                            decoration:
                                const InputDecoration(labelText: 'القاعة'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'إلغاء',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(
                  "أضف الموعد",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  var start = startingTime.indexOf(dropDownStartingTime!);
                  var end = endingTime.indexOf(dropDownEndingTime!);

                  if (start > end) {
                    Fluttertoast.showToast(
                      msg: "يجب ان تكون نهاية الوقت اكبر من بدايته!!",
                      toastLength: Toast.LENGTH_LONG,
                    );

                    return;
                  }

                  if (placeInput.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "حدد القاعة !!",
                      toastLength: Toast.LENGTH_LONG,
                    );

                    return;
                  }
                  Lecture.addLecture(
                    Lecture(
                      subject: dropdownSubject!,
                      day: dropdownDay,
                      startingTime: dropDownStartingTime!,
                      endingTime: dropDownEndingTime!,
                      place: placeInput.text,
                    ),
                  );

                  Lecture.sortLecturesList();
                  setState(() {
                    placeInput.clear();
                  });
                },
              ),
            ],
          );
        });
  }

  void showDeleteLectureDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  TextField(
                    controller: numberOfLectureToBeDeleted,
                    decoration: InputDecoration(
                        hintText: 'ادخل رقم السطر اللي بدك تحذفه'),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Lecture.deleteLectureAtNumber(
                          int.parse(numberOfLectureToBeDeleted.text));
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
    // Table(
    //   border: TableBorder.all(),
    //   children: [
    //     TableRow(children: [
    //       Column(
    //         children: const [Text('Day')], //the name of the day is in a column
    //       ),
    //       Column(
    //         // the time and date of the lectures is stored as (Column of Rows)
    //         children: [
    //           Row(
    //             children: [Text('Date'), Text('subjectName'), Text('place')],
    //           ),
    //         ],
    //       )
    //     ])
    //   ],
    // );

    // Flexible(
                          //   flex: 1,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(right: 4),
                          //     child: DropdownButton(
                          //       child: TextFormField(
                          //         controller: endingTimeInput,
                          //         keyboardType: TextInputType.number,
                          //         decoration: InputDecoration(
                          //           labelText: 'الى',
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Flexible(
                          //   flex: 1,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(left: 4),
                          //     child: DropdownButton<String>(
                          //       child: TextFormField(
                          //         controller: startingTimeInput,
                          //         keyboardType: TextInputType.number,
                          //         decoration: InputDecoration(
                          //           labelText: 'من',
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),