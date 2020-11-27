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
  String _selectedThreeSegment = 'all';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Advanced Segment'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 50,
          ),
          child: Center(
            child: Column(
              children: [
                _buildLabel('Regular'),
                AdvancedSegment(
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
                _buildLabel('Disabled'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AdvancedSegment(
                      segments: {
                        'all': 'All',
                        'starred': 'Starred',
                      },
                      value: 'all',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AdvancedSegment(
                      segments: {
                        'all': 'All',
                        'starred': 'Starred',
                      },
                      value: 'starred',
                    )
                  ],
                ),
                _buildLabel('Colorized'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AdvancedSegment(
                      segments: {
                        'all': 'All',
                        'starred': 'Starred',
                      },
                      value: _selectedSegment,
                      activeStyle: TextStyle(
                        color: Colors.white,
                      ),
                      inactiveStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      backgroundColor: Colors.orange,
                      sliderColor: Colors.deepOrange,
                      onValueChanged: (segment) {
                        setState(() {
                          _selectedSegment = segment;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AdvancedSegment(
                      segments: {
                        'all': 'All',
                        'starred': 'Starred',
                      },
                      value: _selectedSegment,
                      activeStyle: TextStyle(
                        color: Colors.deepOrange,
                      ),
                      inactiveStyle: TextStyle(
                        color: Colors.orange,
                      ),
                      backgroundColor: Colors.black12,
                      sliderColor: Colors.white,
                      onValueChanged: (segment) {
                        setState(() {
                          _selectedSegment = segment;
                        });
                      },
                    ),
                  ],
                ),
                _buildLabel('Multiple Items'),
                AdvancedSegment(
                  segments: {
                    'all': 'All',
                    'starred': 'Starred',
                    'favorite': 'Favorite',
                  },
                  value: _selectedThreeSegment,
                  onValueChanged: (segment) {
                    setState(() {
                      _selectedThreeSegment = segment;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
      ),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            ),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }
}
