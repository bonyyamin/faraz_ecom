import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<LoadHomePageEvent>(_onLoadHomePage);
  }

  void _onLoadHomePage(LoadHomePageEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    try {
      // Simulate fetching data (e.g., banners, categories, flash sales, etc.)
      await Future.delayed(const Duration(seconds: 2));

      // Mock Data
      final banners = [
        HomeBanner(imageUrl: "https://via.placeholder.com/400x200?text=Banner+1"),
        HomeBanner(imageUrl: "https://via.placeholder.com/400x200?text=Banner+2"),
        HomeBanner(imageUrl: "https://via.placeholder.com/400x200?text=Banner+3"),
      ];

      final categories = [
        "12.12 Event",
        "FarazLook",
        "Free Delivery",
        "Beauty",
        "Buy Any 3",
        "New Arrivals",
        "Play and Win",
      ];

      final flashSales = [
        Product(name: "Product 1", price: 99.99, discount: "12% Off"),
        Product(name: "Product 2", price: 79.99, discount: "43% Off"),
        Product(name: "Product 3", price: 49.99, discount: "25% Off"),
      ];

      final asLowAs = [
        Product(name: "Product A", price: 70.00, discount: ""),
        Product(name: "Product B", price: 75.00, discount: ""),
        Product(name: "Product C", price: 80.00, discount: ""),
      ];

      emit(HomeLoadedState(
        banners: banners,
        categories: categories,
        flashSales: flashSales,
        asLowAs: asLowAs,
      ));
    } catch (e) {
      emit(HomeErrorState("Failed to load homepage data"));
    }
  }
}
