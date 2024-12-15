import 'package:equatable/equatable.dart';

abstract class WelcomeState extends Equatable {
  const WelcomeState();

  @override
  List<Object> get props => [];
}

class WelcomeInitial extends WelcomeState {}

class CountrySelectionInProgress extends WelcomeState {}

class CountrySelectedState extends WelcomeState {
  final String country;

  const CountrySelectedState(this.country);

  @override
  List<Object> get props => [country];
}

class CountrySelectionError extends WelcomeState {
  final String message;

  const CountrySelectionError(this.message);

  @override
  List<Object> get props => [message];
}
