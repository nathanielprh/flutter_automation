import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';

import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';

import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create services
    final secureStorageService = SecureStorageService();

    final dioClient = DioClient(secureStorageService);

    // Create datasource
    final chatRemoteDatasource = ChatRemoteDatasource(dioClient: dioClient);

    // Create repository
    final chatRepository = ChatRepositoryImpl(
      remoteDatasource: chatRemoteDatasource,
    );

    return BlocProvider(
      create: (_) => ChatBloc(repository: chatRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'AI Chat',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),

        home: const ChatPage(),
      ),
    );
  }
}
