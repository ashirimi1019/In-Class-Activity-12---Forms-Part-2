import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Text Animation',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: FadingTextAnimation(
        toggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const FadingTextAnimation({
    required this.toggleTheme,
    required this.isDarkMode,
    super.key,
  });

  @override
  State<FadingTextAnimation> createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.blue;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Pick a text color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _textColor,
            onColorChanged: (color) => setState(() => _textColor = color),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _goToSecondScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SecondFadingScreen(textColor: _textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleVisibility,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fading Text Animation'),
          actions: [
            IconButton(
              icon: Icon(
                widget.isDarkMode ? Icons.brightness_2 : Icons.wb_sunny,
              ),
              onPressed: widget.toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: _showColorPicker,
            ),
          ],
        ),
        body: Center(
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: Text(
              'Hello, Flutter!',
              style: TextStyle(fontSize: 24, color: _textColor),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _goToSecondScreen,
          child: const Icon(Icons.swipe),
        ),
      ),
    );
  }
}

class SecondFadingScreen extends StatefulWidget {
  final Color textColor;

  const SecondFadingScreen({required this.textColor, super.key});

  @override
  State<SecondFadingScreen> createState() => _SecondFadingScreenState();
}

class _SecondFadingScreenState extends State<SecondFadingScreen> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second Fading Animation")),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOutBack,
          child: Text(
            'Second Screen Fade!',
            style: TextStyle(fontSize: 24, color: widget.textColor),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
