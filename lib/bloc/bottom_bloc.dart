import 'package:flutter_statemanagement/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({Duration? waitingBeforeLoading, required Iterable<String> urls})
      : super(urls: urls, waitBeforeLoading: waitingBeforeLoading);
}
