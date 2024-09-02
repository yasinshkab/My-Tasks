import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:task_control/controller/notecontrol.dart';
import 'package:task_control/screens/auth/sign_up.dart';
import 'package:task_control/screens/widgets/dialogs.dart';

class TextToSpeechScreen extends StatefulWidget {
  static const routeName = '/text-to-speech-screen';

  const TextToSpeechScreen({super.key});

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  Color selectedColor = const Color(0xFFFAAFA8); // default color

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final NoteController noteController = Get.find();
  // final SpeechToText _speechToText = SpeechToText();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _checkPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request().then((value) {
        print("{{{{{{{{{{{{object}}}}}}}}}}}}");
      });
    }
  }

  void _startListening() async {
    _checkPermissions();
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
        //  _text = val.recognizedWords;
          _confidence = val.hasConfidenceRating ? val.confidence : 1.0;
          // Update the description input with the recognized speech
          descriptionController.text = val.recognizedWords;
        }),
      );
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
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

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isListening ? 'Listening...' : 'Not Listening...',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              AvatarGlow(
                  endRadius: 75.0,
                  animate: _isListening, // Make glow active only when listening
                  glowColor: Colors.grey,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  child: GestureDetector(
                    onTapDown: (d) => _startListening(),
                    onTapUp: (d) => _stopListening(),
                    child:
// IconButton(
// onPressed: _isListening ? _stopListening : _startListening,
// icon:
                        Icon(
                      _isListening
                          ? Icons.mic_none_outlined
                          : Icons.mic_off_outlined,
                      color: Colors.black,
                      size: 50,
                    ),
                  )),
              Text(
                'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
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
                      onPressed: _showBottomSheet,
                      icon: Icon(
                        Icons.mic_none_outlined,
                        color: Colors.white,
                        // size: 50,
                      ),
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
                                noteController.addNote(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  color: selectedColor, // default color for now
                                );
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
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: descriptionController,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: null,
                  onChanged: (_) {},
                  decoration: const InputDecoration(
                      hintText: 'Type something...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: textgrey)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
