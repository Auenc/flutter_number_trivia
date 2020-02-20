import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:number_rivia/core/network/network_info.dart';
import 'package:number_rivia/core/util/input_converter.dart';
import 'package:number_rivia/features/number_triva/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_rivia/features/number_triva/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_rivia/features/number_triva/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_rivia/features/number_triva/domain/repositories/number_triva_repository.dart';
import 'package:number_rivia/features/number_triva/domain/usecases/get_random_number_trivia.dart';
import 'package:number_rivia/features/number_triva/domain/usecases/get_specific_number_trivia.dart';
import 'package:number_rivia/features/number_triva/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        specific: sl(),
        random: sl(),
        converter: sl(),
      ));
  // Usercases
  sl.registerLazySingleton(() => GetSpecificNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTrivaRepository>(
      () => NumberTriviaRepositoryImpl(
            localDataSource: sl(),
            networkInfo: sl(),
            remoteDataSource: sl(),
          ));

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
