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
  String _selectedSegment_0 = 'all';
  String _selectedSegment_1 = 'all';
  String _selectedSegment_2 = 'all';
  String _selectedSegment_3 = 'all';
  String _selectedSegment_4 = 'all';

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
                  value: _selectedSegment_0,
                  onValueChanged: (segment) {
                    setState(() {
                      _selectedSegment_0 = segment;
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
                      value: _selectedSegment_1,
                      activeStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      inactiveStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      backgroundColor: Colors.orange,
                      sliderColor: Colors.deepOrange,
                      onValueChanged: (segment) {
                        setState(() {
                          _selectedSegment_1 = segment;
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
                      value: _selectedSegment_2,
                      activeStyle: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                      inactiveStyle: TextStyle(
                        color: Colors.orange,
                      ),
                      backgroundColor: Colors.black12,
                      sliderColor: Colors.white,
                      onValueChanged: (segment) {
                        setState(() {
                          _selectedSegment_2 = segment;
                        });
                      },
                    ),
                  ],
                ),
                _buildLabel('Multiple Items'),
                AdvancedSegment(
                  segments: {
                    'all': 'All',
                    'primary': 'Primary',
                    'secondary': 'Secondary',
                    'tertiary': 'Tertiary',
                  },
                  value: _selectedSegment_3,
                  onValueChanged: (segment) {
                    setState(() {
                      _selectedSegment_3 = segment;
                    });
                  },
                ),
                _buildLabel('Black Style'),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  color: Colors.black87,
                  child: Center(
                    child: AdvancedSegment(
                      segments: {
                        'all': 'All',
                        'missed': 'Missed',
                      },
                      value: _selectedSegment_4,
                      backgroundColor: Colors.white10,
                      activeStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      inactiveStyle: TextStyle(
                        color: Colors.white,
                      ),
                      sliderColor: Colors.white38,
                      onValueChanged: (segment) {
                        setState(() {
                          _selectedSegment_4 = segment;
                        });
                      },
                    ),
                  ),
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
