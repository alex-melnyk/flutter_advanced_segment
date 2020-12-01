import 'package:flutter/material.dart';

class AdvancedSegment extends StatefulWidget {
  AdvancedSegment({
    Key key,
    @required this.segments,
    @required this.value,
    this.onValueChanged,
    this.activeStyle = const TextStyle(
      fontWeight: FontWeight.w600,
    ),
    this.inactiveStyle,
    this.itemPadding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.backgroundColor = Colors.black26,
    this.sliderColor = Colors.white,
    this.sliderOffset = 2.0,
  })  : assert(segments != null, 'Property "segments" can\'t be null'),
        assert(segments.length > 1, 'Minimum segments length is 2'),
        super(key: key);

  final Map<String, String> segments;
  final String value;
  final TextStyle activeStyle;
  final TextStyle inactiveStyle;
  final EdgeInsetsGeometry itemPadding;
  final BorderRadius borderRadius;
  final ValueChanged<String> onValueChanged;
  final Color sliderColor;
  final Color backgroundColor;
  final double sliderOffset;

  @override
  _AdvancedSegmentState createState() => _AdvancedSegmentState();
}

class _AdvancedSegmentState extends State<AdvancedSegment> with SingleTickerProviderStateMixin {
  final _defaultTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.black,
  );
  final _animationDuration = Duration(milliseconds: 250);
  AnimationController _animationController;
  Size _itemSize;
  Size _containerSize;

  @override
  void initState() {
    initSizes();

    _animationController = AnimationController(
      vsync: this,
      value: _obtainAnimationValue(),
      duration: _animationDuration,
    );

    super.initState();
  }

  void initSizes() {
    final maxSize = widget.segments.values
        .map((text) => _obtainTextSize(text))
        .reduce((value, element) => value.width.compareTo(element.width) >= 1 ? value : element);

    _itemSize = Size(
      maxSize.width + widget.itemPadding.horizontal,
      maxSize.height + widget.itemPadding.vertical,
    );

    _containerSize = Size(
      _itemSize.width * widget.segments.length,
      _itemSize.height,
    );
  }

  @override
  void didUpdateWidget(covariant AdvancedSegment oldWidget) {
    if (oldWidget.segments != widget.segments) {
      initSizes();
    }

    if (oldWidget.value == widget.value) {
      return super.didUpdateWidget(oldWidget);
    }

    _animationController.animateTo(
      _obtainAnimationValue(),
      duration: _animationDuration,
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _containerSize.width,
      height: _containerSize.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: Opacity(
        opacity: widget.onValueChanged != null ? 1 : 0.75,
        child: Stack(
          children: [
            _buildSlider(),
            _buildSegments(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Tween<Offset>(
            begin: Offset(0, 0),
            end: Offset(_itemSize.width * (widget.segments.length - 1), 0),
          )
              .animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.linear,
              ))
              .value,
          child: child,
        );
      },
      child: Container(
        margin: EdgeInsets.all(widget.sliderOffset),
        decoration: BoxDecoration(
          color: widget.sliderColor,
          borderRadius: widget.borderRadius.subtract(BorderRadius.all(Radius.circular(widget.sliderOffset))),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
            ),
          ],
        ),
        child: SizedBox(
          width: _itemSize.width - widget.sliderOffset * 2,
          height: _itemSize.height - widget.sliderOffset * 2,
        ),
      ),
    );
  }

  Widget _buildSegments() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.segments.entries.map((entry) {
        return GestureDetector(
          onTap: () => _handleSegmentPressed(entry.key),
          child: Container(
            width: _itemSize.width,
            height: _itemSize.height,
            color: Colors.transparent,
            child: AnimatedDefaultTextStyle(
              duration: _animationDuration,
              style: _defaultTextStyle.merge(widget.value == entry.key ? widget.activeStyle : widget.inactiveStyle),
              overflow: TextOverflow.clip,
              maxLines: 1,
              softWrap: false,
              child: Center(
                child: Text(entry.value),
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }

  Size _obtainTextSize(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: _defaultTextStyle.merge(widget.activeStyle),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );

    return textPainter.size;
  }

  double _obtainAnimationValue() =>
      widget.segments.keys.toList(growable: false).indexOf(widget.value).toDouble() / (widget.segments.keys.length - 1);

  void _handleSegmentPressed(String value) {
    if (widget.onValueChanged != null) {
      widget.onValueChanged(value);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}
