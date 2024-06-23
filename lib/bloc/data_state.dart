part of 'data_bloc.dart';

@immutable
abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<dynamic> data;

  DataLoaded(this.data);
}

class DataLoadError extends DataState {
  final String message;

  DataLoadError(this.message);
}
