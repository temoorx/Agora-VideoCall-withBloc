import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_flutter/bloc/agora_bloc.dart';
import 'package:video_call_flutter/screens/role_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AgoraBloc(),
      child: const MaterialApp(
        home: RoleSelectionScreen(),
      ),
    );
  }
}
