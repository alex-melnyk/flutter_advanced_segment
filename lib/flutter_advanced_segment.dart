import 'package:flutter/widgets.dart';

/// An advanced
class AdvancedSegment<K extends Object, V extends String>
    extends StatefulWidget {
  const AdvancedSegment({
    Key? key,
    required this.segments,
    this.controller,
    this.activeStyle = const TextStyle(
      fontWeight: FontWeight.w600,
    ),
    this.inactiveStyle,
    this.itemPadding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.backgroundColor = const Color(0x42000000),
    this.sliderColor = const Color(0xFFFFFFFF),
    this.sliderOffset = 2.0,
    this.animationDuration = const Duration(milliseconds: 250),
    this.shadow = const <BoxShadow>[
      BoxShadow(
        color: Color(0x42000000),
        blurRadius: 8.0,
      ),
    ],
    this.sliderDecoration,
  })  : assert(segments.length > 1, 'Minimum segments amount is 2'),
        super(key: key);

  /// Controls segments selection.
  final ValueNotifier<K>? controller;

  /// Map of segments should be more than one keys.
  final Map<K, V> segments;

  /// Active text style.
  final TextStyle activeStyle;

  /// Inactive text style.
  final TextStyle? inactiveStyle;

  /// Padding of each item.
  final EdgeInsetsGeometry itemPadding;

  /// Common border radius.
  final BorderRadius borderRadius;

  /// Color of slider.
  final Color sliderColor;

  /// Layout background color.
  final Color backgroundColor;

  /// Gap between slider and layout.
  final double sliderOffset;

  /// Selection animation duration.
  final Duration animationDuration;

  /// Slide's Shadow
  final List<BoxShadow>? shadow;

  /// Slider decoration
  final BoxDecoration? sliderDecoration;

  @override
  _AdvancedSegmentState<K, V> createState() => _AdvancedSegmentState();
}

class _AdvancedSegmentState<K extends Object, V extends String>
    extends State<AdvancedSegment<K, V>> with SingleTickerProviderStateMixin {
  static const _defaultTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFF000000),
  );
  late final AnimationController _animationController;
  late final ValueNotifier<K> _defaultController;
  late ValueNotifier<K> _controller;
  late Size _itemSize;
  late Size _containerSize;

  @override
  void initState() {
    super.initState();

    _initSizes();

    _defaultController = ValueNotifier<K>(widget.segments.keys.first);

    _controller = widget.controller ?? _defaultController;
    _controller.addListener(_refreshThumbPosition);

    _animationController = AnimationController(
      vsync: this,
      value: _obtainAnimationValue(),
      duration: widget.animationDuration,
    );
  }

  @override
  void didUpdateWidget(covariant AdvancedSegment<K, V> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_refreshThumbPosition);
      _controller = widget.controller ?? _defaultController;

      _refreshThumbPosition();

      _controller.addListener(_refreshThumbPosition);
    }

    if (oldWidget.segments != widget.segments) {
      _initSizes();

      if (!widget.segments.keys.contains(_controller.value)) {
        _controller.value = widget.segments.keys.first;
      }
      _animationController.value = _obtainAnimationValue();

      _refreshThumbPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<K>(
      valueListenable: _controller,
      builder: (context, value, child) {
        final valueIndex = widget.segments.keys.toList().indexOf(value);

        return Container(
          constraints: BoxConstraints.tightFor(
            width: _containerSize.width,
            height: _containerSize.height,
          ),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius,
          ),
          child: Opacity(
            opacity: widget.controller != null ? 1 : 0.75,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              fit: StackFit.expand,
              children: [
                AnimatedAlign(
                  duration: widget.animationDuration,
                  curve: Curves.ease,
                  alignment: _obtainAlignment(valueIndex),
                  child: FractionallySizedBox(
                    widthFactor: 1 / widget.segments.length,
                    heightFactor: 1,
                    child: Container(
                      margin: EdgeInsets.all(widget.sliderOffset),
                      decoration: widget.sliderDecoration ??
                          BoxDecoration(
                            color: widget.sliderColor,
                            borderRadius: widget.borderRadius.subtract(
                              BorderRadius.all(
                                Radius.circular(widget.sliderOffset),
                              ),
                            ),
                            boxShadow: widget.shadow,
                          ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (final entry in widget.segments.entries)
                      Expanded(
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) =>
                              _handleSegmentMove(
                            details,
                            entry.key,
                            Directionality.of(context),
                          ),
                          onTap: () => _handleSegmentPressed(entry.key),
                          child: Container(
                            height: _itemSize.height,
                            color: const Color(0x00000000),
                            alignment: Alignment.center,
                            child: AnimatedDefaultTextStyle(
                              duration: widget.animationDuration,
                              style: _defaultTextStyle.merge(value == entry.key
                                  ? widget.activeStyle
                                  : widget.inactiveStyle),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                              child: Text(
                                entry.value,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _refreshThumbPosition() {
    final animationValue = _obtainAnimationValue();

    _animationController.animateTo(
      animationValue,
      duration: widget.animationDuration,
    );
  }

  void _initSizes() {
    final maxSize =
        widget.segments.values.map(_obtainTextSize).reduce((value, element) {
      return value.width.compareTo(element.width) >= 1 ? value : element;
    });

    _itemSize = Size(
      maxSize.width + widget.itemPadding.horizontal,
      maxSize.height + widget.itemPadding.vertical,
    );

    _containerSize = Size(
      _itemSize.width * widget.segments.length,
      _itemSize.height,
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

  double _obtainAnimationValue() {
    return widget.segments.keys
            .toList(growable: false)
            .indexOf(_controller.value)
            .toDouble() /
        (widget.segments.keys.length - 1);
  }

  void _handleSegmentPressed(K key) {
    if (widget.controller != null) {
      _controller.value = key;
    }
  }

  void _handleSegmentMove(
    DragUpdateDetails touch,
    K value,
    TextDirection textDirection,
  ) {
    if (widget.controller != null) {
      final indexKey = widget.segments.keys.toList().indexOf(value);

      final indexMove = textDirection == TextDirection.rtl
          ? (_itemSize.width * indexKey - touch.localPosition.dx) /
                  _itemSize.width +
              1
          : (_itemSize.width * indexKey + touch.localPosition.dx) /
              _itemSize.width;

      if (indexMove >= 0 && indexMove <= widget.segments.keys.length) {
        _controller.value = widget.segments.keys.elementAt(indexMove.toInt());
      }
    }
  }

  Alignment _obtainAlignment(int index) {
    final textDirection = Directionality.of(context);
    final alignmentValue = 2 * (index / (widget.segments.length - 1)) - 1;
    return Alignment(
      textDirection == TextDirection.rtl ? -alignmentValue : alignmentValue,
      0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    _controller.removeListener(_refreshThumbPosition);

    _defaultController.dispose();

    super.dispose();
  }
}
