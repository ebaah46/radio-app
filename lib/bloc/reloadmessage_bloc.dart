import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Models/message.dart';

part 'reloadmessage_event.dart';
part 'reloadmessage_state.dart';

class ReloadmessageBloc extends Bloc<ReloadmessageEvent, ReloadmessageState> {
  ApiController apiController;
  ReloadmessageBloc({@required this.apiController});
  @override
  ReloadmessageState get initialState => ReloadmessageInitial();

  @override
  Stream<ReloadmessageState> mapEventToState(
    ReloadmessageEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is ReloadAllMessagesEvent) {
      yield ReloadmessageInitial();
      try {
        List<Data> messages = await apiController.fetchMessages();
        yield ReloadmessageLoaded(messages: messages);
      } catch (e) {
        yield ReloadmessageError(error: e.toString());
      }
    }
  }
}
