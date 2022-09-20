import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/meet_list__modal.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
part 'meetlist_event.dart';
part 'meetlist_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}


class MeetList_Bloc extends Bloc<MeetList_Event,MeetList_State>{
  MeetList_Bloc({this.httpClient}) : super(MeetList_State()) {
    on<PostFetched>(
      _onmeetlistFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onmeetlistFetched(
      PostFetched event,
      Emitter<MeetList_State> emit,
      ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == MeetList_Status.initial) {
        List<Meetings> list;
        var token= await PreferenceConnector.getJsonToSharedPreference(StringConstant.loginData);
        print("Token $token");
        await ApiRepository().meetList(token.toString())
            .then((value) {
          if (value != null) {
            list = value.body.meetings;
            return emit(state.copyWith(
              status: MeetList_Status.success,
              posts: list,
              hasReachedMax: false,
            ));
          }
        });
      }
    } catch (_) {
      emit(state.copyWith(status: MeetList_Status.failure));
    }
  }
}
