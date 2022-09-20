part of 'meetlist_bloc.dart';

enum MeetList_Status { initial, success, failure }

class MeetList_State extends Equatable {

  const MeetList_State({
    this.status = MeetList_Status.initial,
    this.posts = const <Meetings>[],
    this.hasReachedMax = false,
  });

  final MeetList_Status status;
  final List<Meetings> posts;
  final bool hasReachedMax;

  MeetList_State copyWith({
    MeetList_Status status,
    List<Meetings> posts,
    bool hasReachedMax,
  }) {
    return MeetList_State(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}
