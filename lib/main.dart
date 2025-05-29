import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//the following line is needed to ensure that the app is run
void main() {
  runApp(MyApp());
}

//Stateless widgets are widgets that don't change once it's built.
//Stateless means something will always be the same, like a button or a text label.
//Stateful widgets are widgets that can change, like a counter that updates

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //every widget in Flutter has a build method that "refreshes" a certain widget when it changes.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners(); // This notifies the widgets that are listening to this state to rebuild
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners(); // Notify listeners to rebuild widgets that depend on this state
  }
}

//MyHomePage tracks changes to the app's current state using the watch method (basically tracks changes to the current page).
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // The build method is called whenever the widget needs to be rebuilt
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair), // This always works
            SizedBox(height: 10), // Adds space between widgets
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  var appState = context.watch<MyAppState>();

  return Scaffold(
    body: Column(
      // Column is used to arrange widgets from top to bottom
      children: [
        const Text('A random Awesome idea:'),
        Text(appState.current.toString()), // This always works

        ElevatedButton(
          onPressed: () {
            appState.current = WordPair.random();
            appState
                .getNext(); // Calls the method to get a new random word pair
          },
          child: const Text('Next'),
        ),
      ],
    ),
  );
}
