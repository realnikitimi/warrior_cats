import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warrior_cats/blocs/avatar_frame.dart';
import 'package:warrior_cats/routes/home.dart';
import 'package:warrior_cats/utils/file_storage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AvatarFrameBloc())],
      child: MaterialApp(
        title: 'Generate Avatar Frame.',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Warrior Cats'),
            actions: [
              TextButton(onPressed: () => null, child: Text('Hello World')),
            ],
          ),
          body: Home(),
        ),
      ),
    );
  }
}
