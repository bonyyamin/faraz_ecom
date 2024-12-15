import 'package:equatable/equatable.dart';

abstract class WelcomeEvent extends Equatable {
  const WelcomeEvent();

  @override
  List<Object> get props => [];
}

class CountrySelectedEvent extends WelcomeEvent {
  final String country;

  const CountrySelectedEvent(this.country);

  @override
  List<Object> get props => [country];
}
