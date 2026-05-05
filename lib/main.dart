import 'package:flutter/material.dart';

void main() {
  runApp(const ScoreKeeperApp());
}

class ScoreKeeperApp extends StatelessWidget {
  const ScoreKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whist & Rentz Score Keeper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Select Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerSelectionScreen(game: 'Whist'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text('Whist'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerSelectionScreen(game: 'Rentz'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text('Rentz'),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerSelectionScreen extends StatelessWidget {
  final String game;

  const PlayerSelectionScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('$game - Select Players'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How many players?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [3, 4, 5, 6].map((int count) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerNamesScreen(
                          game: game,
                          playerCount: count,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                  ),
                  child: Text('$count', style: const TextStyle(fontSize: 24)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerNamesScreen extends StatefulWidget {
  final String game;
  final int playerCount;

  const PlayerNamesScreen({
    super.key,
    required this.game,
    required this.playerCount,
  });

  @override
  State<PlayerNamesScreen> createState() => _PlayerNamesScreenState();
}

class _PlayerNamesScreenState extends State<PlayerNamesScreen> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // Generate exactly 'playerCount' number of text controllers
    _controllers = List.generate(
      widget.playerCount,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    // We have to dispose of controllers to prevent memory leaks
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.game} - Player Names'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.playerCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1} Name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Grab the names from all the text fields
                List<String> names = _controllers
                    .map((controller) => controller.text.trim())
                    .toList();
                    
                // Provide default names if the host left any blank
                for (int i = 0; i < names.length; i++) {
                  if (names[i].isEmpty) names[i] = 'Player ${i + 1}';
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScoreBoardScreen(
                      game: widget.game,
                      playerNames: names,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreBoardScreen extends StatefulWidget {
  final String game;
  final List<String> playerNames;

  const ScoreBoardScreen({
    super.key,
    required this.game,
    required this.playerNames,
  });

  @override
  State<ScoreBoardScreen> createState() => _ScoreBoardScreenState();
}

class _ScoreBoardScreenState extends State<ScoreBoardScreen> {
  // Stores the points for each round. Each inner list corresponds to a round.
  final List<List<int>> _scores = [];

  // Calculate the total score for each player dynamically
  List<int> get _totals {
    List<int> totals = List.filled(widget.playerNames.length, 0);
    for (var round in _scores) {
      for (int i = 0; i < round.length; i++) {
        totals[i] += round[i];
      }
    }
    return totals;
  }

  void _addRound() {
    // Create controllers for the pop-up dialog
    List<TextEditingController> controllers = List.generate(
      widget.playerNames.length,
      (index) => TextEditingController(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Round ${_scores.length + 1} Scores'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.playerNames.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: controllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: widget.playerNames[index],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Convert inputs to integers (defaulting to 0 if empty/invalid)
                List<int> roundScores = controllers.map((c) {
                  return int.tryParse(c.text) ?? 0;
                }).toList();

                setState(() {
                  _scores.add(roundScores);
                });

                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.game} - Score Board'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView( // Enables scrolling down past many rounds
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView( // Enables scrolling right for many players
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Round', style: TextStyle(fontWeight: FontWeight.bold))),
                    ...widget.playerNames.map((name) => DataColumn(
                      label: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    )),
                  ],
                  rows: [
                    // Map past round scores to rows
                    ..._scores.asMap().entries.map((entry) {
                      int roundIndex = entry.key;
                      List<int> roundScores = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text('${roundIndex + 1}')),
                          ...roundScores.map((score) => DataCell(Text('$score'))),
                        ],
                      );
                    }),
                    // Display totals at the very bottom of the table
                    DataRow(
                      cells: [
                        const DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                        ..._totals.map((total) => DataCell(
                          Text('$total', style: const TextStyle(fontWeight: FontWeight.bold)),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRound,
        icon: const Icon(Icons.add),
        label: const Text('Add Round'),
      ),
    );
  }
}
