import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Core
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';

/// Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

/// Chat
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

/// Profile
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

/// Pages
import 'features/auth/presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //---------------------------------------------------
  // Core Services
  //---------------------------------------------------

  final secureStorage = SecureStorageService();

  final dioClient = DioClient(secureStorage);

  //---------------------------------------------------
  // Auth
  //---------------------------------------------------

  final authRemoteDataSource = AuthRemoteDataSource(dioClient.dio);

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    storage: secureStorage,
  );

  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

  //---------------------------------------------------
  // Chat
  //---------------------------------------------------

  final chatRepository = ChatRepositoryImpl(
    remoteDatasource: ChatRemoteDatasource(dioClient: dioClient),
  );

  //---------------------------------------------------
  // Profile
  //---------------------------------------------------

  final profileRepository = ProfileRepositoryImpl(
    remoteDatasource: ProfileRemoteDatasource(dioClient: dioClient),
  );

  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      chatRepository: chatRepository,
      profileRepository: profileRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ChatRepositoryImpl chatRepository;
  final ProfileRepositoryImpl profileRepository;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.chatRepository,
    required this.profileRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(loginUseCase, registerUseCase),
        ),

        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(repository: chatRepository),
        ),

        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(repository: profileRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI Chat App',
        theme: ThemeData(useMaterial3: true),
        home: const LoginPage(),
      ),
    );
  }
}
