import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'category_models.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCategories extends CategoryEvent {}

class DeleteCategory extends CategoryEvent {
  final int categoryId;

  DeleteCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class CreateCategory extends CategoryEvent {
  final Category category;

  CreateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category category;

  UpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryCreated extends CategoryState {
  final Category category;

  CategoryCreated(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryDeleted extends CategoryState {}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<FetchCategories>(_fetchCategories);
    on<DeleteCategory>(_deleteCategory);
    on<CreateCategory>(_createCategory);
    on<UpdateCategoryEvent>(_updateCategory);
  }

  Future<void> _fetchCategories(
      FetchCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final response =
          await http.get(Uri.parse('https://api.hiocoding.com/api/category'));

          print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody != null && jsonBody['data'] != null) {
          final List<Category> categories = List<Category>.from(
            jsonBody['data'].map((category) => Category.fromJson(category)),
          );
          emit(CategoryLoaded(categories));
        } else {
          emit(CategoryError('Failed to fetch categories. Invalid data.'));
        }
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (error) {
      print(error);
      emit(CategoryError('Failed to fetch categories. $error'));
    }
  }

  Future<void> _deleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://api.hiocoding.com/api/category/${event.categoryId}'));
      if (response.statusCode == 200) {
        emit(CategoryDeleted());
        await _updateCategories(emit);
      } else {
        throw Exception('Failed to delete category');
      }
    } catch (error) {
      print(error);
      emit(CategoryError('Failed to delete category. $error'));
    }
  }

  Future<void> _createCategory(
      CreateCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final response = await http.post(
        Uri.parse('https://api.hiocoding.com/api/category'),
        body: {
          'name': event.category.name,
          'status': event.category.status,
        },
      );
      if (response.statusCode == 201) {
        final createdCategory = Category.fromJson(json.decode(response.body));
        emit(CategoryCreated(createdCategory));
        await _updateCategories(emit);
      } else {
        throw Exception('Failed to create category');
      }
    } catch (error) {
      print(error);
      emit(CategoryError('Failed to create category. $error'));
    }
  }

  Future<void> _updateCategory(
      UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://api.hiocoding.com/api/category/${event.category.id}'),
        body: {
          'name': event.category.name,
          'status': event.category.status,
        },
      );
      if (response.statusCode == 200) {
        final updatedCategory = Category.fromJson(json.decode(response.body));
        emit(CategoryCreated(updatedCategory));
        await _updateCategories(emit);
      } else {
        throw Exception('Failed to update category');
      }
    } catch (error) {
      print(error);
      emit(CategoryError('Failed to update category. $error'));
    }
  }

 Future<void> _updateCategories(Emitter<CategoryState> emit) async {
    try {
      final response =
          await http.get(Uri.parse('https://api.hiocoding.com/api/category'));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody != null && jsonBody['data'] != null) {
          final List<Category> categories = List<Category>.from(
            jsonBody['data'].map((category) => Category.fromJson(category)),
          );
          emit(CategoryLoaded(categories));
        } else { 
          emit(CategoryError('Failed to fetch categories. Invalid data.'));
        }
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (error) {
      print(error);
      emit(CategoryError('Failed to fetch categories. $error'));
    }
  }
}
