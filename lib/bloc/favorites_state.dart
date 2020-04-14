part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  @override
  List<Object> get props => [];
}

class FavoritesLoading extends FavoritesState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FavoritesLoaded extends FavoritesState {
  final List<Data> messages;
  FavoritesLoaded({@required this.messages});
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FavoritesEmpty extends FavoritesState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FavoritesError extends FavoritesState {
  final String error;
  FavoritesError({@required this.error});
  @override
  // TODO: implement props
  List<Object> get props => null;
}
