import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_by_bloc/bloc/todo_cubit.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiBlocProvider(
      providers: [BlocProvider(create: (_) => TodoCubit()..get())],
      child: const MyApp()));
}
