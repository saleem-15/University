import 'package:flutter/material.dart';
import 'package:university/models/subject.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../models/note.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note note;
  final Subject subject; //the subject that owns the note
  const NoteDetailsScreen({Key? key, required this.note, required this.subject})
      : super(key: key);

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

//IMPORTANT : When Updating The Note Dont Create A New Note
//Becuase The Method (updateNote) in Subject Class Depends On The Id Of The Note
//(Notes dont have id when its created)
class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  late final String
      originalNoteTitle; //used to know if the user has changed title
  late final String
      originalNoteText; //used to know if the user has changed text

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

  String? fontSizeSlectedValue;

  @override
  void initState() {
    final String title = widget.note.title;
    final String text = widget.note.text;
    titleController.text = title;
    textController.text = text;
    originalNoteTitle = title;
    originalNoteText = text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // [if] (the user did change title or text) => a dialog will appear to let him decide if he want
        // to save changes or not
        // [else] get out of the note screen without showing a dialog
        if (titleController.text != originalNoteTitle ||
            textController.text != originalNoteText) {
          showDoYouWantToSaveChangesDialog(context);
        } else {
          return true; // pop the screen (get out of the screen)
        }
        return false; // dont pop the screen (dont get out)
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            style: const TextStyle(color: Colors.white, fontSize: 22),
            cursorColor: Colors.white,
            controller: titleController,
            decoration: null,
          ),

          //elevation: 0,
          //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                buttonPadding: const EdgeInsets.all(16.0),
                hint: Text(
                  widget.note.textSize.toString().substring(0, 2),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                iconEnabledColor: Colors.white,
                items: fontSizes
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    fontSizeSlectedValue = value as String;
                    widget.note.textSize = double.parse(fontSizeSlectedValue!);
                  });
                },
                dropdownMaxHeight: 200,
                dropdownDecoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            IconButton(
              onPressed: () => showDeleteNoteConfirmation(context),
              icon: const Icon(
                Icons.delete,
                color: Colors.orange,
              ),
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 56,
          padding: const EdgeInsets.all(10),
          child: TextField(
            style: TextStyle(fontSize: widget.note.textSize),
            controller: textController,
            decoration: null,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
      ),
    );
  }

  void saveChanges() {
    widget.note.text = textController.text;
    widget.note.title = titleController.text;
    // font size is automatically updated
    widget.subject.updateNote(widget.note);
  }

  showDeleteNoteConfirmation(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are You sure you want to delete this note'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    widget.subject.deleteNote(widget.note);
                    // when pressing delete note =>
                    // remove (Delete Confirmation) dialog && then get out from (note page)
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete')),
            ],
          );
        });
  }

  void showDoYouWantToSaveChangesDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Do you want to save changes?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pop();
                },
                child: const Text('Don\'t save'),
              ),
              TextButton(
                  onPressed: () {
                    saveChanges();
                    // when pressing delete note =>
                    // remove (Delete Confirmation) dialog && then get out from (note page)
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Save')),
            ],
          );
        });
  }
}
