class Note {
  int id;
  String title;
  String text;
  String quotation;
  bool isDeleted = false;

  Note({this.id, this.title, this.text, this.isDeleted, this.quotation});
  factory Note.fromDB(Map<String, dynamic> note) {
    return Note(
        id: note['id'] as int,
        title: note['title'] as String,
        text: note['text'] as String,
        isDeleted: note['isDeleted'] as bool,
        quotation: note['quotation'] as String);
  }
}
