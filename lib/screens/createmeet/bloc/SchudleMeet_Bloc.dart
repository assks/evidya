import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/screens/createmeet/bloc/schudlemeet_event.dart';
import 'package:evidya/screens/createmeet/bloc/schudlemeet_state.dart';
//import 'package:evidya/screens/schudleclass/component/communication/ServerConnection.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Schudlemeet_Bloc extends Bloc<Schudlemeet_Event,Schudlemeet_State> {
  Schudlemeet_Bloc(Schudlemeet_State initialState) : super(initialState);

  @override
  Schudlemeet_State get initialize => Schudlemeet_State(false, "", "", "");

  @override
  Stream<Schudlemeet_State> mapEventToState(Schudlemeet_Event event) async* {
    if (event is Schudlemeet_Event) {
      if (!Validator().validatePassword(event.title)) {
        yield Schudlemeet_State(true, "Enter title", "", "");
      }
      else if (!Validator().validatePassword(event.subject)) {
        yield Schudlemeet_State(true, "", "Enter subject", "");
      }
      else if (!Validator().validatePassword(event.date)) {
        yield Schudlemeet_State(true, "", "Select Date", "");
      }
      else if (!Validator().validatePassword(event.time)) {
        yield Schudlemeet_State(true, "", "Select time", "");
      }
      else {
        yield Schudlemeet_State(true, "", "", "");
        var token = await PreferenceConnector.getJsonToSharedPreference(
            StringConstant.loginData);
/*        var response = await ApiRepository().createmeeting(
            event.title, event.subject, event.date, event.time, token);*/
       // yield Schudlemeet_State(false, "", "", response.status);
      }
    }
  }
}
