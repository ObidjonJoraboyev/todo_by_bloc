import 'package:flutter/cupertino.dart';

import '../../data/model/todo_model.dart';

abstract class TodoState {}

class InitialTodoState extends TodoState {}

class TodoAddState extends TodoState {
  final String title;
  final Color color;

  TodoAddState({
    required this.color,
    required this.title,
  });

  TodoAddState copyWith({String? title, Color? color}) {
    return TodoAddState(
      color: color ?? this.color,
      title: title ?? this.title,
    );
  }
}

class TodoGetState extends TodoState {
  final List<TodoModel> list;

  TodoGetState({
    required this.list,
  });

  TodoGetState copyWith({List<TodoModel>? list}) {
    return TodoGetState(
      list: list ?? this.list,
    );
  }
}
