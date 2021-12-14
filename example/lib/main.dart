import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';

enum Segment {
  all,
  starred,
}

extension SegmentsExtension on Segment {
  String get label {
    switch (this) {
      case Segment.all:
        return 'All Files';
      case Segment.starred:
        return 'Starred Files';
      default:
        return 'Unrecognized';
    }
  }

  bool get isAll => this == Segment.all;

  bool get isStarred => this == Segment.starred;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _selectedSegment_00 = ValueNotifier('all');
  final _selectedSegment_01 = ValueNotifier('all');
  final _selectedSegment_02 = ValueNotifier('all');
  final _selectedSegment_03 = ValueNotifier('all');
  final _selectedSegment_04 = ValueNotifier('all');
  final _selectedSegment_05 = ValueNotifier('all');
  final _selectedSegment_06 = ValueNotifier(Segment.all);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Segment Example'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 50,
          ),
          child: Center(
            child: Column(
              children: [
                _buildLabel('Regular & RTL (right-to-left)'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AdvancedSegment(
                      segments: {
                        'all': 'All',
                        'starred': 'Starred',
                      },
                      controller: _selectedSegment_00,
                    ),
                    SizedBox(width: 8),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: AdvancedSegment(
                        controller: _selectedSegment_01,
                        segments: {
                          'all': 'All',
                          'starred': 'Starred',
                        },
                      ),
                    ),
                  ],
                ),
                _buildLabel('Disabled'),
                AdvancedSegment(
                  segments: {
                    'all': 'All',
                    'starred': 'Starred',
                  },
                ),
                _buildLabel('Custom Slider'),
                AdvancedSegment(
                  controller: _selectedSegment_02,
                  segments: {
                    'all': 'All',
                    'starred': 'Starred',
                  },
                  sliderDecoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  activeStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildLabel('Colorized'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AdvancedSegment(
                      controller: _selectedSegment_02,
                      segments: {
                        'all': 'All',
                        'starred': 'Starred',
                      },
                      activeStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      inactiveStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      backgroundColor: Colors.orange,
                      sliderColor: Colors.deepOrange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AdvancedSegment(
                      controller: _selectedSegment_03,
                      segments: {
                        'all': 'All',
                        'starred': 'Starred',
                      },
                      activeStyle: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                      inactiveStyle: TextStyle(
                        color: Colors.orange,
                      ),
                      backgroundColor: Colors.black12,
                      sliderColor: Colors.white,
                    ),
                  ],
                ),
                _buildLabel('Multiple Items'),
                AdvancedSegment(
                  controller: _selectedSegment_04,
                  segments: {
                    'all': 'All',
                    'primary': 'Primary',
                    'secondary': 'Secondary',
                    'tertiary': 'Tertiary',
                  },
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 40,
                  ),
                  padding: const EdgeInsets.all(20),
                  color: Colors.black87,
                  child: Column(
                    children: [
                      _buildLabel('Black Style', color: Colors.white70),
                      Center(
                        child: AdvancedSegment(
                          controller: _selectedSegment_05,
                          segments: {
                            'all': 'All',
                            'missed': 'Missed',
                          },
                          backgroundColor: Colors.white10,
                          activeStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          inactiveStyle: TextStyle(
                            color: Colors.white,
                          ),
                          sliderColor: Colors.white38,
                        ),
                      ),
                      SizedBox(
                        height: 128,
                        child: Center(
                          child: ValueListenableBuilder<String>(
                            valueListenable: _selectedSegment_05,
                            builder: (_, key, __) {
                              switch (key) {
                                case 'all':
                                  return const Text(
                                    'All calls',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                case 'missed':
                                  return const Text(
                                    'Missed calls',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                default:
                                  return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildLabel('Typed keys'),
                AdvancedSegment(
                  controller: _selectedSegment_06,
                  segments: {
                    Segment.all: Segment.all.label,
                    Segment.starred: Segment.starred.label,
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(
    String label, {
    Color color = Colors.black87,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
      ),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            color: color,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          Expanded(
              child: Divider(
            color: color,
          )),
        ],
      ),
    );
  }
}
