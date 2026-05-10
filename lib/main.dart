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
// ====== LOGICA WHIST (SINE STĂTĂTOR) ======
// ==========================================
int _calculateWhistScore(int bid, int made) {
  if (bid == made) return 5 + made;
  return -((bid - made).abs());
}

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
              IconButton(icon: const Icon(Icons.undo, size: 30), onPressed: _undoLastAction, color: chalkRed)
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
                                      Text('${score > 0 ? '+$score' : score}', style: TextStyle(fontSize: 20, color: score > 0 ? chalkYellow : chalkRed)),
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
  bool isClosed;
  Map<String, List<int>> inputs;

  RentzRoundData({required this.dealerIndex, required this.gameName, required int playerCount})
      : isClosed = false,
        inputs = {};
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
  Map<String, List<TextEditingController>> _activeControllers = {};

  final List<String> _gamesRo = ['Popa de Roșu', 'Dame', 'Romburi', 'Levate', '10 de treflă', 'Whist', 'Totale', 'Rentz'];
  final List<String> _gamesEn = ['King of Hearts', 'Queens', 'Diamonds', 'Levate', '10 of Clubs', 'Whist', 'Totals', 'Rentz'];

  List<String> get _subGamesTotale => widget.isRomanian 
      ? ['Levate', 'Dame', 'Romburi', 'Popa de Roșu'] 
      : ['Levate', 'Queens', 'Diamonds', 'King of Hearts'];

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (var list in _activeControllers.values) {
      for (var c in list) { c.dispose(); }
    }
  }

  List<String> get _allGames => widget.isRomanian ? _gamesRo : _gamesEn;
  
  int get _totalRoundsRequired => widget.playerNames.length * 8;
  
  int get _currentDealerIndex {
    int closedRounds = _rounds.where((r) => r.isClosed).length;
    if (closedRounds >= _totalRoundsRequired) return widget.playerNames.length - 1;
    return closedRounds % widget.playerNames.length;
  }

  bool get _isRoundActive => _rounds.isNotEmpty && !_rounds.last.isClosed;

  List<String> get _playedGamesForCurrentDealer {
    return _rounds
        .where((r) => r.dealerIndex == _currentDealerIndex)
        .map((r) => r.gameName)
        .toList();
  }

  // --- MOTORUL CENTRAL DE CALCULARE ---
  int _computePoints(String gameName, int val, int totalPlayers) {
    if (gameName == 'Whist') return val * 50;
    if (gameName == '10 de treflă' || gameName == '10 of Clubs') return val * 200;
    if (gameName == 'Popa de Roșu' || gameName == 'King of Hearts') return val * -200;
    if (gameName == 'Dame' || gameName == 'Queens') return val * -50;
    if (gameName == 'Romburi' || gameName == 'Diamonds') return val * -30;
    if (gameName == 'Levate') return val * -50;
    if (gameName == 'Rentz') return (totalPlayers - val) * 100; // Formula ta: (N-Loc)*100
    return 0; 
  }

  List<int> get _totals {
    int n = widget.playerNames.length;
    List<int> totals = List.filled(n, 0);
    
    for (var r in _rounds) {
      if (r.isClosed) {
        for (var sg in r.inputs.keys) {
          for (int p = 0; p < n; p++) {
             totals[p] += _computePoints(sg == 'main' ? r.gameName : sg, r.inputs[sg]![p], n);
          }
        }
      } else {
        for (var sg in _activeControllers.keys) {
          for (int p = 0; p < n; p++) {
             int val = int.tryParse(_activeControllers[sg]![p].text) ?? 0;
             totals[p] += _computePoints(sg == 'main' ? r.gameName : sg, val, n);
          }
        }
      }
    }
    return totals;
  }

  void _startGame(String gameName) {
    _disposeControllers();
    _activeControllers.clear();

    List<String> neededControllers = (gameName == 'Totale' || gameName == 'Totals') ? _subGamesTotale : ['main'];

    for (var sg in neededControllers) {
      _activeControllers[sg] = List.generate(widget.playerNames.length, (index) {
        var c = TextEditingController();
        c.addListener(() => setState(() {}));
        return c;
      });
    }

    setState(() {
      _rounds.add(RentzRoundData(
        dealerIndex: _currentDealerIndex,
        gameName: gameName,
        playerCount: widget.playerNames.length,
      ));
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: chalkRed));
  }

  void _closeActiveRound() {
    if (!_isRoundActive) return;
    RentzRoundData r = _rounds.last;
    int n = widget.playerNames.length;
    
    Map<String, List<int>> tempInputs = {};

    for (var sg in _activeControllers.keys) {
      List<int> vals = [];
      int sum = 0;
      for (int p = 0; p < n; p++) {
        int val = int.tryParse(_activeControllers[sg]![p].text) ?? 0;
        vals.add(val);
        sum += val;
      }
      
      String gameToCheck = sg == 'main' ? r.gameName : sg;
      
      if (gameToCheck == 'Whist' || gameToCheck == 'Levate') {
        if (sum != 8) { _showError(widget.isRomanian ? 'Suma la $gameToCheck trebuie să fie EXACT 8!' : 'Sum for $gameToCheck must be EXACTLY 8!'); return; }
      } else if (gameToCheck == 'Dame' || gameToCheck == 'Queens') {
        if (sum != 4) { _showError(widget.isRomanian ? 'Suma la $gameToCheck trebuie să fie EXACT 4!' : 'Sum for $gameToCheck must be EXACTLY 4!'); return; }
      } else if (gameToCheck == 'Romburi' || gameToCheck == 'Diamonds') {
        if (sum != 13) { _showError(widget.isRomanian ? 'Suma la $gameToCheck trebuie să fie EXACT 13!' : 'Sum for $gameToCheck must be EXACTLY 13!'); return; }
      } else if (gameToCheck == 'Popa de Roșu' || gameToCheck == 'King of Hearts' || gameToCheck == '10 de treflă' || gameToCheck == '10 of Clubs') {
        if (sum != 1) { _showError(widget.isRomanian ? 'La $gameToCheck un singur jucător trebuie să aibă valoarea 1!' : 'For $gameToCheck exactly one player must have 1!'); return; }
      } else if (gameToCheck == 'Rentz') {
        List<int> sorted = List.from(vals)..sort();
        bool ok = true;
        for (int i = 0; i < n; i++) if (sorted[i] != i + 1) ok = false;
        if (!ok) { _showError(widget.isRomanian ? 'La Rentz trebuie introduse locurile de la 1 la $n fără dubluri!' : 'For Rentz enter ranks from 1 to $n without duplicates!'); return; }
      }
      
      tempInputs[sg] = vals;
    }

    setState(() {
      r.inputs = tempInputs;
      for (var sg in _activeControllers.keys) {
         for (int p = 0; p < n; p++) {
            if (_activeControllers[sg]![p].text.isEmpty) _activeControllers[sg]![p].text = '0';
         }
      }
      r.isClosed = true;
    });
  }

  void _undoLastRound() {
    if (_rounds.isNotEmpty) {
      setState(() {
        _rounds.removeLast();
        _activeControllers.clear();
      });
    }
  }

  Widget _buildGameSelectionPanel() {
    if (_isRoundActive) return const SizedBox.shrink();

    if (_rounds.length >= _totalRoundsRequired) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: chalkWhite.withOpacity(0.5), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.isRomanian ? 'S-A TERMINAT! 🎉' : 'IT\'S OVER! 🎉', style: const TextStyle(fontSize: 24, color: chalkYellow)),
            IconButton(icon: const Icon(Icons.undo, size: 30), onPressed: _undoLastRound, color: chalkRed)
          ],
        ),
      );
    }

    String dealerName = widget.playerNames[_currentDealerIndex];
    List<String> played = _playedGamesForCurrentDealer;

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
                widget.isRomanian ? 'Alege jocul: $dealerName' : 'Choose game: $dealerName',
                style: const TextStyle(fontSize: 24, color: chalkYellow, fontWeight: FontWeight.bold),
              ),
              if (_rounds.isNotEmpty)
                IconButton(icon: const Icon(Icons.undo, size: 30), onPressed: _undoLastRound, color: chalkRed)
            ],
          ),
          const SizedBox(height: 15),
          
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _allGames.map((game) {
              bool isDisabled = played.contains(game);
              
              return OutlinedButton(
                onPressed: isDisabled ? null : () => _startGame(game),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDisabled ? Colors.white30 : chalkWhite,
                  side: BorderSide(color: isDisabled ? Colors.transparent : chalkWhite, width: 2),
                  backgroundColor: isDisabled ? Colors.black26 : Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(game, style: const TextStyle(fontSize: 18)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- MOTORUL DE RÂNDURI PENTRU DATATABLE ---
  List<DataRow> _buildTableRows() {
    int n = widget.playerNames.length;
    List<DataRow> rows = [];

    for (var r in _rounds) {
      bool isActive = !r.isClosed;

      if (r.gameName == 'Totale' || r.gameName == 'Totals') {
        // HEADER-UL PENTRU TOTALE
        rows.add(DataRow(
          color: MaterialStateProperty.all(isActive ? chalkWhite.withOpacity(0.1) : Colors.transparent),
          cells: [
            DataCell(Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.gameName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: chalkWhite)),
                Text(widget.playerNames[r.dealerIndex], style: const TextStyle(fontSize: 14, color: chalkYellow)),
                if (isActive) ...[
                  const SizedBox(height: 5),
                  OutlinedButton(
                    onPressed: _closeActiveRound,
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), side: const BorderSide(color: chalkYellow)),
                    child: const Text('✔️ GATA', style: TextStyle(color: chalkYellow, fontSize: 12)),
                  ),
                  const SizedBox(height: 5),
                  OutlinedButton( // <--- BUTONUL NOU DE CANCEL AICI
                    onPressed: _undoLastRound,
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), side: const BorderSide(color: chalkRed)),
                    child: Text(widget.isRomanian ? '❌ ANULEAZĂ' : '❌ CANCEL', style: const TextStyle(color: chalkRed, fontSize: 12)),
                  )
                ]
              ],
            )),
            // SUMA pentru fiecare jucator in runda asta de totale
            ...List.generate(n, (p) {
               int sum = 0;
               if (isActive) {
                 for (var sg in _subGamesTotale) {
                    int val = int.tryParse(_activeControllers[sg]![p].text) ?? 0;
                    sum += _computePoints(sg, val, n);
                 }
               } else {
                 for (var sg in _subGamesTotale) {
                    sum += _computePoints(sg, r.inputs[sg]![p], n);
                 }
               }
               return DataCell(Text('${sum > 0 ? '+' : ''}$sum', style: const TextStyle(color: chalkYellow, fontWeight: FontWeight.bold, fontSize: 18)));
            })
          ]
        ));

        // RÂNDURILE SUBORDONATE (Levate, Dame, etc.)
        for (var sg in _subGamesTotale) {
          rows.add(DataRow(
            color: MaterialStateProperty.all(isActive ? chalkWhite.withOpacity(0.05) : Colors.transparent),
            cells: [
              DataCell(Padding(padding: const EdgeInsets.only(left: 15), child: Text("↳ $sg", style: const TextStyle(color: Colors.white70, fontSize: 14)))),
              ...List.generate(n, (p) {
                 if (isActive) {
                    return DataCell(SizedBox(width: 50, child: _buildCellTextField(_activeControllers[sg]![p], '0')));
                 } else {
                    int raw = r.inputs[sg]![p];
                    int pts = _computePoints(sg, raw, n);
                    return DataCell(Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                          Text('$raw', style: const TextStyle(fontSize: 12, color: Colors.white54)),
                          Text('${pts > 0 ? '+' : ''}$pts', style: TextStyle(color: pts > 0 ? chalkYellow : (pts < 0 ? chalkRed : chalkWhite)))
                       ],
                    ));
                 }
              })
            ]
          ));
        }

      } else {
        // JOC NORMAL DE RENTZ (Un singur rând)
        rows.add(DataRow(
          color: MaterialStateProperty.all(isActive ? chalkWhite.withOpacity(0.08) : Colors.transparent),
          cells: [
            DataCell(Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.gameName, style: const TextStyle(fontSize: 18, color: chalkWhite, fontWeight: FontWeight.bold)),
                Text(widget.playerNames[r.dealerIndex], style: const TextStyle(fontSize: 14, color: chalkYellow)),
                if (isActive) ...[
                  const SizedBox(height: 5),
                  OutlinedButton(
                    onPressed: _closeActiveRound,
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), side: const BorderSide(color: chalkYellow)),
                    child: const Text('✔️ GATA', style: TextStyle(color: chalkYellow, fontSize: 12)),
                  ),
                  const SizedBox(height: 5),
                  OutlinedButton( // <--- BUTONUL NOU DE CANCEL AICI
                    onPressed: _undoLastRound,
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), side: const BorderSide(color: chalkRed)),
                    child: Text(widget.isRomanian ? '❌ ANULEAZĂ' : '❌ CANCEL', style: const TextStyle(color: chalkRed, fontSize: 12)),
                  )
                ]
              ],
            )),
            ...List.generate(n, (p) {
               if (isActive) {
                  return DataCell(SizedBox(width: 50, child: _buildCellTextField(_activeControllers['main']![p], r.gameName == 'Rentz' ? 'Loc' : '0')));
               } else {
                  int raw = r.inputs['main']![p];
                  int pts = _computePoints(r.gameName, raw, n);
                  return DataCell(Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                        Text(r.gameName == 'Rentz' ? 'Loc $raw' : '$raw buc', style: const TextStyle(fontSize: 12, color: Colors.white54)),
                        Text('${pts > 0 ? '+' : ''}$pts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: pts > 0 ? chalkYellow : (pts < 0 ? chalkRed : chalkWhite)))
                     ],
                  ));
               }
            })
          ]
        ));
      }
    }
    return rows;
  }

  Widget _buildCellTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      textAlign: TextAlign.center,
      style: GoogleFonts.architectsDaughter(fontSize: 18, color: chalkWhite),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: chalkYellow, width: 2)),
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
                    dataRowMinHeight: 60, 
                    dataRowMaxHeight: 140, // <-- Am mărit spațiul maxim ca să aibă loc cele două butoane confortabil
                    columns: [
                      DataColumn(label: Text(widget.isRomanian ? 'Joc' : 'Game', style: const TextStyle(fontSize: 20, color: chalkYellow))),
                      ...widget.playerNames.map((name) => DataColumn(
                            label: Text(name, style: const TextStyle(fontSize: 20, color: chalkYellow)),
                          )),
                    ],
                    rows: [
                      ..._buildTableRows(),
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
            _buildGameSelectionPanel(),
          ],
        ),
      ),
    );
  }
}