part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();
}

class NotesInitial extends NotesState {
  @override
  List<Object> get props => [];
}

class AddNote extends NotesState {
  final Note note;
  AddNote({@required this.note});
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class RemoveNote extends NotesState {
  final int id;
  RemoveNote({@required this.id});
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class UpdateNote extends NotesState {
  final int id;
  UpdateNote({@required this.id});
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadAllNotes extends NotesState {
  final List<Note> notes;
  LoadAllNotes({@required this.notes});
  @override
  // TODO: implement props
  List<Object> get props => null;
}
