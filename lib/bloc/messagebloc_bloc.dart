import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Models/message.dart';
import 'package:meta/meta.dart';
part 'messagebloc_event.dart';
part 'messagebloc_state.dart';

class MessageblocBloc extends Bloc<MessageblocEvent, MessageblocState> {
  ApiController apiController;
  MessageblocBloc({@required this.apiController});

  @override
  MessageblocState get initialState => MessageblocInitialState();

  @override
  Stream<MessageblocState> mapEventToState(
    MessageblocEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is FetchMessagesEvent) {
      yield MessageblocLoadingState();
      try {
        bool fetchMessagesState = await apiController.fetchedMessagesState;
        print(fetchMessagesState);
        if (fetchMessagesState) {
          List<Data> messages = await apiController.fetchMessagesfromDB();
          yield MessageblocLoadedState(messages: messages);
        } else {
          List<Data> messages = await apiController.fetchMessages();
          yield MessageblocLoadedState(messages: messages);
        }
      } catch (e) {
        yield MessageblocErrorState(message: e.toString());
      }
    }
  }
}
