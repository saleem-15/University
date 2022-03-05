import 'package:flutter/material.dart';
import '../models/lecture.dart';

class DailySchedule extends StatefulWidget {
  const DailySchedule({Key? key}) : super(key: key);

  @override
  State<DailySchedule> createState() => _DailyScheduleState();
}

class _DailyScheduleState extends State<DailySchedule> {
  late List<Lecture> todayLectures;

  /*when the build function is called =>
  -calculateTodayLectures() method is called ,It puts all the lectures of today in (todayLectures List)
  -the Scaffold widget builds the screen and it takes the lectures from (todayLectures List)
  */
  @override
  Widget build(BuildContext context) {
    calculateTodayLectures();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Schedule'),
      ),
      body: todayLectures.isEmpty
          ? Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 100)),
                Image.asset('lib/assests/output-onlinejpgtools.png'),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'You dont have any lectures today!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.cover,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                            label: Text(
                          'القاعة',
                          style: TextStyle(fontSize: 24),
                        )),
                        DataColumn(
                            label: Text(
                          'المادة',
                          style: TextStyle(fontSize: 24),
                        )),
                        DataColumn(
                            label: Text(
                          'الموعد',
                          style: TextStyle(fontSize: 24),
                        )),
                        DataColumn(
                          label: Text(
                            'اليوم',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                      rows: todayLectures.map((e) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                e.place,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.subject,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${e.startingTime}-${e.endingTime}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.day,
                                style: const TextStyle(fontSize: 18),
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

  void calculateTodayLectures() {
    var currentDay = DateTime.now().weekday;
    var x = Lecture.lecturesBox.values.toList();

    todayLectures = []; // clear the list of the lectures

    for (var lecuture in x) {
      //add today's lectures to the list
      if (lecuture.dayNum == currentDay) {
        todayLectures.add(lecuture);
      }
    }
  }
}
