import 'package:bloc/bloc.dart';
import 'package:faraz/features/product/data/models/product_model.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductLoading()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    try {
      // Simulate fetching from an API or database
      await Future.delayed(const Duration(seconds: 2));
      final products = [
        ProductModel(
            id: '1',
            name: 'Product 1',
            imageUrl: 'https://via.placeholder.com/150',
            price: 29.99),
        ProductModel(
            id: '2',
            name: 'Product 2',
            imageUrl: 'https://via.placeholder.com/150',
            price: 59.99),
      ];
      emit(ProductLoaded(products));
    } catch (error) {
      emit(const ProductError('Failed to load products'));
    }
  }
}
