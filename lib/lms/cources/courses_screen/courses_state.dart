import 'package:equatable/equatable.dart';
import 'package:evidya/model/course_modal.dart';


enum CoursesStatus { initial, success, failure }
class Courses_State extends Equatable {
   const Courses_State({
      this.status = CoursesStatus.initial,
      this.posts = const <Courses>[],
      this.hasReachedMax = false,
   });

   final CoursesStatus status;
   final List<Courses> posts;
   final bool hasReachedMax;

   Courses_State copyWith({
      CoursesStatus status,
      List<Courses> posts,
      bool hasReachedMax,
   }) {
      return Courses_State(
         status: status ?? this.status,
         posts: posts ?? this.posts,
         hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );
   }

   @override
   String toString() {
      return '''CoursesStatus { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts
          .length} }''';
   }

   @override
   List<Object> get props => [status, posts, hasReachedMax];
}




