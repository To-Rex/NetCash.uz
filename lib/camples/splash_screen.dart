
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../animated_cursor_position.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SampesPageState createState() => _SampesPageState();
}

class _SampesPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCursorMouseRegion(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white54, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white10,
            ),
            child: CupertinoButton(
              color: Colors.redAccent,
              onPressed: () {
                print('Hello');
              },
              child: Text('Click me!'),
            ),
          ),
          SizedBox(height: 50),
          AnimatedCursorMouseRegion(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white54, width: 2),
              color: Colors.red,
            ),
            child: Container(
              height: 50,
              width: 50,
              color: Colors.blue,
              child: Center(child: Text('Hello')),
            ),
          ),
        ],
      ),
    );
  }
}
