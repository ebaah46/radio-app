part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
}

// Create Note Event
class CreateNoteEvent extends NotesEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadNotesEvent extends NotesEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
