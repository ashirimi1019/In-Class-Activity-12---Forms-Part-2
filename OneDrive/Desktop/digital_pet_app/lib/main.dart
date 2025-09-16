import 'package:flutter/material.dart';

void main() {
  runApp(const DigitalPetApp());
}

class DigitalPetApp extends StatelessWidget {
  const DigitalPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PetHomePage(),
    );
  }
}

class PetHomePage extends StatefulWidget {
  const PetHomePage({super.key});

  @override
  State<PetHomePage> createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> {
  int happiness = 50;
  int hunger = 50;

  void playWithPet() {
    setState(() {
      happiness = (happiness + 10).clamp(0, 100);
      hunger = (hunger + 5).clamp(0, 100);
    });
  }

  void feedPet() {
    setState(() {
      hunger = (hunger - 10).clamp(0, 100);
      happiness = (happiness + 3).clamp(0, 100);
    });
  }

  void resetStats() {
    setState(() {
      happiness = 50;
      hunger = 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Digital Pet'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pets), text: "Pet"),
              Tab(icon: Icon(Icons.favorite), text: "Stats"),
              Tab(icon: Icon(Icons.refresh), text: "Reset"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Meet your pet! 🐶",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/616/616408.png',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: playWithPet,
                    child: const Text("Play"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: feedPet, child: const Text("Feed")),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Happiness: $happiness",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text("Hunger: $hunger", style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: resetStats,
                child: const Text("Reset Pet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
