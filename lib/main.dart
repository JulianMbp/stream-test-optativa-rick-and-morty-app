import 'package:flutter/material.dart';
import 'package:stream_controller/screens/counter_screen.dart';
import 'package:stream_controller/screens/notification_screen.dart';
import 'package:stream_controller/screens/rick_morty_chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: MenuScreen(),
      routes: {
        '/counter': (context) => CounterScreen(),
        '/notification': (context) => NotificationScreen(),
        '/rick_morty_chat': (context) => RickMortyChatScreen(),
      },
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/counter');
              },
              child: Text('Example counter'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
              child: Text('Example notification'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/rick_morty_chat');
              },
              child: Text('Rick & Morty Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
