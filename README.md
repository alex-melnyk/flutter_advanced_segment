# flutter_advanced_segment
An advanced segment widget, that can be fully customized with bunch of properties, just try it and enjoy! 

| State 1 | State 2 |
|:-:|:-:|
| ![Flutter Advanced Segment State 1](./SEGMENT_STATE_1.jpg) | ![Flutter Advanced Segment State 2](./SEGMENT_STATE_2.jpg) |

## Examples

### Use like TabBar

```dart

```

### Regular Segment

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

### Customized Segment

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
  sliderShadow: const <BoxShadow>[
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8.0,
    ),
  ],
),
//...
```

## AdvancedSegment Parameters
|Parameter|Description|Type|Default|
|:--------|:----------|:---|:------|
|`controller`|Manage AdvancedSegment state|*AdvancedSegmentController*||
|`segments`|Map of presented segments|*Map<String, String>*|required|
|`activeStyle`||*TextStyle*|fontWeight: FontWeight.w600|
|`inactiveStyle`||*TextStyle*||
|`backgroundColor`||*Color*|Colors.black26|
|`sliderColor`||*Color*|Colors.white|
|`sliderOffset`||*double*|2.0|
|`borderRadius`||*BorderRadius*|Radius.circular(8.0)|
|`itemPadding`||*EdgeInsets*|EdgeInsets.symmetric(h: 15, v: 10)|
|`animationDuration`||*Duration*|Duration(milliseconds: 250)|
|`sliderShadow`||*BoxShadow*|Shadow|


# Demo

![Flutter Advanced Segment Demo](./DEMO.gif)
