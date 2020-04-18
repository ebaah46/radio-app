part of 'messagebloc_bloc.dart';

abstract class MessageblocState extends Equatable {
  const MessageblocState();
}

class MessageblocInitialState extends MessageblocState {
  @override
  List<Object> get props => [];
}

class MessageblocLoadingState extends MessageblocState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class MessageblocLoadedState extends MessageblocState {
  List<Data> messages;
  MessageblocLoadedState({@required this.messages});
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class MessageblocErrorState extends MessageblocState {
  String message;
  MessageblocErrorState({@required this.message});
  @override
  // TODO: implement props
  List<Object> get props => null;
}
