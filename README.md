# flutter_advanced_segment
An advanced segment widget, that can be fully customized with bunch of properties, just try it and enjoy! 

| State 1 | State 2 |
|:-:|:-:|
| ![Flutter Advanced Segment State 1](./SEGMENT_STATE_1.jpg) | ![Flutter Advanced Switch Starred State 2](./SEGMENT_STATE_2.jpg) |

## Getting Started
In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
    ...
    flutter_advanced_segment: <latest_version>
```

Import in your project:

```dart
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
```

## Examples

Regular Segment

```dart
// Create a controller
final _controller = AdvancedSegmentController('all');
//...
AdvancedSegment(
  controller: _controller, // AdvancedSegmentController
  segments: { // Map<String, String>
    'all': 'All',
    'starred': 'Starred',
  },
),
//...
``` 

Customized Segment

```dart
// Create a controller
final _controller = AdvancedSegmentController('all');
//...
AdvancedSegment(
  controller: _controller, // AdvancedSegmentController
  segments: { // Map<String, String>
    'all': 'All',
    'primary': 'Primary',
    'secondary': 'Secondary',
    'tertiary': 'Tertiary',
  },
  activeStyle: TextStyle( // TextStyle
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ),
  inactiveStyle: TextStyle( // TextStyle
    color: Colors.white54,
  ),
  backgroundColor: Colors.black26, // Color
  sliderColor: Colors.white, // Color
  sliderOffset: 2.0, // Double
  borderRadius: const BorderRadius.all(Radius.circular(8.0)), // BorderRadius
  itemPadding: const EdgeInsets.symmetric( // EdgeInsets
    horizontal: 15,
    vertical: 10,
  ),
  animationDuration: Duration(milliseconds: 250), // Duration
  enableSliderShadow: true,
  sliderShadow: const <BoxShadow>[
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8.0,
    ),
  ],
),
//...
``` 

# Demo

![Flutter Advanced Segment Demo](./DEMO.gif)
