import 'package:flutter/material.dart';
import 'package:flutter_automation/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_automation/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Core
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';

/// Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final LoginUseCase authlogin;
  final RegisterUseCase authregister;
  const MyApp(authlogin, authregister, {super.key});

  @override
  Widget build(BuildContext context) {
    //---------------------------------------------------
    // Core Services
    //---------------------------------------------------

    final secureStorage = SecureStorageService();

    final dioClient = DioClient(secureStorage);

    final remoteData = AuthRemoteDataSource(dioClient.dio);

    //---------------------------------------------------
    // Auth
    //---------------------------------------------------

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteData,
      storage: secureStorage,
    );

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

    return MultiBlocProvider(
      providers: [
        //---------------------------------------------------
        // Authentication Bloc
        //---------------------------------------------------
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authlogin, authregister),
        ),

        //---------------------------------------------------
        // Chat Bloc
        //---------------------------------------------------
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(repository: chatRepository),
        ),

        //---------------------------------------------------
        // Profile Bloc
        //---------------------------------------------------
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(repository: profileRepository),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: "AI Chat App",

        theme: ThemeData(useMaterial3: true),

        home: const LoginPage(),
      ),
    );
  }
}
