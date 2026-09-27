import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NammaPremierLeagueApp());
}

class Team {
  String name;
  int budget; 
  int points; 
  int matchesPlayed;
  int matchesWon;

  Team({
    required this.name,
    this.budget = 100000000, 
    this.points = 0,
    this.matchesPlayed = 0,
    this.matchesWon = 0,
  });
}

class NammaPremierLeagueApp extends StatelessWidget {
  const NammaPremierLeagueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namma Premier League',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF0D111B), // Darker stadium night background
      ),
      home: const TeamRegistrationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- TEAM REGISTRATION SCREEN ---
class TeamRegistrationScreen extends StatefulWidget {
  const TeamRegistrationScreen({super.key});

  @override
  State<TeamRegistrationScreen> createState() => _TeamRegistrationScreenState();
}

class _TeamRegistrationScreenState extends State<TeamRegistrationScreen> {
  int numberOfTeams = 4; 
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  void _updateControllers() {
    controllers.clear();
    for (int i = 0; i < numberOfTeams; i++) {
      controllers.add(TextEditingController(text: "Team ${i + 1}"));
    }
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 NPL TOURNAMENT SETUP'),
        centerTitle: true,
        backgroundColor: const Color(0xFF161C2A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Number of Teams:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: numberOfTeams,
                  dropdownColor: const Color(0xFF161C2A),
                  items: List.generate(9, (index) => index + 2)
                      .map((num) => DropdownMenuItem(
                            value: num,
                            child: Text("$num Teams", style: const TextStyle(color: Colors.amber)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        numberOfTeams = val;
                        _updateControllers();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter Team Names:",
              style: TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 1),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: numberOfTeams,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: TextField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Franchise ${index + 1} Name',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF161C2A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                List<Team> registeredTeams = controllers
                    .map((c) => Team(name: c.text.trim().isEmpty ? "Unnamed Team" : c.text.trim()))
                    .toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimulatedAuctionScreen(teams: registeredTeams),
                  ),
                );
              },
              child: const Text('PROCEED TO LIVE AUCTION ➔', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CINEMATIC CELEBRATION AUCTION SCREEN ---
class SimulatedAuctionScreen extends StatefulWidget {
  final List<Team> teams;
  const SimulatedAuctionScreen({super.key, required this.teams});

  @override
  State<SimulatedAuctionScreen> createState() => _SimulatedAuctionScreenState();
}

class _SimulatedAuctionScreenState extends State<SimulatedAuctionScreen> with TickerProviderStateMixin {
  String playerName = "Virat Kohli";
  String playerRole = "Batsman (Icon Player)";
  int currentBid = 20000000; 
  String lastBidder = "No Bids Placed";
  
  Timer? _countdownTimer;
  int secondsRemaining = 25;
  String auctionStatus = "ACTIVE"; 

  // Dynamic animation controllers for cinematic visual effects
  late AnimationController _hammerAnimationController;
  late AnimationController _celebrationFlashController;

  @override
  void initState() {
    super.initState();
    
    _hammerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _celebrationFlashController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    startTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _hammerAnimationController.dispose();
    _celebrationFlashController.dispose();
    super.dispose();
  }

  void startTimer() {
    _countdownTimer?.cancel();
    setState(() {
      secondsRemaining = 25;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 1) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        triggerHammerDownConclusion();
      }
    });
  }

  void triggerHammerDownConclusion() {
    setState(() {
      secondsRemaining = 0;
      _countdownTimer?.cancel();
      auctionStatus = (lastBidder == "No Bids Placed") ? "UNSOLD" : "SOLD";
    });

    // Fire off the cinematic graphics sequence!
    _hammerAnimationController.forward(from: 0.0);
    _celebrationFlashController.forward(from: 0.0);
  }

  void teamPlacesBid(String teamName) {
    if (auctionStatus != "ACTIVE") return;

    setState(() {
      currentBid += 1000000; 
      lastBidder = teamName;  
    });

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    bool isAuctionClosed = auctionStatus != "ACTIVE";

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ NPL GRAND AUCTION STAGE'),
        centerTitle: true,
        backgroundColor: const Color(0xFF161C2A),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // MAIN DASHBOARD LAYOUT
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ticker Clock Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isAuctionClosed 
                        ? (auctionStatus == "SOLD" ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15))
                        : (secondsRemaining <= 5 ? Colors.orange.withOpacity(0.2) : Colors.amber.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isAuctionClosed 
                          ? (auctionStatus == "SOLD" ? Colors.greenAccent : Colors.redAccent)
                          : (secondsRemaining <= 5 ? Colors.orangeAccent : Colors.amber.withOpacity(0.3)),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isAuctionClosed 
                          ? "📢 AUCTION CONCLUDED"
                          : "⏱️ COUNTDOWN: $secondsRemaining SECONDS",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: isAuctionClosed 
                            ? (auctionStatus == "SOLD" ? Colors.greenAccent : Colors.redAccent)
                            : (secondsRemaining <= 5 ? Colors.orangeAccent : Colors.amber),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Player Card Area
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161C2A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isAuctionClosed && auctionStatus == "SOLD"
                            ? Colors.greenAccent.withOpacity(0.1)
                            : Colors.black45,
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                    border: Border.all(
                      color: isAuctionClosed 
                          ? (auctionStatus == "SOLD" ? Colors.greenAccent : Colors.redAccent) 
                          : Colors.amber.withOpacity(0.6), 
                      width: 2.5
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        playerName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 34, 
                          fontWeight: FontWeight.black, 
                          letterSpacing: 1,
                          color: isAuctionClosed 
                              ? (auctionStatus == "SOLD" ? Colors.greenAccent : Colors.redAccent) 
                              : Colors.amber
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(playerRole, style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Live Valuation Display Panel
                const Text(
                  'CURRENT HIGHEST VALUATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.white38, letterSpacing: 2, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${(currentBid / 10000000).toStringAsFixed(2)} Crore',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 52, fontWeight: FontWeight.black, color: Colors.greenAccent, letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  auctionStatus == "SOLD" ? '🏆 ACQUIRED BY: $lastBidder' : 'Current Leader: $lastBidder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18, 
                    color: auctionStatus == "SOLD" ? Colors.greenAccent : Colors.white70, 
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
                
                const SizedBox(height: 20),
                const Divider(color: Colors.white12, thickness: 1.5),
                const SizedBox(height: 10),
                
                if (!isAuctionClosed) ...[
                  const Text(
                    "CLICK YOUR FRANCHISE BUZZER TO BID",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 15),
                ],

                // BUZZER LIST SYSTEM
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.teams.length,
                    itemBuilder: (context, index) {
                      String currentTeamName = widget.teams[index].name;
                      bool holdsHighestBid = lastBidder == currentTeamName;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: holdsHighestBid ? Colors.green.shade700 : const Color(0xFF222B40),
                              foregroundColor: Colors.white,
                              elevation: holdsHighestBid ? 8 : 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: holdsHighestBid ? Colors.greenAccent : Colors.amber.withOpacity(0.4),
                                  width: holdsHighestBid ? 2 : 1
                                )
                              ),
                            ),
                            onPressed: isAuctionClosed || holdsHighestBid 
                                ? null 
                                : () => teamPlacesBid(currentTeamName),
                            child: Text(
                              holdsHighestBid ? '👑 $currentTeamName LEADS THE FIELD' : 'PLACE BID AS $currentTeamName (+10 L)',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // --- CINEMATIC CELEBRATION LAYER ---
          if (isAuctionClosed)
            IgnorePointer(
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(_celebrationFlashController),
                child: Container(
                  color: Colors.black.withOpacity(0.85),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Hammer Slam Motion
                        ScaleTransition(
                          scale: Tween<double>(begin: 0.3, end: 1.2)
                              .chain(CurveTween(curve: Curves.elasticOut))
                              .animate(_hammerAnimationController),
                          child: RotationTransition(
                            turns: Tween<double>(begin: -0.1, end: 0.0)
                                .chain(CurveTween(curve: Curves.bounceOut))
                                .animate(_hammerAnimationController),
                            child: const Text(
                              "🔨",
                              style: TextStyle(fontSize: 110),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // Wooden Podium Desk Surface Impact Marker
                        Container(
                          width: 160,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.brown.shade700,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: auctionStatus == "SOLD" ? Colors.greenAccent.withOpacity(0.6) : Colors.redAccent.withOpacity(0.6),
                                blurRadius: 30,
                                spreadRadius: 10,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Epic Particle Explosion Message Text
                        Text(
                          auctionStatus == "SOLD" ? "✨ SOLD! SOLD! SOLD! ✨" : "❌ PLAYER UNSOLD ❌",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.black,
                            letterSpacing: 2,
                            color: auctionStatus == "SOLD" ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            auctionStatus == "SOLD" 
                                ? "$lastBidder SECURES $playerName FOR ₹${(currentBid / 10000000).toStringAsFixed(2)} CR!"
                                : "$playerName goes back into the database pool.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(height: 50),
                        
                        // Restart / Proceed Action Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: auctionStatus == "SOLD" ? Colors.green : Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            // Completely resets state to start another custom test bid round
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => TeamRegistrationScreen()),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("RUN ANOTHER AUCTION ROUND", style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}