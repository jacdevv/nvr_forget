import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_animate/flutter_animate.dart' as animate;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetchData(String question, String conversation) async {
  final response = await http.post(
    Uri.parse(
        'https://nevr-forget-api-z7syldfgma-uc.a.run.app/query?question=$question'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode([
      {'type': 'string', 'text': 'string'}
    ]),
  );

  return response.body;
}

void main() {
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
                              const Positioned(
                                left: 11,
                                bottom: 10,
                                child: SizedBox(
                                  width: 20,
                                  height: 40,
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
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
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Flashcard(
                          answer: 'Zurich, Switzerland',
                          question:
                              'Where did you go for holiday last year at December?',
                        )),
                  ),
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

class MemoryPage extends StatefulWidget {
  const MemoryPage({super.key});

  @override
  State<MemoryPage> createState() => MemoryPageState();
}

class MemoryPageState extends State<MemoryPage> {
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
                              const Positioned(
                                left: 11,
                                bottom: 10,
                                child: SizedBox(
                                  width: 20,
                                  height: 40,
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
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
                          'Let\'s go down memory lane',
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
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 370,
                        child: Card(
                          color: const Color.fromARGB(255, 2, 2, 2),
                          child: ListTile(
                            title: GradientText(
                              '2 days ago',
                              style: const TextStyle(
                                  fontFamily: 'Robotto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              colors: const [
                                Color(0xFF304797),
                                Color(0xFF884EB6),
                                Color(0xFF6C3D9B),
                              ],
                            ),
                            subtitle: const Text(
                                'You celebrated Chinese New Year with your family',
                                style: TextStyle(
                                  color: Color(0xFFD0D4DB),
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                                  builder: (context) => const MemoryPage()),
                            );
                          },
                          child: animate.Animate(
                            child: const Text(
                              'Memory Lane',
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
                              .fade(
                                  duration: const Duration(milliseconds: 600))),
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
  bool isTyping = false;
  bool isChatting = false;
  bool isLoading = false;
  TextEditingController textController = TextEditingController();
  int numberOfPaddingWidgets = 5;
  var conversation = ['Empty'];
  var chat = [];

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
                    ],
                  ),
                  if (!isChatting)
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
                    padding: const EdgeInsets.only(top: 25.0),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          hintFadeDuration: const Duration(milliseconds: 500),
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical:
                                  30), // Add vertical padding inside the TextField
                          suffixIcon: isTyping
                              ? IconButton(
                                  icon: const Icon(Icons.send,
                                      color: Colors.white),
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true; // Start loading
                                    });
                                    String response = await fetchData(
                                        textController.text,
                                        conversation.join());
                                    setState(() {
                                      isLoading = false; // Stop loading
                                      isChatting = true;
                                      if (conversation.length == 1) {
                                        conversation.removeAt(0);
                                      }
                                      conversation
                                          .add('Human: ${textController.text}');
                                      conversation.add('GPT4: $response');
                                      chat.add(textController.text);
                                      chat.add(response);
                                      textController.clear();
                                    });
                                  },
                                )
                              : const IntrinsicWidth(
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera_alt_outlined,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      Icon(Icons.spatial_audio_off_outlined,
                                          color: Colors.white),
                                    ],
                                  ),
                                ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
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
      width: 350,
      height: 120,
      child: Stack(
        children: [
          Positioned(
            left: 40,
            top: 5,
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
          Positioned(
            left: 40,
            top: 38,
            child: SizedBox(
              width: 295,
              height: 100, // specify a height
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
          Positioned(
            left: 0,
            top: 5,
            child: Container(
              width: 30,
              height: 30,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    widget.AI
                        ? const Color.fromARGB(255, 155, 61, 97)
                        : const Color(0xFF6C3D9B),
                    const Color(0x006C3D9B),
                  ],
                ),
                shape: const OvalBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
