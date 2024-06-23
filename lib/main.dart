import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:offline_flutter/bloc/data_bloc.dart';
import 'package:offline_flutter/service/dio_service/fetch_data.dart';
import 'package:offline_flutter/service/hive_service/local_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final apiService = ApiService();
  final hiveService = HiveService();
  await hiveService.init();
  runApp(MyApp(apiService: apiService, hiveService: hiveService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final HiveService hiveService;

  const MyApp({super.key, required this.apiService, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => DataBloc(apiService, hiveService),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataBloc = BlocProvider.of<DataBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Flutter'),
      ),
      body: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is DataInitial) {
            dataBloc.add(FetchData());
          }
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DataLoaded) {
            List data = state.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ListTile(
                      title: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.black),
                                bottom: BorderSide(color: Colors.black)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 200,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.network(
                                data[index]['thumbnail'],
                                fit: BoxFit.fill,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("ID : ${data[index]['id']}"),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                          "title : ${data[index]['title']}"),
                                    ),
                                    Text("price : ${data[index]['price']}"),
                                    Text(
                                        "quantity : ${data[index]['quantity']}"),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                          "total : ${data[index]['total']}"),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                          "discountPercentage : ${data[index]['discountPercentage']}"),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
          }
          if (state is DataLoadError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dataBloc.add(FetchData());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
