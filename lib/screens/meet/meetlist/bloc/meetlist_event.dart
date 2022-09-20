part of 'meetlist_bloc.dart';

abstract class MeetList_Event extends Equatable {
  @override
  List<Object> get props => [];
}

class PostFetched extends MeetList_Event {}