import 'package:flutter/material.dart';

typedef SegmentedControlCallback = void Function(String value);

class AdvancedSegment extends StatefulWidget {
  AdvancedSegment({
    Key key,
    @required this.segments,
    @required this.value,
    this.onValueChanged,
    this.activeStyle,
    this.inactiveStyle,
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.backgroundColor = Colors.black26,
    this.sliderColor,
  })  : assert(segments != null, 'Property "segments" can\'t be null'),
        assert(segments.length > 1, 'Minimum segments length is 2'),
        super(key: key);

  final Map<String, String> segments;
  final String value;
  final TextStyle activeStyle;
  final TextStyle inactiveStyle;
  final EdgeInsetsGeometry textPadding;
  final BorderRadius borderRadius;
  final ValueChanged<String> onValueChanged;
  final Color sliderColor;
  final Color backgroundColor;

  @override
  _AdvancedSegmentState createState() => _AdvancedSegmentState();
}

class _AdvancedSegmentState extends State<AdvancedSegment> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Size _maxSize;
  Size _itemSize;

  @override
  void initState() {
    super.initState();

    initSizes();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
      value: _obtainAnimationValue(),
    );

    // TODO: Solve animation with more than 2 items.
  }

  @override
  void didUpdateWidget(covariant AdvancedSegment oldWidget) {
    if (oldWidget.value == widget.value) {
      super.didUpdateWidget(oldWidget);
      return;
    }

    _animationController.animateTo(_obtainAnimationValue());

    super.didUpdateWidget(oldWidget);
  }

  void initSizes() {
    _maxSize = widget.segments.values
        .map((text) => _obtainTextSize(text, widget.activeStyle))
        .reduce((value, element) => value > element ? value : element);

    _itemSize = Size(
      _maxSize.width + widget.textPadding.horizontal,
      _maxSize.height + widget.textPadding.vertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _itemSize.width * widget.segments.length,
      height: _itemSize.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: Opacity(
        opacity: widget.onValueChanged != null ? 1 : 0.75,
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
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Tween<Offset>(
            begin: Offset(0, 0),
            end: Offset(_itemSize.width * (widget.segments.length - 1), 0),
          )
              .animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ))
              .value,
          child: child,
        );
      },
      child: Container(
        width: _itemSize.width,
        height: _itemSize.height,
        padding: EdgeInsets.all(2.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.sliderColor ?? theme.cardColor,
            borderRadius: widget.borderRadius.subtract(BorderRadius.circular(2.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
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

      return InkWell(
        onTap: () => _handleSegmentPressed(entry.key),
        child: DefaultTextStyle(
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: selected ? Colors.black45 : Colors.black87,
          ),
          child: Container(
            width: _itemSize.width,
            child: Center(
              child: Text(
                entry.value,
                style: selected ? widget.activeStyle : widget.inactiveStyle,
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

  double _obtainAnimationValue() {
    final index = widget.segments.keys.toList(growable: false).indexOf(widget.value).toDouble();

    return index / (widget.segments.keys.length - 1);
  }

  void _handleSegmentPressed(String value) {
    if (widget.onValueChanged != null) {
      widget.onValueChanged(value);
    }
  }
}
