import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_by_bloc/bloc/state/todo_state.dart';
import 'package:todo_by_bloc/bloc/todo_cubit.dart';
import 'package:todo_by_bloc/data/local/local_database.dart';
import 'package:todo_by_bloc/data/model/todo_model.dart';
import 'package:todo_by_bloc/utils/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController updateEditingController = TextEditingController();

  List<TodoModel> notes = [];

  Random random = Random();

  TodoModel todoModel = TodoModel.initialValue;

  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reminders",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        actions: [
          IconButton(
              onPressed: () {
                check = !check;
                setState(() {});
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    int i = random.nextInt(list.length);
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Add Remind",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: nameEditingController,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.end,
                              cursorColor: Colors.orange,
                              decoration: InputDecoration(
                                hintText: "Reminder",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(.6)),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 16, top: 10, bottom: 10),
                                  child: Text(
                                    "Label ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 19),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(right: 4),
                                fillColor: Colors.grey,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 44, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Colors.red,
                                shadowColor: Colors.black,
                              ),
                              onPressed: () {
                                LocalDatabase.insertTodo(todoModel.copyWith(
                                    color: list[i],
                                    title: nameEditingController.text));
                                Navigator.pop(context);
                                nameEditingController.text = "";
                                context.read<TodoCubit>().get();
                              },
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white),
                              )),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              )),
        ],
      ),
      body: ListView(
        children: [
          BlocBuilder<TodoCubit, TodoState>(builder: (context, state) {
            if (state is TodoGetState) {
              return Column(
                children: [
                  check
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: TextField(
                            onChanged: (value) async {
                              notes = await LocalDatabase.searchNotes(value);
                              setState(() {});
                            },
                            style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.end,
                            cursorColor: Colors.orange,
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(.6)),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(
                                    left: 16, top: 10, bottom: 10),
                                child: Text(
                                  "Search ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19),
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(right: 4),
                              fillColor: Colors.grey,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0, color: Colors.grey),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0, color: Colors.grey),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  if (check)
                    ...List.generate(
                        notes.length,
                        (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: InkWell(
                                splashColor: Colors.grey.withOpacity(.2),
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        int i = random.nextInt(list.length);
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Text(
                                                  "Update Remind",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller:
                                                      updateEditingController,
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(.8),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.end,
                                                  cursorColor: Colors.orange,
                                                  decoration: InputDecoration(
                                                    hintText: "Reminder",
                                                    hintStyle: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(.6)),
                                                    prefixIcon: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          top: 10,
                                                          bottom: 10),
                                                      child: Text(
                                                        "Label ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 19),
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    fillColor: Colors.grey,
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 0,
                                                              color:
                                                                  Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 0,
                                                              color:
                                                                  Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 44,
                                                        vertical: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    shadowColor: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    updateEditingController
                                                            .text =
                                                        notes[index].title;
                                                    LocalDatabase.updateTodo(
                                                        todoModel.copyWith(
                                                            color: list[2],
                                                            title:
                                                                updateEditingController
                                                                    .text),
                                                        notes[index].id!);
                                                    Navigator.pop(context);
                                                    updateEditingController
                                                        .text = "";
                                                    context
                                                        .read<TodoCubit>()
                                                        .get();
                                                    setState(() {});
                                                  },
                                                  child: const Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  )),
                                              const SizedBox(
                                                height: 50,
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          titlePadding: const EdgeInsets.only(
                                              bottom: 12, top: 18),
                                          contentPadding: const EdgeInsets.only(
                                              top: 0,
                                              left: 24,
                                              right: 24,
                                              bottom: 18),
                                          contentTextStyle: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  Colors.black.withOpacity(.8)),
                                          content: const Text(
                                              "Deleting this app will also delete its data, but any documents or data stored in iCloud will not be deleted."),
                                          actionsPadding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          backgroundColor: Colors.white,
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          title: const Center(
                                            child: Text(
                                              "Delete \"Reminder\"?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          actions: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 0.64,
                                                  color: Colors.black
                                                      .withOpacity(.4),
                                                ),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12)),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      53,
                                                                  vertical: 12),
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 0.64,
                                                        height: 50,
                                                        color: Colors.black
                                                            .withOpacity(.4),
                                                      ),
                                                      InkWell(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        12)),
                                                        onTap: () {
                                                          LocalDatabase
                                                              .deleteItem(state
                                                                  .list[index]
                                                                  .id!);
                                                          context
                                                              .read<TodoCubit>()
                                                              .get();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      53,
                                                                  vertical: 12),
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 24),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(
                                        int.parse("0xff${notes[index].color}")),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        notes[index].title,
                                        style: const TextStyle(
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 10)
                                            ],
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  if (!check)
                    ...List.generate(
                        state.list.length,
                        (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: InkWell(
                                splashColor: Colors.grey.withOpacity(.2),
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        int i = random.nextInt(list.length);
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Text(
                                                  "Update Remind",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller:
                                                      updateEditingController,
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(.8),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.end,
                                                  cursorColor: Colors.orange,
                                                  decoration: InputDecoration(
                                                    hintText: "Reminder",
                                                    hintStyle: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(.6)),
                                                    prefixIcon: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          top: 10,
                                                          bottom: 10),
                                                      child: Text(
                                                        "Label ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 19),
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    fillColor: Colors.grey,
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 0,
                                                              color:
                                                                  Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 0,
                                                              color:
                                                                  Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 44,
                                                        vertical: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    shadowColor: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    LocalDatabase.updateTodo(
                                                        todoModel.copyWith(
                                                            color: list[2],
                                                            title:
                                                                updateEditingController
                                                                    .text),
                                                        state.list[index].id!);
                                                    Navigator.pop(context);
                                                    updateEditingController
                                                        .text = "";
                                                    context
                                                        .read<TodoCubit>()
                                                        .get();
                                                  },
                                                  child: const Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  )),
                                              const SizedBox(
                                                height: 50,
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          titlePadding: const EdgeInsets.only(
                                              bottom: 12, top: 18),
                                          contentPadding: const EdgeInsets.only(
                                              top: 0,
                                              left: 24,
                                              right: 24,
                                              bottom: 18),
                                          contentTextStyle: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  Colors.black.withOpacity(.8)),
                                          content: const Text(
                                              "Deleting this app will also delete its data, but any documents or data stored in iCloud will not be deleted."),
                                          actionsPadding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          backgroundColor: Colors.white,
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          title: const Center(
                                            child: Text(
                                              "Delete \"Reminder\"?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          actions: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 0.64,
                                                  color: Colors.black
                                                      .withOpacity(.4),
                                                ),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12)),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      53,
                                                                  vertical: 12),
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 0.64,
                                                        height: 50,
                                                        color: Colors.black
                                                            .withOpacity(.4),
                                                      ),
                                                      InkWell(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        12)),
                                                        onTap: () {
                                                          LocalDatabase
                                                              .deleteItem(state
                                                                  .list[index]
                                                                  .id!);
                                                          context
                                                              .read<TodoCubit>()
                                                              .get();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      53,
                                                                  vertical: 12),
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 24),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(int.parse(
                                        "0xff${state.list[index].color}")),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        state.list[index].title,
                                        style: const TextStyle(
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 10)
                                            ],
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))
                ],
              );
            }
            return const SizedBox();
          })
        ],
      ),
    );
  }
}
