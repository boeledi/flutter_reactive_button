import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// Helper class to determine the position of a widget (via its BuildContext) in the Viewport,
/// considering the case where the screen might be larger than the viewport.
/// In this case, we need to consider the scrolling offset(s).
/// 
class WidgetPosition {
  double xPositionInViewport;
  double yPositionInViewport;
  double viewportWidth;
  double viewportHeight;
  bool isInScrollable = false;
  Axis scrollableAxis;
  double scrollAreaMax;
  double positionInScrollArea;
  Rect rect;

  WidgetPosition({
    this.xPositionInViewport,
    this.yPositionInViewport,
    this.viewportWidth,
    this.viewportHeight,
    this.isInScrollable : false,
    this.scrollableAxis,
    this.scrollAreaMax,
    this.positionInScrollArea,
    this.rect,
  });

  WidgetPosition.fromContext(BuildContext context){
    // Obtain the button RenderObject
    final RenderObject object = context.findRenderObject();
    // Get the physical dimensions and position of the button in the Viewport
    final translation = object?.getTransformTo(null)?.getTranslation();
    // Get the potential Viewport (case of scroll area)
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    // Get the device dimensions and properties
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    // Get the Scroll area state (if any)
    final ScrollableState scrollableState = Scrollable.of(context);
    // Get the physical dimensions and dimensions on the Screen
    final Size size = object?.semanticBounds?.size;

    xPositionInViewport = translation.x;
    yPositionInViewport = translation.y;
    viewportWidth = mediaQueryData.size.width;
    viewportHeight = mediaQueryData.size.height;
    rect = Rect.fromLTWH(translation.x, translation.y, size.width, size.height);

    // If viewport exists, this means that we are inside a Scrolling area
    // Take this opportunity to get the characteristics of that Scrolling area
    if (viewport != null){
      final ScrollPosition position = scrollableState.position;
      final RevealedOffset vpOffset = viewport.getOffsetToReveal(object, 0.0);

      isInScrollable = true;
      scrollAreaMax = position.maxScrollExtent;
      positionInScrollArea = vpOffset.offset;
      scrollableAxis = scrollableState.widget.axis;
    }
  }

  @override
  String toString(){
    return 'X,Y in VP: $xPositionInViewport,$yPositionInViewport  VP dimensions: $viewportWidth,$viewportHeight  ScrollArea max: $scrollAreaMax  X/Y in scroll: $positionInScrollArea  ScrollAxis: $scrollableAxis';
  }
}