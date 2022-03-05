import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/lecture.dart';
import '../models/subject.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var numberOfLectureToBeDeleted = TextEditingController();
  var importTableStringController = TextEditingController();
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
                } else if (value == 2) {
                  showImportTableDialog(context);
                } else if (value == 3) {
                  Clipboard.setData(ClipboardData(text: exportTableAsString()));
                  Fluttertoast.showToast(
                    msg: "Table data is copied to clipboard!",
                    toastLength: Toast.LENGTH_LONG,
                  );
                }
              },
              itemBuilder: (ctx) => const [
                    PopupMenuItem(
                      child: Text("احذف موعد"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text("Import table"),
                      value: 2,
                    ),
                    PopupMenuItem(
                      child: Text("Export table"),
                      value: 3,
                    ),
                  ]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showAddNewSubjectDialog(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FittedBox(
              // fit: BoxFit.none,
              child: DataTable(
                columns: const [
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
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      DataCell(
                        Text(
                          e.subject,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${e.startingTime}-${e.endingTime}',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      DataCell(
                        Text(
                          e.day,
                          style: const TextStyle(fontSize: 22),
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
  String? dropDownStartingTime;
  String? dropDownEndingTime;

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
            title: const Text(
              'أضف موعد جديد',
              textDirection: TextDirection.rtl,
            ),
            content: StatefulBuilder(
              builder: (ctx, setState) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          //subject drop down
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              hint: const Text('المادة'),
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
                          margin: const EdgeInsets.only(top: 15),
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                margin:
                                    const EdgeInsets.only(top: 15, right: 10),
                                height: 45,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: const Text('الى'),
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
                                margin:
                                    const EdgeInsets.only(top: 15, left: 10),
                                height: 45,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: const Text('من'),
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
                          margin: const EdgeInsets.only(top: 15),
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
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text(
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
              height: 110,
              child: Column(
                children: [
                  TextField(
                    controller: numberOfLectureToBeDeleted,
                    decoration: const InputDecoration(
                        hintText: 'ادخل رقم السطر اللي بدك تحذفه'),
                    keyboardType: TextInputType.number,
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  ElevatedButton(
                    onPressed: () {
                      Lecture.deleteLectureAtNumber(
                          int.parse(numberOfLectureToBeDeleted.text));
                      setState(() {});
                      //Navigator.of(context).pop();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String exportTableAsString() {
    final lectures = Hive.box<Lecture>('LecturesBox').values.toList();

    String exportedTable = '[';

    // starts with "["
    //between each variable "*" is placed between
    //between each lecture "//" is placed btween

    for (var item in lectures) {
      exportedTable = exportedTable +
          item.day +
          "*" +
          item.startingTime +
          "*" +
          item.endingTime +
          "*" +
          item.subject +
          "*" +
          item.place +
          "//";
    }

    return exportedTable;
  }

  void importTableAsString(String table) {
    var importedTable = table;

    if (!importedTable.contains('[') ||
        !importedTable.contains('//') ||
        importedTable.split('*').length < 5) {
      // a valid table string must contain at least 4 '*' => which when splitting using '*' we must have 5 elements
      Fluttertoast.showToast(
          msg: "This is not a valid table !!", toastLength: Toast.LENGTH_LONG);
      return;
      // if one of the conditions is true then display a msg and get out of the method
    }

    /*delete the first "[" and last "//" 
    lecture..data // lecture..data//  (nothing here)
    when deleting the last "//"  =>  lecture..data // lecture..data => when splitting the string becomes 2 elements not 3
  */
    importedTable = importedTable.substring(1, importedTable.length - 2);

    var listOfLectureString = importedTable.split('//');
    // splits the string when it finds '//' (seperate lectures from one another)

    late String subject;
    late String day;
    late String startingTime;
    late String endingTime;
    late String place;

    for (var lecture in listOfLectureString) {
      // loop for every lecture
      final lectureFields = lecture.split('*');

      for (int i = 0; i < lectureFields.length; i++) {
        // loop for every field in lecture (5 times)
        // here we assign the fields of the lecture to the local variables

        switch (i) {
          case 0:
            day = lectureFields[0];
            break;

          case 1:
            startingTime = lectureFields[1];
            break;

          case 2:
            endingTime = lectureFields[2];
            break;

          case 3:
            subject = lectureFields[3];
            break;

          case 4:
            place = lectureFields[4];
            break;
        }
      }

      Lecture.addLecture(Lecture(
          subject: subject,
          day: day,
          startingTime: startingTime,
          endingTime: endingTime,
          place: place));
    }
  }

  void showImportTableDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Import table'),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                TextField(
                  controller: importTableStringController,
                  decoration: const InputDecoration(
                      //constraints: BoxConstraints(),
                      labelText: 'Table string',
                      hintText: 'أدخل النص اللي أخدتو من غيرك هان'),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();

                    setState(() {
                      importTableAsString(importTableStringController.text);
                    });
                    importTableStringController.clear();
                  },
                  child: const Text('Import the table'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
