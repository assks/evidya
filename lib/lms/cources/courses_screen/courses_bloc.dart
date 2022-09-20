import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/course_modal.dart';
import 'package:equatable/equatable.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import 'courses_event.dart';
import 'courses_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class Courses_Bloc extends Bloc<Courses_Event,Courses_State>{
  String cursor;
  String id= "1";
  Courses_Bloc({this.httpClient/*,this.id*/}) : super(Courses_State()) {
    on<courselistFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
      courselistFetched event,
      Emitter<Courses_State> emit,
      ) async {
    if (state.hasReachedMax) return;
    dynamic profileJson;

    try {
      if (state.status == CoursesStatus.initial) {
        List<Courses> post;
        var token= await PreferenceConnector.getJsonToSharedPreference(StringConstant.loginData);
        await ApiRepository()
            .getcourses(token.toString(),id)
            .then((value) {
          if (value != null) {
            post = value.body.courses;
            return emit(state.copyWith(
              status: CoursesStatus.success,
              posts: post,
              hasReachedMax: false,
            ));
          }
        });
      }
    } catch (_) {
      emit(state.copyWith(status: CoursesStatus.failure));
    }
  }

}