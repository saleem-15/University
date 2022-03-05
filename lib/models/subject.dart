//you have to import this to be able to store the class in hive

import 'package:hive/hive.dart';
import '../main.dart';
import 'link.dart';
import 'note.dart';

/*
to store any kind of objects you need to write in the file (part 'file_name.g.dart')  
  the file that has the class that we want to save its data */
part 'adapters/subject.g.dart';

@HiveType(typeId: 2)
class Subject extends HiveObject {
  @HiveField(1)
  late int id;
  // id is important when Adding, Updating the subject

  @HiveField(2)
  String name;

  @HiveField(3)
  List<Link> links = [];

  @HiveField(4)
  List<Note> notes = [];

  @HiveField(5)
  int nextNoteId = 0;

  static Box<Subject> get subjectsBox {
    return Hive.box<Subject>(subjectBoxName);
  }

  Subject({required this.name}) {
    _idGenerator();
  }

  void _idGenerator() {
    // This fuction assignes id number to the subjects and ensures that id number is uniqe between Subjects

    final myBox = Hive.box('box');
    var x = myBox.get('id_Number_for_subjects');

    if (x == null) {
      //if this is the first time the user have added a subject
      id = 1;
      myBox.put('id_Number_for_subjects', 1);
    } else {
      id = (x as int) + 1; // id = x+1
      myBox.put('id_Number_for_subjects', id); //store id (x+1)
    }
  }

  static void addSubject(Subject subject) {
    subjectsBox.put(subject.id, subject);
  }

  static void deleteSubject(Subject subject) {
    subject.delete();
  }

  static void updateSubject(Subject subject) {
    subjectsBox.put(subject.id, subject);
  }

  void addLink(Link link) {
    links.add(link);
    updateSubject(this);
  }

  void deleteLink(Link link) {
    links.remove(link);
    updateSubject(this);
  }

  void addNote(Note note) {
    //before adding the note in the notes list we give it an id (Notes dont have id when its created)
    note.id = nextNoteId;
    notes.add(note);
    updateSubject(this);
    nextNoteId++;
  }

  void deleteNote(Note note) {
    notes.remove(note);
    updateSubject(this);
  }

  void updateNote(Note note) {
    // 1) loop on all elements in the notes list
    // 2) if you find that element (note) is the same as the note that we want to update (if the id's are the same)
    // 3) replace the old note with the new note (new note is the note that was supplied in the method parameter)
    for (var i = 0; i > notes.length - 1; i++) {
      // 1
      if (notes[i].id == note.id) {
        // 2
        notes[i] = note; // 3
      }
    }
    updateSubject(this);
  }
}
