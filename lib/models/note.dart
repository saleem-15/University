import 'package:hive/hive.dart';

part 'adapters/note.g.dart';

@HiveType(typeId: 4)
class Note {
  @HiveField(1)
  String title;

  @HiveField(2)
  String text;

  @HiveField(3)
  late int id;

  @HiveField(4)
  double textSize = 18;
  //when creating a new note we dont need to give it an id
  //so we can create a new note any where in the app with ease
  //but when storing the note in the note list in a subject we assign an id to the note (look at Subject class in the method addNote() )

  Note({
    required this.title,
    required this.text,
  });
}
