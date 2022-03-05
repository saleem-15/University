import 'package:flutter/material.dart';

import '../models/subject.dart';
import 'note_details_screen.dart';

class NotesScreen extends StatefulWidget {
  final Subject subject;
  const NotesScreen({required this.subject, Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 56,
        child: widget.subject.notes.isEmpty
            ? const Center(
                child: Text(
                  'لا توجد أي ملاحظات',
                  style: TextStyle(fontSize: 24),
                ),
              )
            : ListView(
                children: widget.subject.notes.map((e) {
                  return Card(
                    margin: const EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                        title: Text(
                          e.title,
                          style: const TextStyle(fontSize: 22),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteDetailsScreen(
                                    note: e, subject: widget.subject)),
                          ).then((value) {
                            //this code [then(){...} ] makes sure when we get back to this page ,its refreshed
                            setState(() {});
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
