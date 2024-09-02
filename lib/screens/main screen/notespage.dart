import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/notecontrol.dart';
import 'package:task_control/model/note_model.dart';
import 'package:task_control/screens/editnote.dart';
import 'package:task_control/screens/auth/sign_up.dart';

class NotesPage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          color: black, // Set the background color for the entire page
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text('Notes',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    // const Spacer(),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(
                    //     Icons.search,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => noteController.notes.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListView.builder(
                            itemCount: noteController.notes.length,
                            itemBuilder: (context, index) {
                              final note = noteController.notes[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OpenContainer(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    closedElevation: 0,
                                    closedShape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(14)),
                                    ),
                                    closedColor: const Color(0xff1F1F1F),
                                    openBuilder: (context, _) => EditNote(
                                          noteKey: note.id.toString(),
                                        ),
                                    closedBuilder: (context, openContainer) =>
                                        GestureDetector(
                                            onTap: openContainer,
                                            child: NoteWidget(
                                                note: note,
                                                noteController:
                                                    noteController))),
                              );
                            },
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Image.asset("assets/images/Checklist-rafiki 1.png"),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Add Notes to see them here",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Tap + to add your Notes",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                ),
              )
            ],
          )),
    );
  }
}

class AddNotePage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final NoteController noteController = Get.find();

  AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  noteController.addNote(
                    title: titleController.text,
                    description: descriptionController.text,
                    color: Colors.blue, // default color for now
                  );
                  Get.back();
                }
              },
              child: const Text('Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}

// class CurveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.moveTo(0, size.height); // Start at the bottom-left corner
//     path.lineTo(0, size.height - 30); // Draw a line up
//     path.quadraticBezierTo(
//       size.width / 2, size.height, // Control point and end point of the curve
//       size.width, size.height - 30, // Draw a curve to the bottom-right corner
//     );
//     path.lineTo(size.width, size.height); // Draw a line down
//     path.close(); // Close the path
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

class NoteWidget extends StatelessWidget {
  final Note note;
  final NoteController noteController;

  const NoteWidget(
      {super.key, required this.note, required this.noteController});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(note.id.toString()), // Ensure each Slidable has a unique key
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
            child: GestureDetector(
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 0.5 - 25,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 0, 0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Spacer(),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
              onTap: () {
                noteController.deleteNote(note.id);
                Slidable.of(context)?.close(); // Close the Slidable
              },
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.19,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: note.color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              note.title,
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
