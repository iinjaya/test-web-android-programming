import 'package:flutter/material.dart';
import 'package:todo_app/alert.dart';
import 'package:todo_app/core.dart';
import 'package:todo_app/module/todos/widget/bottom_sheet_show.dart';
import 'package:todo_app/module/todos/widget/container_form.dart';

class TodosView extends StatefulWidget {
  const TodosView({Key? key}) : super(key: key);

  Widget build(context, TodosController controller) {
    controller.view = this;

    showForm(int? id) {
      String header = 'create new note';
      if (id != null) {
        header = 'update note';
        controller.filled(id.toString());
      } else {
        controller.cleanUp();
      }

      bottomSheetShow(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              header.toUpperCase(),
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ContainerForm.text(
          hintText: 'Type an title',
          label: 'Title',
          icon: Icons.key,
          color: Colors.orange,
          controller: controller.title,
        ),
        const SizedBox(height: 10),
        ContainerForm.text(
          hintText: 'Type an description',
          label: 'Descrption',
          icon: Icons.sort,
          color: Colors.green.shade500,
          controller: controller.description,
        ),
        const SizedBox(height: 10),
        ContainerForm.text(
          hintText: 'Your idea is here',
          label: 'Task',
          icon: Icons.event_note_sharp,
          color: Colors.red.shade500,
          controller: controller.content,
        ),
        const SizedBox(height: 10),
        ContainerForm.button(
          label: 'save',
          onPressed: () async {
            final result = id == null
                ? await controller.save()
                : await controller.todo.updateItem(
                    id: id.toString(),
                    values: controller.item,
                  );
            if (result == 0) {
              Alert(message: 'TITLE NOT EMPTY', status: false).show();
              return;
            }
            Alert(message: '$header success', status: true).show(callback: () {
              controller.update();
              Get.back();
              controller.cleanUp();
            });
          },
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("MY NOTES APP")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showForm(null),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshTodo();
        },
        child: FutureBuilder(
          future: controller.refreshTodo(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'no note found'.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.indigo,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final todo = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications_none_rounded,
                      size: 34,
                      color: Colors.lightBlue,
                    ),
                    title: Text(
                      todo!.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.description,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          controller.convertDatetime(todo.createdAt),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    onLongPress: () => showForm(todo.id),
                    trailing: IconButton(
                      onPressed: () async {
                        await controller.todo.deleteItem(id: todo.id.toString());
                        Alert(message: 'Data deleted', status: true).show(
                          callback: () => controller.update(),
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 24.0,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  State<TodosView> createState() => TodosController();
}
