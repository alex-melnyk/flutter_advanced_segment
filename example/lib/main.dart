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
  final _defaultController = ValueNotifier('all');
  final _colorizedController1 = ValueNotifier('all');
  final _colorizedController2 = ValueNotifier('all');
  final _multipleController = ValueNotifier('primary');
  final _sliderController = ValueNotifier('all');
  final _borderController = ValueNotifier('all');
  final _gradientController = ValueNotifier('all');
  final _darkController = ValueNotifier('all');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F7),
          foregroundColor: Color(0xFF1D1D1F),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1F),
            letterSpacing: -0.4,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Segment'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Column(
              children: [
                // Default
                _buildLabel('Default'),
                AdvancedSegment(
                  controller: _defaultController,
                  segments: const {'all': 'All', 'starred': 'Starred'},
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E8ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  sliderColor: Colors.white,
                  activeStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1F),
                  ),
                  inactiveStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF86868B),
                  ),
                ),

                // Colorized
                _buildLabel('Colorized'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AdvancedSegment(
                      controller: _colorizedController1,
                      segments: const {'all': 'All', 'starred': 'Starred'},
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      sliderColor: const Color(0xFFD63B0E),
                      activeStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      inactiveStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AdvancedSegment(
                      controller: _colorizedController2,
                      segments: const {'all': 'All', 'starred': 'Starred'},
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      sliderColor: Colors.white,
                      activeStyle: const TextStyle(
                        color: Color(0xFF0A84FF),
                        fontWeight: FontWeight.w600,
                      ),
                      inactiveStyle: const TextStyle(
                        color: Color(0xFF86868B),
                      ),
                    ),
                  ],
                ),

                // Multiple items
                _buildLabel('Multiple Items'),
                AdvancedSegment(
                  controller: _multipleController,
                  segments: const {
                    'primary': 'Primary',
                    'secondary': 'Secondary',
                    'tertiary': 'Tertiary',
                  },
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  sliderColor: const Color(0xFF30D158),
                  activeStyle: const TextStyle(
                    color: Color(0xFF1C1C1E),
                    fontWeight: FontWeight.w600,
                  ),
                  inactiveStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),

                // Custom slider decoration
                _buildLabel('Custom Slider'),
                AdvancedSegment(
                  controller: _sliderController,
                  segments: const {'all': 'All', 'starred': 'Starred'},
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  sliderDecoration: BoxDecoration(
                    color: const Color(0xFFBF5AF2),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: const Color(0xFFDA8FFF),
                      width: 1.5,
                    ),
                  ),
                  activeStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  inactiveStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),

                // Border
                _buildLabel('Border'),
                AdvancedSegment(
                  controller: _borderController,
                  segments: const {'all': 'All', 'starred': 'Starred'},
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: const Color(0xFF0A84FF),
                      width: 2,
                    ),
                  ),
                  sliderColor: const Color(0xFF0A84FF),
                  activeStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  inactiveStyle: const TextStyle(
                    color: Color(0xFF0A84FF),
                  ),
                ),

                // Gradient
                _buildLabel('Gradient'),
                AdvancedSegment(
                  controller: _gradientController,
                  segments: const {'all': 'All', 'starred': 'Starred'},
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF2D55), Color(0xFFFF9500)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  sliderColor: Colors.white,
                  activeStyle: const TextStyle(
                    color: Color(0xFFFF2D55),
                    fontWeight: FontWeight.w700,
                  ),
                  inactiveStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),

                // Dark style
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 14),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  color: const Color(0xFF1C1C1E),
                  child: Column(
                    children: [
                      _buildLabel('Dark Style', color: const Color(0xFF98989D)),
                      AdvancedSegment(
                        controller: _darkController,
                        segments: const {'all': 'All', 'missed': 'Missed'},
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        sliderColor: const Color(0xFF0A84FF),
                        activeStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        inactiveStyle: const TextStyle(
                          color: Color(0xFF98989D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(
    String label, {
    Color color = const Color(0xFF86868B),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: color.withValues(alpha: 0.3), height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(child: Divider(color: color.withValues(alpha: 0.3), height: 1)),
        ],
      ),
    );
  }
}
