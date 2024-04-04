import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_by_bloc/bloc/state/todo_state.dart';
import 'package:todo_by_bloc/data/local/local_database.dart';
import 'package:todo_by_bloc/data/model/todo_model.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(InitialTodoState());

  get() async {
    List<TodoModel> todoModel = await LocalDatabase.getAllItems();

    emit(TodoGetState(list: todoModel));
  }
}
