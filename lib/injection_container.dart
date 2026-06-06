import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'package:flutter_automation/core/storage/secure_storage_service.dart';
import 'package:flutter_automation/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_automation/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_automation/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_automation/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_automation/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_automation/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => SecureStorageService());

  sl.registerLazySingleton(() => DioClient(sl()));

  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), storage: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));

  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerFactory(() => AuthBloc(sl(), sl()));
}
