import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_control/controller/notecontrol.dart';
import 'package:task_control/model/note_model.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:task_control/screens/widgets/dialogs.dart';

class EditNote extends StatefulWidget {
  final String noteKey;

  const EditNote({Key? key, required this.noteKey}) : super(key: key);
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Color selectedColor = const Color(0xFFFAAFA8); // default color
  NoteController noteController = Get.put(NoteController());
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var note;
  @override
  void initState() {
    note = noteController.notes
        .firstWhere((note) => note.id.toString() == widget.noteKey);

    titleController.text = note.title;
    descriptionController.text = note.description;
    selectedColor = note.color;

    super.initState();
  }

  Widget customContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
      ),
      child: child,
    );
  }

  void showDialogMessage() {
    Get.dialog(
      AlertDialog(
        title: const Text('An error Occurred!'),
        content: const Text('Something went wrong!'),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Okay!'),
          ),
        ],
      ),
    );
  }

  static final List<Color> lightColorCard = [
    const Color(0xFFFF9E9E),
    const Color(0xFF9E9EFF),
    const Color(0xFF9EFF9E),
    const Color(0xFFFFFF9E),
    const Color(0xFFFFBF9E),
    const Color(0xFFE59EFF),
    const Color(0xFFFF9EFF),
    const Color(0xFF9EFFFF),
    // const Color(0xFF91F48F),
    // const Color(0xFF91F48F),

    // const Color(0xFFD3BFDA),
    // const Color(0xFF999DFF),
  ];

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.15,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: lightColorCard.map((color) {
                    bool isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: isSelected ? grey : Colors.transparent,
                            width: isSelected ? 1.0 : 0.0,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final bool isFocus = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      backgroundColor: grey,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_circle_left_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _showColorPicker,
                      icon: const Icon(Icons.color_lens_outlined),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => thedialog(
                            context: context,
                            button: false,
                            buttononPressed: () {
                              if (titleController.text.isNotEmpty &&
                                  descriptionController.text.isNotEmpty) {
                                // Create updated note with new data
                                final updatedNote = Note(
                                  id: note.id, // Keep the existing ID
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  color:
                                      selectedColor, // Use the selected color
                                );

                                // Call updateNote with the updated note
                                noteController.updateNote(updatedNote);

                                // Close the dialog and any other open screens
                                Get.back();
                                Get.back();
                              }
                            },
                            textbuttononPressed: () {
                              Get.back();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: titleController,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(fontSize: 48, color: textgrey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: descriptionController,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: null,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                      hintText: 'Type something...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: textgrey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
