import 'package:flutter_bloc/flutter_bloc.dart';

import 'HomeState.dart';
import 'homeEvent.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc(HomeState initialState) : super(initialState);

  @override
  HomeState get initialize=>HomeState(true);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is HomeEvent)
    {yield HomeState(true);
    }else{
      yield HomeState(false);}
  }


}