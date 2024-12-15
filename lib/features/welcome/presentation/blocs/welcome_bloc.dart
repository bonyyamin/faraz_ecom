import 'package:flutter_bloc/flutter_bloc.dart';
import 'welcome_event.dart';
import 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeInitial()) {
    on<CountrySelectedEvent>(_onCountrySelected);
  }

  void _onCountrySelected(
      CountrySelectedEvent event, Emitter<WelcomeState> emit) {
    emit(CountrySelectionInProgress());

    // Emit the selected country immediately
    emit(CountrySelectedState(event.country));
  }
}
