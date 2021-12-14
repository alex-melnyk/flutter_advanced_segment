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
  late AnimationController _animationController;
  late ValueNotifier<K> _controller;
  late Size _itemSize;
  late Size _containerSize;

  @override
  void initState() {
    super.initState();

    _controller =
        widget.controller ?? ValueNotifier<K>(widget.segments.keys.first);

    _controller.addListener(() {
      final animationValue = _obtainAnimationValue();

      _animationController.animateTo(
        animationValue,
        duration: widget.animationDuration,
      );
    });

    initSizes();

    _animationController = AnimationController(
      vsync: this,
      value: _obtainAnimationValue(),
      duration: widget.animationDuration,
    );
  }

  void initSizes() {
    final maxSize = widget.segments.values.map(_obtainTextSize).reduce(
        (value, element) =>
            value.width.compareTo(element.width) >= 1 ? value : element);

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
  void didUpdateWidget(covariant AdvancedSegment<K, V> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.segments != widget.segments) {
      initSizes();

      _animationController.value = _obtainAnimationValue();
    }
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
        opacity: widget.controller != null ? 1 : 0.75,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                return Transform.translate(
                  offset: Tween<Offset>(
                    begin: Offset.zero,
                    end: _obtainEndOffset(Directionality.of(context)),
                  )
                      .animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.linear,
                      ))
                      .value,
                  child: child,
                );
              },
              child: FractionallySizedBox(
                widthFactor: 1 / widget.segments.length,
                heightFactor: 1,
                child: Container(
                  margin: EdgeInsets.all(widget.sliderOffset),
                  // height: _itemSize.height - widget.sliderOffset * 2,
                  decoration: widget.sliderDecoration ??
                      BoxDecoration(
                        color: widget.sliderColor,
                        borderRadius: widget.borderRadius.subtract(
                            BorderRadius.all(
                                Radius.circular(widget.sliderOffset))),
                        boxShadow: widget.shadow,
                      ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, value, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.segments.entries.map((entry) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) => _handleSegmentMove(
                        details,
                        entry.key,
                        Directionality.of(context),
                      ),
                      onTap: () => _handleSegmentPressed(entry.key),
                      child: Container(
                        width: _itemSize.width,
                        height: _itemSize.height,
                        color: const Color(0x00000000),
                        child: AnimatedDefaultTextStyle(
                          duration: widget.animationDuration,
                          style: _defaultTextStyle.merge(value == entry.key
                              ? widget.activeStyle
                              : widget.inactiveStyle),
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
              },
            ),
          ],
        ),
      ),
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

  Offset _obtainEndOffset(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? Offset(-(_itemSize.width * (widget.segments.length - 1)), 0)
        : Offset(_itemSize.width * (widget.segments.length - 1), 0);
  }

  @override
  void dispose() {
    _animationController.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }
}
