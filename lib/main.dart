import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_animate/flutter_animate.dart' as animate;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Hello! Everything compiled to 1 file for convenience.
// Please note that it's supposed to be seperated to many files
// One for each widget

Future<Map<String, String>> fetchFlashcard() async {
  final response = await http.get(Uri.parse(
      'https://nevr-forget-api-z7syldfgma-uc.a.run.app/flashcard?n=5'));

  List<dynamic> data = jsonDecode(response.body);
  Map<String, String> flashcards = {};

  for (var item in data) {
    flashcards[item['question']] = item['answer'];
  }

  return flashcards;
}

Future<String> transcribeAudio(html.Blob mp3Blob) async {
  // Convert the Blob to a Uint8List
  final reader = html.FileReader();
  reader.readAsArrayBuffer(mp3Blob);
  await reader.onLoad.first;
  final bytes = reader.result as Uint8List;

  debugPrint('Bearer ${dotenv.env['OPEN_AI_KEY']}');
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://api.openai.com/v1/audio/transcriptions'));
  request.headers.addAll({
    'Authorization': 'Bearer ${dotenv.env['OPEN_AI_KEY']}',
  });
  request.fields['model'] = 'whisper-1';
  request.fields['response_format'] = 'text';
  request.files
      .add(http.MultipartFile.fromBytes('file', bytes, filename: 'openai.mp3'));

  // Send the request
  var response = await request.send();

  // Get the response body
  var responseBody = await response.stream.bytesToString();

  return responseBody;
}

Future<String> fetchData(String question, String conversation,
    List<Map<String, dynamic>> payload) async {
  final response = await http.post(
    Uri.parse(
        'https://nevr-forget-api-z7syldfgma-uc.a.run.app/query?question=$question'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(payload
        .map((message) =>
            {"type": message["type"] ?? "", "text": message["text"] ?? ""})
        .toList()),
  );
  return response.body;
}

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatPage(),
    );
  }
}

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  late Map<String, String> questions;
  late List<Widget> flashcards;

  Future<Map<String, String>> initFlashcards() async {
    questions = await fetchFlashcard();
    flashcards = questions.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Flashcard(
            question: entry.key,
            answer: entry.value,
          ),
        ),
      );
    }).toList();
    return questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF010101),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: -180,
              left: -170,
              child: Opacity(
                opacity: 0.28,
                child: Container(
                  width: 319,
                  height: 349,
                  decoration: const ShapeDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center, // Center the gradient
                      radius: 0.6, // Set the radius to a value greater than 0
                      colors: [Color(0xFF5202FB), Color(0xFF010101)],
                    ),
                    shape: OvalBorder(),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MenuPage()),
                            );
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: svg.Svg('assets/Hamburger.svg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0, top: 15),
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF5202FC),
                                        Color(0xFF5202FC),
                                        Color(0xFF010101),
                                        Color(0xFF010101),
                                        Color(0xFF010101)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: animate.Animate(
                        child: GradientText('Hello, jac',
                            style: const TextStyle(
                              color: Color(0xFF304696),
                              fontSize: 44,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                            colors: const [
                              Color(0xFF304797),
                              Color(0xFF884EB6),
                              Color(0xFF6C3D9B),
                            ]),
                      ).fadeIn(duration: const Duration(milliseconds: 600)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: animate.Animate(
                        child: const Text(
                          'Let\'s do these flashcards',
                          style: TextStyle(
                            color: Color(0xFF444746),
                            fontSize: 44,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.2, // Adjust the line height here
                          ),
                        ),
                      ).fadeIn(duration: const Duration(milliseconds: 600)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: FutureBuilder(
                      future: initFlashcards(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, String>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 170.0),
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Widget> flashcards =
                              snapshot.data!.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Flashcard(
                                  question: entry.key,
                                  answer: entry.value,
                                ),
                              ),
                            );
                          }).toList();
                          return Column(children: flashcards);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Flashcard extends StatefulWidget {
  final String answer;
  final String question;
  const Flashcard({super.key, required this.answer, required this.question});

  @override
  // ignore: library_private_types_in_public_api
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool showAnswer = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: Card(
        color: const Color.fromARGB(255, 2, 2, 2),
        child: ListTile(
          title: GradientText(
            'Question',
            style: const TextStyle(
              fontFamily: 'Robotto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            colors: const [
              Color(0xFF304797),
              Color(0xFF884EB6),
              Color(0xFF6C3D9B),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  showAnswer ? widget.answer : widget.question,
                  style: const TextStyle(
                    color: Color(0xFFD0D4DB),
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showAnswer = !showAnswer;
                  });
                },
                icon: Icon(
                  showAnswer ? Icons.close : Icons.check,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFF010101),
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Positioned(
                top: 400,
                left: 200,
                bottom: 0,
                child: Opacity(
                  opacity: 0.20,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: const ShapeDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center, // Center the gradient
                        radius: 0.5, // Set the radius to a value greater than 0
                        colors: [Color(0xFF5202FB), Color(0xFF010101)],
                      ),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -140,
                left: -120,
                child: Opacity(
                  opacity: 0.20,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: const ShapeDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center, // Center the gradient
                        radius: 0.6, // Set the radius to a value greater than 0
                        colors: [Color(0xFF5202FB), Color(0xFF010101)],
                      ),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ),
              Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: svg.Svg('assets/Hamburger.svg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.only(right: 70.0, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatPage()),
                          );
                        },
                        child: animate.Animate(
                          child: const Text(
                            'Chat with AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 44,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                            .slideX(
                                duration: const Duration(milliseconds: 600),
                                begin: -0.1)
                            .fade(duration: const Duration(milliseconds: 600)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FlashcardPage()),
                          );
                        },
                        child: animate.Animate(
                          child: const Text(
                            'Flashcards',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 44,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                            .slideX(
                                duration: const Duration(milliseconds: 600),
                                begin: -0.1)
                            .fade(duration: const Duration(milliseconds: 600)),
                      ),
                    ],
                  ),
                ),
              ])
            ])));
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  List<Map<String, String>> transformChat(List<String> chat) {
    List<Map<String, String>> transformedChat = [];

    for (int i = 0; i < chat.length; i++) {
      Map<String, String> turn = {
        "type": i % 2 == 0 ? "human" : "ai",
        "text": chat[i]
      };
      transformedChat.add(turn);
    }

    return transformedChat;
  }

  bool isTyping = false;
  bool isChatting = false;
  bool isLoading = false;
  bool isAudio = false;
  bool audioLoading = false;
  final _recorder = AudioRecorder();
  bool _isRecording = false;
  TextEditingController textController = TextEditingController();
  int numberOfPaddingWidgets = 5;
  var conversation = ['Empty'];
  var chat = [];
  List<Map<String, dynamic>> payload = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF010101),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            if (!isChatting)
              Positioned(
                top: -180,
                left: -170,
                child: Opacity(
                  opacity: 0.28,
                  child: Container(
                    width: 319,
                    height: 349,
                    decoration: const ShapeDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center, // Center the gradient
                        radius: 0.6, // Set the radius to a value greater than 0
                        colors: [Color(0xFF5202FB), Color(0xFF010101)],
                      ),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 30),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MenuPage()),
                            );
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: svg.Svg('assets/Hamburger.svg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 30.0, top: 30),
                          child: IconButton(
                            icon: const Icon(Icons.done_all_outlined,
                                color: Colors.white, size: 30),
                            onPressed: () {},
                          )),
                    ],
                  ),
                  if (!isChatting)
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: animate.Animate(
                          child: GradientText('Hello, human',
                              style: const TextStyle(
                                color: Color(0xFF304696),
                                fontSize: 44,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                              colors: const [
                                Color(0xFF304797),
                                Color(0xFF884EB6),
                                Color(0xFF6C3D9B),
                              ]),
                        ).fadeIn(duration: const Duration(milliseconds: 600)),
                      ),
                    ),
                  if (!isChatting)
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: animate.Animate(
                          child: const Text(
                            'Anything on \nyour mind?',
                            style: TextStyle(
                              color: Color(0xFF444746),
                              fontSize: 44,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.2, // Adjust the line height here
                            ),
                          ),
                        ).fadeIn(duration: const Duration(milliseconds: 600)),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, left: 20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.75, // 75% of screen height
                      child: SingleChildScrollView(
                        child: Column(
                          children: List<Widget>.generate(
                            chat.length,
                            (int index) => Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: TextBox(
                                AI: index % 2 == 0 ? false : true,
                                text: index % 2 != 0 && chat[index].length > 2
                                    ? chat[index]
                                        .substring(1, chat[index].length - 1)
                                    : chat[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 45.0),
                  child: Container(
                      width: 370,
                      height: 80,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF0B0B0C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: !isAudio
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: textController,
                                onChanged: (text) {
                                  setState(() {
                                    if (textController.text != "") {
                                      isTyping = true;
                                    } else {
                                      isTyping = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write here...',
                                  hintFadeDuration:
                                      const Duration(milliseconds: 500),
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  suffixIcon: isTyping
                                      ? IconButton(
                                          icon: !isLoading
                                              ? const Icon(Icons.send,
                                                  color: Colors.white)
                                              : const CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true; // Start loading
                                            });
                                            payload = transformChat(
                                                chat.cast<String>());
                                            String response = await fetchData(
                                                textController.text,
                                                conversation.join(),
                                                payload);
                                            setState(() {
                                              isLoading = false; // Stop loading
                                              isChatting = true;
                                              if (conversation.length == 1) {
                                                conversation.removeAt(0);
                                              }
                                              conversation.add(
                                                  'Human: ${textController.text}');
                                              conversation
                                                  .add('GPT4: $response');
                                              chat.add(textController.text);
                                              chat.add(response);
                                              textController.clear();
                                            });
                                          },
                                        )
                                      : IntrinsicWidth(
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              IconButton(
                                                icon: !isAudio
                                                    ? const Icon(
                                                        Icons
                                                            .spatial_audio_off_outlined,
                                                        color: Colors.white,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .spatial_audio_outlined,
                                                        color: Colors.white,
                                                      ),
                                                onPressed: () {
                                                  setState(() {
                                                    return;
                                                    isAudio = !isAudio;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF0B0B0C),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!isLoading)
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          isAudio = false;
                                        });
                                      },
                                    ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        if (_isRecording) {
                                          isChatting = true;
                                          isLoading = true;
                                        }
                                        _isRecording = !_isRecording;
                                      });

                                      if (_isRecording) {
                                        await _recorder.startRecording();
                                      } else {
                                        final blob =
                                            await _recorder.stopRecording();
                                        String text =
                                            await transcribeAudio(blob);
                                        payload =
                                            transformChat(chat.cast<String>());
                                        String response = await fetchData(
                                            text, conversation.join(), payload);
                                        conversation.add('Human: $text');
                                        chat.add(text);
                                        setState(() {
                                          conversation.add('GPT4: $text');
                                          chat.add(response);

                                          isLoading = false;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0B0B0C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: !isLoading
                                        ? Text(
                                            _isRecording
                                                ? 'Done'
                                                : 'Click To Chat',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          )
                                        : const CircularProgressIndicator(
                                            color: Colors.white),
                                  ),
                                ],
                              ),
                            ))),
            )
          ],
        ),
      ),
    );
  }
}

class AudioRecorder {
  html.MediaStream? _mediaStream;
  html.MediaRecorder? _mediaRecorder;
  final _audioChunks = <html.Blob>[];

  Future<void> startRecording() async {
    _mediaStream = await html.window.navigator.mediaDevices?.getUserMedia({
      'audio': true,
    });

    _mediaRecorder = html.MediaRecorder(_mediaStream!);
    _mediaRecorder!.addEventListener('dataavailable', (html.Event e) {
      final blobEvent = e as html.BlobEvent;
      _audioChunks.add(blobEvent.data!);
    });

    _mediaRecorder!.start();
  }

  Future<html.Blob> stopRecording() async {
    final completer = Completer<html.Blob>();

    _mediaRecorder!.addEventListener('stop', (html.Event e) {
      final blob = html.Blob(_audioChunks, 'audio/webm');
      _audioChunks.clear();
      completer.complete(blob);
    });

    _mediaRecorder!.stop();

    return completer.future;
  }
}

class TextBox extends StatefulWidget {
  final bool AI;
  final String text;
  const TextBox({super.key, required this.AI, required this.text});

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Stack(
          children: [
            Positioned(
              left: 40,
              top: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: GradientText(widget.AI ? 'AI' : 'You',
                    style: const TextStyle(
                      color: Color(0xFF304696),
                      fontSize: 22,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                    colors: widget.AI
                        ? const [
                            Color(0xFF304797),
                            Color(0xFF884EB6),
                            Color(0xFF6C3D9B),
                          ]
                        : const [
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255)
                          ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(15), // half of width and height
                child: SizedBox(
                    width: 45,
                    height: 45,
                    child: Image.asset(widget.AI ? 'robot.png' : 'user.png')),
              ),
            ),
            Positioned(
              left: 40,
              top: 38,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: SizedBox(
                  width: 295,
                  height: 120,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
