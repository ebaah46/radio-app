import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Models/message.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  ApiController apiController;
  FavoritesBloc({@required this.apiController});
  @override
  FavoritesState get initialState => FavoritesInitial();

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is LoadFavoriteMessages) {
      yield FavoritesLoading();
      try {
        bool favoritesState = await apiController.favoriteMessageState;
        if (favoritesState) {
          List<Data> favorites = await apiController.favoriteMessages;
          yield FavoritesLoaded(messages: favorites);
        } else
          yield FavoritesEmpty();
      } catch (e) {
        yield FavoritesError(error: e.toString());
      }
    }
  }
}
