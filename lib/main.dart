import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const ScoreKeeperApp());
}

// --- CULORILE DE TABLĂ ---
const Color boardGreen = Color(0xFF0E1C12);
const Color chalkWhite = Color(0xFFF5F5F5);
const Color chalkYellow = Color(0xFFFFF59D);
const Color chalkRed = Color(0xFFEF9A9A);

class ScoreKeeperApp extends StatelessWidget {
  const ScoreKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whist & Rentz Score Keeper',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: chalkWhite,
          elevation: 0,
        ),
        textTheme: GoogleFonts.architectsDaughterTextTheme(
          ThemeData.dark().textTheme,
        ).apply(bodyColor: chalkWhite, displayColor: chalkWhite),
        colorScheme: const ColorScheme.dark(
          primary: chalkWhite,
          secondary: chalkYellow,
          surface: boardGreen,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return ChalkboardBackground(child: child!);
      },
      home: const LanguageSelectionScreen(),
    );
  }
}

// --- ECRANUL DE LIMBĂ ---
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Language\nAlege Limba',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, color: chalkYellow),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage(isRomanian: true)),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Flag.fromString('RO', height: 60, width: 85, borderRadius: 8),
                        const SizedBox(height: 15),
                        Text('Română', style: GoogleFonts.architectsDaughter(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage(isRomanian: false)),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Flag.fromString('GB', height: 60, width: 85, borderRadius: 8),
                        const SizedBox(height: 15),
                        Text('English', style: GoogleFonts.architectsDaughter(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET FUNDAL DE TABLĂ ---
class ChalkboardBackground extends StatelessWidget {
  final Widget child;
  const ChalkboardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: boardGreen,
      child: CustomPaint(
        painter: ChalkDustPainter(),
        child: child,
      ),
    );
  }
}

class ChalkDustPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final smudgePaint = Paint()
      ..color = Colors.white.withOpacity(0.015)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

    for (int i = 0; i < 15; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final width = random.nextDouble() * 300 + 100;
      final height = random.nextDouble() * 100 + 50;
      
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(random.nextDouble() * pi);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: width, height: height), smudgePaint);
      canvas.restore();
    }

    final dustPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1.0;
      
    for (int i = 0; i < 300; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(dx, dy), random.nextDouble() * 1.5, dustPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- STILURI BUTOANE CRETĂ ---
final ButtonStyle chalkButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: chalkWhite,
  side: const BorderSide(color: chalkWhite, width: 2.5),
  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  textStyle: GoogleFonts.architectsDaughter(fontSize: 26, fontWeight: FontWeight.bold),
);

final ButtonStyle chalkCircleStyle = OutlinedButton.styleFrom(
  foregroundColor: chalkWhite,
  side: const BorderSide(color: chalkWhite, width: 2.5),
  shape: const CircleBorder(),
  padding: const EdgeInsets.all(24),
  textStyle: GoogleFonts.architectsDaughter(fontSize: 28, fontWeight: FontWeight.bold),
);

// --- ECRAN START JOCURI ---
class HomePage extends StatelessWidget {
  final bool isRomanian;
  const HomePage({super.key, required this.isRomanian});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: chalkWhite),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
            );
          },
        ),
        title: Text(isRomanian ? 'Alegeți jocul:' : 'Choose your game!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerSelectionScreen(game: 'Whist', isRomanian: isRomanian)),
              ),
              style: chalkButtonStyle.copyWith(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
              child: const Text('Whist'),
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerSelectionScreen(game: 'Rentz', isRomanian: isRomanian)),
              ),
              style: chalkButtonStyle.copyWith(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
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
  final bool isRomanian;

  const PlayerSelectionScreen({super.key, required this.game, required this.isRomanian});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isRomanian ? '$game - Câți jucăm?' : '$game - How many?')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isRomanian ? 'Alegeți numărul de jucători:' : 'Choose the number of players:',
              style: const TextStyle(fontSize: 26),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [3, 4, 5, 6].map((int count) {
                return OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerNamesScreen(game: game, playerCount: count, isRomanian: isRomanian)),
                  ),
                  style: chalkCircleStyle,
                  child: Text('$count'),
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
  final bool isRomanian;

  const PlayerNamesScreen({super.key, required this.game, required this.playerCount, required this.isRomanian});

  @override
  State<PlayerNamesScreen> createState() => _PlayerNamesScreenState();
}

class _PlayerNamesScreenState extends State<PlayerNamesScreen> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.playerCount, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isRomanian ? '${widget.game} - Numele pe tablă' : '${widget.game} - Names on board')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.playerCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      controller: _controllers[index],
                      style: GoogleFonts.architectsDaughter(fontSize: 24, color: chalkYellow),
                      decoration: InputDecoration(
                        labelText: widget.isRomanian ? 'Nume Jucător ${index + 1}' : 'Player ${index + 1} Name',
                        labelStyle: TextStyle(color: chalkWhite.withOpacity(0.7), fontSize: 20),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: chalkWhite, width: 2)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: chalkYellow, width: 3)),
                      ),
                    ),
                  );
                },
              ),
            ),
            OutlinedButton(
              onPressed: () {
                List<String> names = _controllers.map((c) => c.text.trim()).toList();
                for (int i = 0; i < names.length; i++) {
                  if (names[i].isEmpty) {
                    names[i] = widget.isRomanian ? 'Jucător ${i + 1}' : 'Player ${i + 1}';
                  }
                }
                
                // RUTARE CĂTRE JOCUL CORECT
                if (widget.game == 'Whist') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WhistScoreBoardScreen(playerNames: names, isRomanian: widget.isRomanian)),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RentzScoreBoardScreen(playerNames: names, isRomanian: widget.isRomanian)),
                  );
                }
              },
              style: chalkButtonStyle.copyWith(minimumSize: MaterialStateProperty.all(const Size(double.infinity, 60))),
              child: Text(widget.isRomanian ? 'Începe Jocul' : 'Start the Game'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ============= LOGICA WHIST ===============
// ==========================================

class WhistRoundData {
  final int cardCount;
  final int firstPlayerIndex;
  List<int?> bids;
  List<int?> made;

  WhistRoundData({required this.cardCount, required this.firstPlayerIndex, required int playerCount})
      : bids = List.filled(playerCount, null),
        made = List.filled(playerCount, null);

  bool get isBiddingComplete => !bids.contains(null);
  bool get isRoundComplete => !made.contains(null);
}

class WhistScoreBoardScreen extends StatefulWidget {
  final List<String> playerNames;
  final bool isRomanian;

  const WhistScoreBoardScreen({super.key, required this.playerNames, required this.isRomanian});

  @override
  State<WhistScoreBoardScreen> createState() => _WhistScoreBoardScreenState();
}

class _WhistScoreBoardScreenState extends State<WhistScoreBoardScreen> {
  final List<WhistRoundData> _rounds = [];

  @override
  void initState() {
    super.initState();
    _generateWhistRounds();
  }

  void _generateWhistRounds() {
    int n = widget.playerNames.length;
    List<int> cardsPattern = [];
    for (int i = 0; i < n; i++) cardsPattern.add(1);
    for (int i = 2; i <= 7; i++) cardsPattern.add(i);
    for (int i = 0; i < n; i++) cardsPattern.add(8);
    for (int i = 7; i >= 2; i--) cardsPattern.add(i);
    for (int i = 0; i < n; i++) cardsPattern.add(1);

    for (int i = 0; i < cardsPattern.length; i++) {
      _rounds.add(WhistRoundData(cardCount: cardsPattern[i], firstPlayerIndex: i % n, playerCount: n));
    }
  }

  int _calculateWhistScore(int bid, int made) {
    if (bid == made) return 5 + made;
    return -((bid - made).abs());
  }

  List<int> get _totals {
    List<int> totals = List.filled(widget.playerNames.length, 0);
    for (var round in _rounds) {
      if (round.isRoundComplete) {
        for (int i = 0; i < widget.playerNames.length; i++) {
          totals[i] += _calculateWhistScore(round.bids[i]!, round.made[i]!);
        }
      }
    }
    return totals;
  }

  int get _activeRoundIndex => _rounds.indexWhere((r) => !r.isRoundComplete);

  void _undoLastAction() {
    int n = widget.playerNames.length;
    int activeIdx = _activeRoundIndex;

    if (activeIdx == -1) {
      WhistRoundData lastRound = _rounds.last;
      int prevIdx = (lastRound.firstPlayerIndex + n - 1) % n;
      setState(() => lastRound.made[prevIdx] = null);
      return;
    }

    WhistRoundData r = _rounds[activeIdx];
    int madeGiven = r.made.where((m) => m != null).length;
    if (madeGiven > 0) {
      int prevIdx = (r.firstPlayerIndex + madeGiven - 1) % n;
      setState(() => r.made[prevIdx] = null);
      return;
    }

    int bidsGiven = r.bids.where((b) => b != null).length;
    if (bidsGiven > 0) {
      int prevIdx = (r.firstPlayerIndex + bidsGiven - 1) % n;
      setState(() => r.bids[prevIdx] = null);
      return;
    }

    if (activeIdx > 0) {
      WhistRoundData prevRound = _rounds[activeIdx - 1];
      int prevIdx = (prevRound.firstPlayerIndex + n - 1) % n;
      setState(() => prevRound.made[prevIdx] = null);
    }
  }

  void _onNumberPressed(int value) {
    int activeIdx = _activeRoundIndex;
    if (activeIdx == -1) return;

    WhistRoundData r = _rounds[activeIdx];
    int n = widget.playerNames.length;
    bool isBidding = !r.isBiddingComplete;
    int inputsGiven = isBidding ? r.bids.where((b) => b != null).length : r.made.where((m) => m != null).length;
    int currentPlayerIndex = (r.firstPlayerIndex + inputsGiven) % n;

    setState(() {
      if (isBidding) {
        r.bids[currentPlayerIndex] = value;
      } else {
        r.made[currentPlayerIndex] = value;
        int currentMadeSum = r.made.where((m) => m != null).fold(0, (a, b) => a + (b as int));
        if (currentMadeSum == r.cardCount) {
          for (int i = 0; i < n; i++) {
            if (r.made[i] == null) r.made[i] = 0;
          }
        }
      }
    });
  }

  Widget _buildInputPanel() {
    int activeIdx = _activeRoundIndex;
    if (activeIdx == -1) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: chalkWhite.withOpacity(0.5), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.isRomanian ? 'S-A TERMINAT! 🎉' : 'IT\'S OVER! 🎉', style: const TextStyle(fontSize: 24, color: chalkYellow)),
            IconButton(icon: const Icon(Icons.undo, size: 30), onPressed: _undoLastAction, color: chalkRed)
          ],
        ),
      );
    }

    WhistRoundData r = _rounds[activeIdx];
    int n = widget.playerNames.length;
    bool isBidding = !r.isBiddingComplete;
    int inputsGiven = isBidding ? r.bids.where((b) => b != null).length : r.made.where((m) => m != null).length;
    int currentPlayerIndex = (r.firstPlayerIndex + inputsGiven) % n;
    String currentPlayerName = widget.playerNames[currentPlayerIndex];
    int currentSum = isBidding
        ? r.bids.where((b) => b != null).fold(0, (a, b) => a + (b as int))
        : r.made.where((m) => m != null).fold(0, (a, b) => a + (b as int));

    String bidLabel = widget.isRomanian ? 'Pariu' : 'Bid';
    String resultLabel = widget.isRomanian ? 'Rezultat' : 'Result';

    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 25, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(top: BorderSide(color: chalkWhite.withOpacity(0.5), width: 2)), 
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isBidding ? '$bidLabel: $currentPlayerName' : '$resultLabel: $currentPlayerName',
                  style: TextStyle(fontSize: 24, color: isBidding ? chalkYellow : chalkWhite),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.undo, size: 30),
                onPressed: _undoLastAction,
                color: chalkRed,
              )
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(r.cardCount + 1, (value) {
              bool isDisabled = false;
              if (isBidding && inputsGiven == n - 1) {
                isDisabled = (currentSum + value == r.cardCount);
              } else if (!isBidding && inputsGiven == n - 1) {
                isDisabled = (currentSum + value != r.cardCount);
              } else if (!isBidding && inputsGiven < n - 1) {
                isDisabled = (currentSum + value > r.cardCount);
              }

              return OutlinedButton(
                onPressed: isDisabled ? null : () => _onNumberPressed(value),
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  side: BorderSide(color: isDisabled ? Colors.transparent : chalkWhite, width: 2),
                  backgroundColor: isDisabled ? Colors.black26 : Colors.transparent,
                  foregroundColor: isDisabled ? Colors.white30 : chalkWhite,
                ),
                child: Text('$value', style: const TextStyle(fontSize: 24)),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int activeIdx = _activeRoundIndex;
    int currentPlayerIndex = -1;
    bool isBidding = false;
    if (activeIdx != -1) {
      WhistRoundData r = _rounds[activeIdx];
      isBidding = !r.isBiddingComplete;
      int inputsGiven = isBidding ? r.bids.where((b) => b != null).length : r.made.where((m) => m != null).length;
      currentPlayerIndex = (r.firstPlayerIndex + inputsGiven) % widget.playerNames.length;
    }

    return PopScope(
      canPop: false, 
      onPopInvoked: (bool didPop) async {
        if (didPop) return; 
        final bool shouldPop = await showExitDialog(context, widget.isRomanian);
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.isRomanian ? 'Scor Whist' : 'Whist Score')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 25,
                    headingRowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)), 
                    dividerThickness: 1,
                    dataRowMinHeight: 60, 
                    dataRowMaxHeight: 80,
                    columns: [
                      DataColumn(label: Text(widget.isRomanian ? 'Joc' : 'Round', style: const TextStyle(fontSize: 20, color: chalkYellow))),
                      ...widget.playerNames.map((name) => DataColumn(
                            label: Text(name, style: const TextStyle(fontSize: 20, color: chalkYellow)),
                          )),
                    ],
                    rows: [
                      ..._rounds.asMap().entries.map((entry) {
                        int roundIndex = entry.key;
                        WhistRoundData r = entry.value;
                        String cardLabel = widget.isRomanian ? (r.cardCount == 1 ? 'carte' : 'cărți') : (r.cardCount == 1 ? 'card' : 'cards');

                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                            if (roundIndex == activeIdx) return chalkWhite.withOpacity(0.05);
                            return null;
                          }),
                          cells: [
                            DataCell(Text('${r.cardCount} $cardLabel', style: const TextStyle(fontSize: 18))),
                            ...List.generate(widget.playerNames.length, (pIndex) {
                              int? bid = r.bids[pIndex];
                              int? made = r.made[pIndex];
                              bool isCurrentPlayer = (roundIndex == activeIdx) && (pIndex == currentPlayerIndex);

                              if (bid == null) {
                                return DataCell(isCurrentPlayer && isBidding
                                    ? const Text('✏️ ...', style: TextStyle(color: chalkYellow, fontSize: 18))
                                    : const Text('-', style: TextStyle(color: Colors.white54)));
                              } else if (made == null) {
                                return DataCell(isCurrentPlayer && !isBidding
                                    ? Text('$bid  /  ✏️', style: const TextStyle(color: chalkWhite, fontSize: 18))
                                    : Text('$bid  /  -', style: const TextStyle(color: Colors.white70, fontSize: 18)));
                              } else {
                                int score = _calculateWhistScore(bid, made);
                                return DataCell(
                                  Column(
                                    mainAxisSize: MainAxisSize.min, 
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('$bid  /  $made', style: const TextStyle(fontSize: 16)),
                                      Text(
                                        '${score > 0 ? '+$score' : score}',
                                        style: TextStyle(fontSize: 20, color: score > 0 ? chalkYellow : chalkRed),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                          ],
                        );
                      }),
                      DataRow(
                        color: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
                        cells: [
                          const DataCell(Text('TOTAL', style: TextStyle(fontSize: 22, color: chalkYellow))),
                          ..._totals.map((total) => DataCell(
                                Text('$total', style: const TextStyle(fontSize: 24, color: chalkYellow)),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildInputPanel(),
          ],
        ),
      ),
    );
  }
}


// ==========================================
// ============= LOGICA RENTZ ===============
// ==========================================

class RentzRoundData {
  final int dealerIndex;
  final String gameName;
  final List<int> scores;

  RentzRoundData({required this.dealerIndex, required this.gameName, required this.scores});
}

class RentzScoreBoardScreen extends StatefulWidget {
  final List<String> playerNames;
  final bool isRomanian;

  const RentzScoreBoardScreen({super.key, required this.playerNames, required this.isRomanian});

  @override
  State<RentzScoreBoardScreen> createState() => _RentzScoreBoardScreenState();
}

class _RentzScoreBoardScreenState extends State<RentzScoreBoardScreen> {
  final List<RentzRoundData> _rounds = [];
  String? _selectedGame;
  late List<TextEditingController> _scoreControllers;

  // Jocurile oficiale de Rentz (fiecare jucător le va împărți o dată)
  final List<String> _gamesRo = ['Popa de Roșu', 'Dame', 'Romburi', 'Levate', 'Totale', 'Rentz'];
  final List<String> _gamesEn = ['King of Hearts', 'Queens', 'Diamonds', 'Tricks', 'Totals', 'Rentz'];

  @override
  void initState() {
    super.initState();
    _scoreControllers = List.generate(widget.playerNames.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<String> get _allGames => widget.isRomanian ? _gamesRo : _gamesEn;
  
  int get _totalRoundsRequired => widget.playerNames.length * 6;
  
  int get _currentDealerIndex {
    if (_rounds.length >= _totalRoundsRequired) return widget.playerNames.length - 1;
    return _rounds.length ~/ 6; // La fiecare 6 jocuri se schimbă dealerul
  }

  List<String> get _availableGamesForCurrentDealer {
    if (_rounds.length >= _totalRoundsRequired) return [];
    List<String> playedByDealer = _rounds
        .where((r) => r.dealerIndex == _currentDealerIndex)
        .map((r) => r.gameName)
        .toList();
    return _allGames.where((game) => !playedByDealer.contains(game)).toList();
  }

  List<int> get _totals {
    List<int> totals = List.filled(widget.playerNames.length, 0);
    for (var round in _rounds) {
      for (int i = 0; i < widget.playerNames.length; i++) {
        totals[i] += round.scores[i];
      }
    }
    return totals;
  }

  void _undoLastAction() {
    if (_rounds.isNotEmpty) {
      setState(() {
        _rounds.removeLast();
        _selectedGame = null;
        for (var c in _scoreControllers) { c.clear(); }
      });
    }
  }

  void _saveRentzRound() {
    if (_selectedGame == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.isRomanian ? 'Selectează tipul jocului!' : 'Select the game type!'),
      ));
      return;
    }

    List<int> newScores = [];
    for (int i = 0; i < widget.playerNames.length; i++) {
      String text = _scoreControllers[i].text.trim();
      if (text.isEmpty) text = '0'; // default la 0 dacă e lăsat gol
      int? val = int.tryParse(text);
      if (val == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.isRomanian ? 'Scor invalid la ${widget.playerNames[i]}!' : 'Invalid score for ${widget.playerNames[i]}!'),
        ));
        return;
      }
      newScores.add(val);
    }

    setState(() {
      _rounds.add(RentzRoundData(
        dealerIndex: _currentDealerIndex,
        gameName: _selectedGame!,
        scores: newScores,
      ));
      _selectedGame = null;
      for (var c in _scoreControllers) { c.clear(); }
    });
  }

  Widget _buildInputPanel() {
    if (_rounds.length >= _totalRoundsRequired) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: chalkWhite.withOpacity(0.5), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.isRomanian ? 'S-A TERMINAT! 🎉' : 'IT\'S OVER! 🎉', style: const TextStyle(fontSize: 24, color: chalkYellow)),
            IconButton(icon: const Icon(Icons.undo, size: 30), onPressed: _undoLastAction, color: chalkRed)
          ],
        ),
      );
    }

    String dealerName = widget.playerNames[_currentDealerIndex];
    List<String> available = _availableGamesForCurrentDealer;

    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 25, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(top: BorderSide(color: chalkWhite.withOpacity(0.5), width: 2)), 
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dealer: $dealerName',
                style: const TextStyle(fontSize: 24, color: chalkYellow, fontWeight: FontWeight.bold),
              ),
              if (_rounds.isNotEmpty)
                IconButton(icon: const Icon(Icons.undo, size: 30), onPressed: _undoLastAction, color: chalkRed)
            ],
          ),
          const SizedBox(height: 10),
          
          // Selectare joc
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: available.map((game) {
              bool isSelected = _selectedGame == game;
              return ChoiceChip(
                label: Text(game, style: TextStyle(color: isSelected ? boardGreen : chalkWhite, fontSize: 16)),
                selected: isSelected,
                selectedColor: chalkYellow,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: isSelected ? chalkYellow : chalkWhite),
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (selected) {
                  setState(() => _selectedGame = selected ? game : null);
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 15),
          
          // Căsuțe pentru scoruri
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(widget.playerNames.length, (index) {
              return SizedBox(
                width: 80,
                child: TextField(
                  controller: _scoreControllers[index],
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.architectsDaughter(fontSize: 20, color: chalkWhite),
                  decoration: InputDecoration(
                    labelText: widget.playerNames[index],
                    labelStyle: TextStyle(color: chalkYellow.withOpacity(0.8), fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: chalkWhite)),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: chalkYellow, width: 2)),
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: _saveRentzRound,
            style: chalkButtonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(chalkWhite.withOpacity(0.1)),
            ),
            child: Text(widget.isRomanian ? 'Salvează Runda' : 'Save Round', style: const TextStyle(color: chalkYellow)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, 
      onPopInvoked: (bool didPop) async {
        if (didPop) return; 
        final bool shouldPop = await showExitDialog(context, widget.isRomanian);
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.isRomanian ? 'Scor Rentz' : 'Rentz Score')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 25,
                    headingRowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)), 
                    dividerThickness: 1,
                    dataRowMinHeight: 40, 
                    columns: [
                      DataColumn(label: Text(widget.isRomanian ? 'Joc' : 'Game', style: const TextStyle(fontSize: 20, color: chalkYellow))),
                      ...widget.playerNames.map((name) => DataColumn(
                            label: Text(name, style: const TextStyle(fontSize: 20, color: chalkYellow)),
                          )),
                    ],
                    rows: [
                      ..._rounds.map((r) {
                        return DataRow(
                          cells: [
                            DataCell(Text(r.gameName, style: const TextStyle(fontSize: 16, color: Colors.white70))),
                            ...r.scores.map((score) => DataCell(
                              Text(
                                '${score > 0 ? '+$score' : score}', 
                                style: TextStyle(fontSize: 18, color: score > 0 ? chalkYellow : (score < 0 ? chalkRed : chalkWhite))
                              )
                            )),
                          ],
                        );
                      }),
                      DataRow(
                        color: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
                        cells: [
                          const DataCell(Text('TOTAL', style: TextStyle(fontSize: 22, color: chalkYellow))),
                          ..._totals.map((total) => DataCell(
                                Text('$total', style: const TextStyle(fontSize: 24, color: chalkYellow)),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildInputPanel(),
          ],
        ),
      ),
    );
  }
}

// --- FUNCȚIE GLOBALĂ PENTRU DIALOGUL DE IEȘIRE ---
Future<bool> showExitDialog(BuildContext context, bool isRomanian) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1B291D), 
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: chalkWhite, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          isRomanian ? 'Atenție!' : 'Warning!',
          style: const TextStyle(color: chalkYellow, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
          isRomanian
              ? 'Ești sigur că vrei să părăsești jocul?\nTot scorul de până acum se va șterge definitiv!'
              : 'Are you sure you want to leave?\nAll current scores will be lost forever!',
          style: const TextStyle(color: chalkWhite, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: Text(isRomanian ? 'Anulează' : 'Cancel', style: const TextStyle(color: chalkWhite, fontSize: 18)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: Text(isRomanian ? 'Da, ieși' : 'Yes, leave', style: const TextStyle(color: chalkRed, fontSize: 18)),
          ),
        ],
      );
    },
  ) ?? false;
}