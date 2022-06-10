import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

const _listEquality = ListEquality();

void main() {
  runApp(const DashatarPuzzleApp());
}

class DashatarPuzzleApp extends StatelessWidget {
  const DashatarPuzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.blueAccent,
            Colors.lightBlue,
            Colors.lightBlueAccent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            flex: 4,
            child: FlutterLogo(),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  labelText: 'Enter your name',
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.white54),
                ),
                cursorColor: Colors.white,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GamePage(name: _controller.text),
                  ),
                );
              },
              child: const Text('Start!'),
            ),
          ),
        ],
      ),
    );
  }
}

class GamePage extends StatelessWidget {
  const GamePage({
    required this.name,
    Key? key,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.blueAccent,
              Colors.lightBlue,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 1),
            Center(
              child: Text(
                'Welcome $name',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            const Expanded(
              flex: 10,
              child: Game(),
            ),
          ],
        ),
      ),
    );
  }
}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final _letters = ['A', 'E', 'P', 'R', 'S'];
  final _result = <String?>[null, null, null, null, null];
  final _possibleresults = [
    ['A', 'P', 'E', 'R', 'S'],
    ['A', 'P', 'R', 'E', 'S'],
    ['A', 'S', 'P', 'E', 'R'],
    ['P', 'A', 'R', 'E', 'S'],
    ['P', 'A', 'R', 'S', 'E'],
    ['P', 'E', 'A', 'R', 'S'],
    ['P', 'R', 'A', 'S', 'E'],
    ['P', 'R', 'E', 'S', 'A'],
    ['R', 'E', 'A', 'P', 'S'],
    ['S', 'P', 'E', 'A', 'R'],
    ['S', 'P', 'A', 'R', 'E'],
  ];

  bool _isGameFinished = false;
  bool _isWordFound = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isGameFinished) {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isWordFound)
                      const Text('Congratulations!')
                    else
                      const Text('Try Again!'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Restart'),
                    ),
                  ],
                ),
              );
            });
      }
    });
    return Column(
      children: [
        Wrap(
          children: List<Widget>.generate(
            5,
            (index) => DragTarget<String>(
              builder: (context, candidateItems, rejectedItems) {
                final currentLetter = _result[index];
                return Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: candidateItems.isNotEmpty
                          ? Colors.redAccent
                          : currentLetter != null && currentLetter.isNotEmpty
                              ? Colors.greenAccent
                              : Colors.white,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      currentLetter ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              },
              onAccept: (item) {
                setState(() {
                  _result.removeAt(index);
                  _result.insert(index, item);
                  final element = _possibleresults.firstWhereOrNull(
                    (element) => _listEquality.equals(element, _result),
                  );
                  _isWordFound = element != null;
                  _isGameFinished = _result.whereNotNull().length == 5;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 50),
        Wrap(
          children: List<Widget>.generate(
            5,
            (index) {
              final currentLetter = _letters[index];
              return _result.contains(currentLetter)
                  ? Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: Colors.white24,
                    )
                  : Draggable<String>(
                      data: _letters[index],
                      feedback: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.greenAccent),
                        ),
                        child: Center(
                          child: Text(
                            _letters[index],
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        color: Colors.white24,
                      ),
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.greenAccent),
                        ),
                        child: Center(
                          child: Text(
                            _letters[index],
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
