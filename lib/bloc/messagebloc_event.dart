part of 'messagebloc_bloc.dart';

abstract class MessageblocEvent extends Equatable {
  const MessageblocEvent();
}

class FetchMessagesEvent extends MessageblocEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

