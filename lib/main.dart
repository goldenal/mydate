import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  double noButtonTop = 300;
  double noButtonLeft = 100;
  bool yes = false;
  bool showbtn = false;

  final Random random = Random();

  Future<void> sendTelegramMessage() async {
    final url = Uri.parse(
      'https://api.telegram.org/bot7931182591:AAFnKRQAweKtev63uiPLMDoEK4Mzoin5DXc/sendMessage?chat_id=637961341&text=${Uri.encodeComponent("Precious says yes")}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        debugPrint('✅ Message sent successfully!');
      } else {
        debugPrint('❌ Failed to send message. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error sending message: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final double deviceWidth = MediaQuery.of(context).size.width;
      final double deviceHeight = MediaQuery.of(context).size.height;
      setState(() {
        noButtonTop = (deviceHeight - 93.4) * 0.85;
        noButtonLeft = (deviceWidth - 87.3) * 0.5;
      });
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showbtn = true;
      });
    });
  }

  void moveNoButton() {
    // Move the "No" button to a new random position within screen bounds
    setState(() {
      noButtonTop = 100 + random.nextDouble() * 300;
      noButtonLeft = 50 + random.nextDouble() * 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.pinkAccent,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(),
                Text(
                  yes
                      ? "Yeeeeaaah"
                      : 'Hi Precious, will you go out on a date with me!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/${yes ? 2 : 1}.gif',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 10),
                if (!yes)
                  AnimatedOpacity(
                    opacity: showbtn ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          yes = true;
                        });
                        sendTelegramMessage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Yes', style: TextStyle(fontSize: 18)),
                    ),
                  ),
              ],
            ),
            if (!yes)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                top: noButtonTop,
                left: noButtonLeft,
                child: AnimatedOpacity(
                  opacity: showbtn ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: moveNoButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                        ),
                        child: const Text('No', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
