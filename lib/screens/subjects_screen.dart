import 'package:flutter/material.dart';
import '../models/subject.dart';
import 'subject_details.dart';

class SubjectsScreen extends StatefulWidget {
  final ThemeData theme;

  const SubjectsScreen({Key? key, required this.theme}) : super(key: key);

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  var newSubjectName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subjects'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddNewSubjectDialog(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.vertical -
                    112,
                //the size of the scrolling column is all the screen height - vertical padding (height taken by system UI)
                //- 112 (56*2) appBar height + bottomNavigationBar height

                child: ListView(
                  children: Subject.subjectsBox.values
                      .map((subject) => showSubjectCardToScreen(subject))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNewSubject(String subjectName) {
    setState(() {
      Subject.addSubject(Subject(name: subjectName));
    });
  }

  Widget showSubjectCardToScreen(Subject subject) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      // elevation: Themes.lightTheme.cardTheme.elevation,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          tileColor: Colors.transparent,
          title: Text(
            subject.name,
            style: const TextStyle(fontSize: 22),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubjectDetails(subject: subject)),
            ).then((value) {
              //this code [then(){...} ] makes sure when we get back to this page ,its refreshed
              setState(() {});
            });
          },
        ),
      ),
    );
  }

  void showAddNewSubjectDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Add new subject'),
            content: SizedBox(
              height: 130,
              child: Column(
                children: [
                  TextField(
                    controller: newSubjectName,
                    decoration:
                        const InputDecoration(labelText: 'Subject name'),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  ElevatedButton(
                      onPressed: () {
                        if (newSubjectName.text.isNotEmpty) {
                          addNewSubject(newSubjectName.text);
                          newSubjectName.clear();
                        }
                      },
                      child: const Text('Add Subject'))
                ],
              ),
            ),
          );
        });
  }
}
