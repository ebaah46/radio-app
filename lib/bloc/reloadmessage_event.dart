part of 'reloadmessage_bloc.dart';

abstract class ReloadmessageEvent extends Equatable {
  const ReloadmessageEvent();
}

class ReloadAllMessagesEvent extends ReloadmessageEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
