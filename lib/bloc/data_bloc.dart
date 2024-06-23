import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:offline_flutter/service/dio_service/fetch_data.dart';
import 'package:offline_flutter/service/hive_service/local_data.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final ApiService apiService;
  final HiveService hiveService;
  DataBloc(this.apiService, this.hiveService) : super(DataInitial()) {
    on<FetchData>(_onFetchData);
  }

  Future<void> _onFetchData(FetchData event, Emitter<DataState> emit) async {
    final localData = hiveService.dataList;
    emit(DataLoading());
    emit(DataLoaded(localData));
    try {
      final newData = await apiService.fetchData();
      await hiveService.saveData(newData);
      emit(DataLoaded(newData));
    } catch (e) {
      if (localData.isEmpty) {
        emit(DataLoadError('Failed to fetch data'));
      }
    }
  }
}
