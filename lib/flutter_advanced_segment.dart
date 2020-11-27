import 'package:flutter/material.dart';
typedef SegmentedControlCallback = void Function(String value);

class Dimension {
  Dimension._();

  static const xs = 5.0;
  static const sm = 15.0;
}

class AdvancedSegment extends StatefulWidget {
  AdvancedSegment({
    Key key,
    @required this.segments,
    @required this.value,
    @required this.onValueChanged,
    this.style = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: Dimension.sm,
      vertical: Dimension.xs,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  })  : assert(segments != null, 'Property "segments" can\'t be null'),
        assert(segments.length > 1, 'Minimum segments length is 2'),
        super(key: key);

  final Map<String, String> segments;
  final String value;
  final TextStyle style;
  final EdgeInsetsGeometry textPadding;
  final BorderRadius borderRadius;
  final ValueChanged<String> onValueChanged;

  @override
  _AdvancedSegmentState createState() => _AdvancedSegmentState();
}

class _AdvancedSegmentState extends State<AdvancedSegment> with TickerProviderStateMixin {
  AnimationController _tapAnimationController;
  AnimationController _slideAnimationController;
  Animation<double> _selectorSizeAnimation;
  Animation<double> _selectorOffsetAnimation;

  Size maxSize;
  Size itemSize;
  String tappedKey;
  int dragIndex;

  @override
  void initState() {
    super.initState();

    initSizes();

    initAnimations();

    final selectedIndex = widget.segments.keys.toList(growable: false).indexOf(widget.value ?? widget.segments.keys.first);
    _slideAnimationController.animateTo(_obtainAnimateValueByIndex(selectedIndex));
  }

  void initSizes() {
    maxSize = widget.segments.values
        .map((text) => _obtainTextSize(text, widget.style))
        .reduce((value, element) => value > element ? value : element);

    itemSize = Size(
      maxSize.width + widget.textPadding.horizontal,
      maxSize.height + widget.textPadding.vertical,
    );
  }

  void initAnimations() {
    _tapAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
    );

    _selectorSizeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_tapAnimationController);

    _slideAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _selectorOffsetAnimation = Tween<double>(
      begin: 0,
      end: itemSize.width * (widget.segments.length - 1),
    ).animate(_slideAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final selectedIndex = _obtainIndexByOffset(details.localPosition);
        final foundItem = widget.segments.keys.toList(growable: false)[selectedIndex];

        setState(() {
          tappedKey = foundItem;
        });

        if (foundItem == widget.value) {
          _tapAnimationController.forward();
        }
      },
      onTapUp: (details) {
        _tapAnimationController.reverse();

        final selectedIndex = _obtainIndexByOffset(details.localPosition);

        _slideAnimationController.animateTo(_obtainAnimateValueByIndex(selectedIndex));

        widget.onValueChanged(widget.segments.keys.toList(growable: false)[selectedIndex]);

        setState(() {
          tappedKey = null;
        });
      },
      onTapCancel: () {
        _tapAnimationController.reverse();

        setState(() {
          tappedKey = null;
        });
      },
      onHorizontalDragStart: (details) {
        _tapAnimationController.forward();

        dragIndex = _obtainIndexByOffset(details.localPosition);
      },
      onHorizontalDragUpdate: (details) {
        final selectedIndex = _obtainIndexByOffset(details.localPosition);

        if (dragIndex != selectedIndex) {
          dragIndex = selectedIndex;

          _slideAnimationController.animateTo(_obtainAnimateValueByIndex(selectedIndex));
        }
      },
      onHorizontalDragEnd: (details) {
        _tapAnimationController.reverse();

        widget.onValueChanged(widget.segments.keys.toList(growable: false)[dragIndex]);

        dragIndex = null;
      },
      child: Container(
        width: itemSize.width * widget.segments.length,
        height: itemSize.height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: widget.borderRadius,
        ),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            _buildSlider(),
            _buildSegments(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _slideAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_selectorOffsetAnimation.value, 0),
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _tapAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _selectorSizeAnimation.value,
            child: Container(
              width: itemSize.width,
              height: itemSize.height,
              padding: EdgeInsets.all(2.0),
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: widget.borderRadius.subtract(BorderRadius.circular(2.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(0, 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegments() {
    final segmentsList = widget.segments.entries.map((entry) {
      final selected = widget.value == entry.key;

      return Container(
        width: itemSize.width,
        child: Center(
          child: AnimatedBuilder(
            animation: _tapAnimationController,
            builder: (context, child) => Transform.scale(
              scale: selected ? _selectorSizeAnimation.value : 1.0,
              child: Opacity(
                opacity: !selected && tappedKey == entry.key ? 0.5 : 1.0,
                child: Text(
                  entry.value,
                  style: widget.style.copyWith(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList(growable: false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: segmentsList,
    );
  }

  Size _obtainTextSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );

    return textPainter.size;
  }

  int _obtainIndexByOffset(Offset offset) {
    for (var i = 0; i < widget.segments.length; i++) {
      final itemRect = Rect.fromLTWH(itemSize.width * i, 0, itemSize.width, itemSize.height);

      if (itemRect.contains(offset)) {
        return i;
      }
    }

    return 0;
  }

  double _obtainAnimateValueByIndex(int index) {
    return (itemSize.width * index) / (itemSize.width * (widget.segments.length - 1));
  }
}
