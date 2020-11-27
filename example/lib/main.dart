import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedSegment = 'all';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: AdvancedSegment(
            segments: {
              'all': 'All',
              'starred': 'Starred',
            },
            value: _selectedSegment,
            onValueChanged: (segment) {
              setState(() {
                _selectedSegment = segment;
              });
            },
          ),
        ),
      ),
    );
  }
}
