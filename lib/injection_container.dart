import 'package:clean_architecture_sample/core/util/input_converter.dart';
import 'package:clean_architecture_sample/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_sample/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/network/network_info.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';

final sl = GetIt.instance; // sl is service locator

Future<void> init() async {
  // !  Features - Number Trivia
  //Bloc
  // * calling GetIt.instance which is a callable class
  // * it means it is looking for all registered types
  sl.registerFactory(() => NumberTriviaBloc(
      inputConverter: sl(),
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
    ),
  );
  // // Use cases
  sl.registerLazySingleton<GetConcreteNumberTrivia>(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton<GetRandomNumberTrivia>(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
          () => NumberTriviaRepositoryImpl(
              networkInfo: sl(),
              localDataSource: sl(),
              remoteDataSource: sl()
          ),
  );

  // datasource
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
          () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
          () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(()=> sharedPreferences);
    sl.registerLazySingleton<http.Client>(() => http.Client());
    sl.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());

      // sharedprefrences needs .getInstance() to get instance ,
      // smth similar to geolocator package
      // as sharedPreferences.getInstance() is future,
      // but we don't want to return future
      // so we make it synchronous by
}