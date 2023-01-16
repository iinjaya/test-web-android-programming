import 'package:flutter/material.dart';
import 'package:todo_app/alert.dart';
import 'package:todo_app/core.dart';

class TodosView extends StatefulWidget {
  const TodosView({Key? key}) : super(key: key);

  Widget get devider => Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.indigo,
        ),
      );

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

      showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 25,
              right: 25,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(child: devider),
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
                TextFormField(
                  controller: controller.title,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key, color: Colors.orange),
                    hintText: 'Title',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.description,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sort, color: Colors.green),
                    hintText: 'Description',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.content,
                  maxLines: 10,
                  minLines: 1,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.source_outlined, color: Colors.red),
                    border: OutlineInputBorder(),
                    hintText: 'Your idea is here....',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: Size(Get.width / 4, 30),
                  ),
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
                    Alert(
                      message: '$header success',
                      status: true,
                    ).show(callback: () {
                      controller.update();
                      Get.back();
                      controller.cleanUp();
                    });
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          );
        },
      );
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
