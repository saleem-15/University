// ignore_for_file: prefer_final_fields
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../models/link.dart';
import '../models/note.dart';
import '../models/subject.dart';

import 'links_screen.dart';
import 'notes_screen.dart';

class SubjectDetails extends StatefulWidget {
  final Subject subject;
  const SubjectDetails({Key? key, required this.subject}) : super(key: key);

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  var linkUrl = TextEditingController();
  var linkDescription = TextEditingController();
  var noteText = TextEditingController();
  var noteTitle = TextEditingController();
  final fontSizes = [
    '12',
    '14',
    '16',
    '18',
    '20',
    '22',
    '24',
    '26',
    '28',
    '30'
  ];

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showAddSomethingBottomSheet(context);
          }),
      appBar: AppBar(
        title: Text(widget.subject.name),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  showDeleteSubjectConfirmation(context);
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("delete this subject"),
                      value: 1,
                    ),
                  ]),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              children: [
                InkWell(
                  child: Column(
                    children: [
                      Image.asset(
                        'lib/assests/http.png',
                        width: 90,
                        height: 90,
                      ),
                      const Text('Links'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LinksScreen(
                                subject: widget.subject,
                              )),
                    ).then((value) {
                      //this code [then(){...} ] makes sure when we get back to this page ,its refreshed
                      setState(() {});
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(50.0),
                ),
                InkWell(
                  child: Column(
                    children: [
                      Image.asset(
                        'lib/assests/notes.png',
                        width: 90,
                        height: 90,
                      ),
                      const Text('Notes'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotesScreen(
                                subject: widget.subject,
                              )),
                    ).then((value) {
                      //this code [then(){...} ] makes sure when we get back to this page ,its refreshed
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),

          // DropdownButton2(
          //   hint: const Text('font size'),
          //   value: '14',
          //   dropdownMaxHeight: 200,
          //   items: fontSizes
          //       .map(
          //         (e) => DropdownMenuItem(
          //           child: Text(e),
          //         ),
          //       )
          //       .toList(),
          // ),
        ],
      ),
    );
  }

  void showDeleteSubjectConfirmation(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are You sure you want to delete this subject'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Subject.deleteSubject(widget.subject);
                    // when pressing delete subject =>
                    // remove (Delete Confirmation) dialog && then get out from (subject details page)
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete')),
            ],
          );
        });
  }

  void showAddSomethingBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return SizedBox(
            height: 100,
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: const [
                        Icon(Icons.add_link_rounded),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text('Add link'),
                      ],
                    ),
                  ),
                  onTap: () => showAddLinkDialog(ctx),
                ),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: const [
                        Icon(Icons.image),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text('Add image'),
                      ],
                    ),
                  ),
                  onTap: () => takePhoto(),
                ),
                InkWell(
                  //Add Note
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: const [
                        Icon(Icons.note_add),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text('Add note'),
                      ],
                    ),
                  ),
                  onTap: () => showAddNoteDialog(ctx),
                ),
              ],
            ),
          );
        });
  }

  void showAddNoteDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Add a note'),
          content: SizedBox(
            child: Column(
              children: [
                TextField(
                  controller: noteTitle,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                TextField(
                  controller: noteText,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(maxHeight: double.infinity),
                    labelText: 'Note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();

                    setState(() {
                      widget.subject.addNote(
                          Note(text: noteText.text, title: noteTitle.text));
                    });
                    noteText.clear();
                    noteTitle.clear();
                  },
                  child: const Text('Save the note'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2

    return appDocumentsPath;
  }

  Future takePhoto() async {
    //open the camera => the photo that was shot will be stored in (image)
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    image.saveTo(await getFilePath());

    // final fileName = basename(file.path);
    // final File localImage = await image.copy('$path/$fileName');
  }

  void showAddLinkDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add a link'),
          content: SizedBox(
            height: 210,
            child: Column(
              children: [
                TextField(
                  controller: linkUrl,
                  decoration: const InputDecoration(
                    labelText: 'Url',
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                TextField(
                  controller: linkDescription,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();

                    setState(() {
                      widget.subject.addLink(Link(
                        url: linkUrl.text,
                        description: linkDescription.text,
                      ));
                    });
                    linkUrl.clear();
                    linkDescription.clear();
                  },
                  child: const Text('Save the link'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveFile() async {
    File file = File(await getFilePath()); // 1
    file.writeAsString(
        "This is my demo text that will be saved to : demoTextFile.txt"); // 2
  }
}
