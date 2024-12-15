import 'package:equatable/equatable.dart';

class HomeBanner {
  final String imageUrl;

  const HomeBanner({required this.imageUrl});
}

class Product {
  final String name;
  final double price;
  final String discount;

  const Product({required this.name, required this.price, required this.discount});
}

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<HomeBanner> banners;
  final List<String> categories;
  final List<Product> flashSales;
  final List<Product> asLowAs;

  const HomeLoadedState({
    required this.banners,
    required this.categories,
    required this.flashSales,
    required this.asLowAs,
  });

  @override
  List<Object?> get props => [banners, categories, flashSales, asLowAs];
}

class HomeErrorState extends HomeState {
  final String message;

  const HomeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
