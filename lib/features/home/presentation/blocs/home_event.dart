import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

// Event to load homepage data
class LoadHomePageEvent extends HomeEvent {}
