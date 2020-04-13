part of 'reloadmessage_bloc.dart';

abstract class ReloadmessageState extends Equatable {
  const ReloadmessageState();
}

class ReloadmessageInitial extends ReloadmessageState {
  @override
  List<Object> get props => [];
}

class ReloadmessageLoading extends ReloadmessageState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ReloadmessageLoaded extends ReloadmessageState {
  List<Data> messages;
  ReloadmessageLoaded({@required messages});
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ReloadmessageError extends ReloadmessageState {
  String error;
  ReloadmessageError({@required error});
  @override
  // TODO: implement props
  List<Object> get props => null;
}
