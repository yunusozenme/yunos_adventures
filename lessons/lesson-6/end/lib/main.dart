import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:yunos_adventures/yunos_adventures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yuno's Adventures",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameContainer(title: "Yuno's Adventures"),
    );
  }
}

class GameContainer extends StatefulWidget {
  const GameContainer({super.key, required this.title});
  final String title;

  @override
  State<GameContainer> createState() => _GameContainerState();
}

class _GameContainerState extends State<GameContainer> {

  @override
  Widget build(BuildContext context) {
    final screenSize = Vector2(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Scaffold(
      body: GameWidget(game: YunosAdventures(screenSize)),
    );
  }
}
