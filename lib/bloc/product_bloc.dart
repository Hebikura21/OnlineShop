// ignore_for_file: override_on_non_overriding_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product_models.dart';

abstract class ProductEvent {}

class FetchProducts extends ProductEvent {}

class DeleteProduct extends ProductEvent {
  final Product product;

  DeleteProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final Product product;

  UpdateProduct(this.product);
}

class ProductUpdated extends ProductState {
  final Product product;

  ProductUpdated(this.product);

  @override
  List<Object> get props => [product];
}

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String errorMessage;

  ProductError(this.errorMessage);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<FetchProducts>(_fetchProducts);
    on<DeleteProduct>(_deleteProduct);
    on<UpdateProduct>(_updateProduct);
  }

  Future<void> _fetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final response =
          await http.get(Uri.parse('https://api.hiocoding.com/api/product'));

          print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List<Product> products = List<Product>.from(
          jsonBody['data'].map((product) => Product.fromJson(product)),
        );
        emit(ProductLoaded(products));
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (error) {
      emit(ProductError('Failed to fetch products'));
    }
  }

  Future<void> _deleteProduct(
      DeleteProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final response = await http.delete(
        Uri.parse('https://api.hiocoding.com/api/product/${event.product.id}'),
      );
      if (response.statusCode == 200) {
        add(FetchProducts());
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      emit(ProductError('Failed to delete product'));
    }
  }

  Future<void> _updateProduct(
      UpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final response = await http.put(
        Uri.parse('https://api.hiocoding.com/api/product/${event.product.id}'),
        body: {
          'id': event.product.id,
          'name': event.product.name,
          'image': event.product.image,
          'sku': event.product.sku,
          'description': event.product.description,
          'price': event.product.price,
          'status': event.product.status,
        },
        headers: {
          'Accept': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        final updatedProduct = Product.fromJson(json.decode(response.body));
        emit(ProductUpdated(updatedProduct));
        add(FetchProducts());
      } else if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          final redirectResponse = await http.get(Uri.parse(redirectUrl));
          if (redirectResponse.statusCode == 200) {
            final updatedProduct =
                Product.fromJson(json.decode(redirectResponse.body));
            emit(ProductUpdated(updatedProduct));
            add(FetchProducts());
          } else {
            throw Exception('Failed to update product');
          }
        } else {
          throw Exception('Redirect location not found');
        }
      } else {
        throw Exception('Failed to update product');
      }
    } catch (error) {
      emit(ProductError('Failed to update product'));
    }
  }
}
